#!/bin/bash
# your-eks-cluster-name
export CLUSTER_NAME=blue

# Retrieve the VPC ID of the EKS cluster
export VPC_ID=$(aws eks describe-cluster --name "$CLUSTER_NAME" --query "cluster.resourcesVpcConfig.vpcId" --output text)
echo "VPC ID: $VPC_ID"

# Retrieve the VPC CIDR block
export VPC_CIDR_BLOCK=$(aws ec2 describe-vpcs --vpc-ids "$VPC_ID" --query "Vpcs[0].CidrBlock" --output text)
echo "VPC CIDR Block: $VPC_CIDR_BLOCK"

# Function to convert IP to integer
function ip2int() {
  local IP=$1
  local a b c d
  IFS=. read -r a b c d <<< "$IP"
  echo $(( (a << 24) + (b << 16) + (c << 8) + d ))
}

# Function to convert integer to IP
function int2ip() {
  local INT=$1
  local a b c d
  a=$(( (INT >> 24) & 255 ))
  b=$(( (INT >> 16) & 255 ))
  c=$(( (INT >> 8) & 255 ))
  d=$(( INT & 255 ))
  echo "$a.$b.$c.$d"
}

# Extract base IP and prefix length

VPC_BASE_IP=${VPC_CIDR_BLOCK%/*}
VPC_PREFIX=${VPC_CIDR_BLOCK#*/}

# Convert VPC base IP to integer
VPC_BASE_INT=$(ip2int "$VPC_BASE_IP")

# Calculate VPC network size
VPC_SIZE=$(( 1 << (32 - VPC_PREFIX) ))

# Retrieve existing subnet CIDR blocks
EXISTING_SUBNET_CIDRS=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[].CidrBlock" --output text)

# Create an associative array to mark used IP ranges
declare -A USED_RANGES

# Mark existing subnets as used
for CIDR in $EXISTING_SUBNET_CIDRS; do
  SUBNET_BASE_IP=${CIDR%/*}
  SUBNET_PREFIX=${CIDR#*/}
  SUBNET_BASE_INT=$(ip2int "$SUBNET_BASE_IP")
  SUBNET_SIZE=$(( 1 << (32 - SUBNET_PREFIX) ))
  for ((i=0; i<SUBNET_SIZE; i+=256)); do
    USED_RANGES[$((SUBNET_BASE_INT + i))]=1
  done
done

# Find available /24 subnets
AVAILABLE_SUBNETS=()
for ((i=0; i<VPC_SIZE; i+=256)); do
  SUBNET_BASE_INT=$((VPC_BASE_INT + i))
  if [ "$SUBNET_BASE_INT" -ge 4294967295 ]; then
    break
  fi
  if [ -z "${USED_RANGES[$SUBNET_BASE_INT]}" ]; then
    SUBNET_BASE_IP=$(int2ip "$SUBNET_BASE_INT")
    AVAILABLE_SUBNETS+=("$SUBNET_BASE_IP/24")
  fi
done

if [ "${#AVAILABLE_SUBNETS[@]}" -lt 2 ]; then
  echo "Not enough available /24 subnets in the VPC."
  exit 1
fi

TEAM_PURPLE_CIDR=${AVAILABLE_SUBNETS[0]}
TEAM_GREEN_CIDR=${AVAILABLE_SUBNETS[1]}

echo "Team Purple CIDR: $TEAM_PURPLE_CIDR"
echo "Team Green CIDR: $TEAM_GREEN_CIDR"


# Team Purple Subnet
TEAM_PURPLE_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$TEAM_PURPLE_CIDR" \
  --availability-zone "$(aws ec2 describe-availability-zones --query "AvailabilityZones[0].ZoneName" --output text)" \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=team-purple-subnet},{Key=karpenter.sh/discovery,Value=$CLUSTER_NAME},{Key=team,Value=purple}]" \
  --query 'Subnet.SubnetId' --output text)
echo "Team Purple Subnet ID: $TEAM_PURPLE_SUBNET_ID"


# Team Green Subnet
TEAM_GREEN_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$TEAM_GREEN_CIDR" \
  --availability-zone "$(aws ec2 describe-availability-zones --query "AvailabilityZones[1].ZoneName" --output text)" \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=team-green-subnet},{Key=karpenter.sh/discovery,Value=$CLUSTER_NAME},{Key=team,Value=green}]" \
  --query 'Subnet.SubnetId' --output text)
echo "Team Green Subnet ID: $TEAM_GREEN_SUBNET_ID"


# Create Security Group
TEAM_PURPLE_SG=$(aws ec2 create-security-group \
  --group-name team-purple-sg \
  --description "Security group for Team Purple nodes" \
  --vpc-id "$VPC_ID" \
  --query 'GroupId' --output text)
echo "Team Purple Security Group ID: $TEAM_PURPLE_SG"

# Inbound Rules: Allow all traffic within VPC
aws ec2 authorize-security-group-ingress \
  --group-id "$TEAM_PURPLE_SG" \
  --protocol -1 \
  --cidr "$VPC_CIDR_BLOCK"

# Outbound Rules: Remove default outbound and allow only within VPC
aws ec2 revoke-security-group-egress --group-id "$TEAM_PURPLE_SG" --protocol -1 --port all --cidr 0.0.0.0/0
aws ec2 authorize-security-group-egress \
  --group-id "$TEAM_PURPLE_SG" \
  --protocol -1 \
  --cidr "$VPC_CIDR_BLOCK"


# Create Security Group
TEAM_GREEN_SG=$(aws ec2 create-security-group \
  --group-name team-green-sg \
  --description "Security group for Team Green nodes" \
  --vpc-id "$VPC_ID" \
  --query 'GroupId' --output text)
echo "Team Green Security Group ID: $TEAM_GREEN_SG"

# Inbound Rules: Allow traffic from Team Purple SG
aws ec2 authorize-security-group-ingress \
  --group-id "$TEAM_GREEN_SG" \
  --protocol -1 \
  --source-group "$TEAM_PURPLE_SG"

# Outbound Rules: Allow all (default)


# Create Internet Gateway if not exists
IGW_ID=$(aws ec2 describe-internet-gateways \
  --filters Name=attachment.vpc-id,Values="$VPC_ID" \
  --query 'InternetGateways[0].InternetGatewayId' --output text)

if [ "$IGW_ID" = "None" ] || [ -z "$IGW_ID" ]; then
  IGW_ID=$(aws ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' --output text)
  aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id "$IGW_ID"
fi
echo "Internet Gateway ID: $IGW_ID"

# Create Route Table
TEAM_GREEN_RT=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --query 'RouteTable.RouteTableId' --output text)
echo "Team Green Route Table ID: $TEAM_GREEN_RT"

# Create Route to IGW
aws ec2 create-route \
  --route-table-id "$TEAM_GREEN_RT" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"

# Associate Route Table with Team Green Subnet
aws ec2 associate-route-table \
  --subnet-id "$TEAM_GREEN_SUBNET_ID" \
  --route-table-id "$TEAM_GREEN_RT"

