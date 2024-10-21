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

# Delete existing Team Purple Subnet and Team Green Subnet
EXISTING_PURPLE_SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=tag:team,Values=purple" --query "Subnets[0].SubnetId" --output text)
if [ "$EXISTING_PURPLE_SUBNET_ID" != "None" ] && [ -n "$EXISTING_PURPLE_SUBNET_ID" ]; then
  aws ec2 delete-subnet --subnet-id "$EXISTING_PURPLE_SUBNET_ID"
  echo "Deleted existing Team Purple Subnet: $EXISTING_PURPLE_SUBNET_ID"
fi

EXISTING_GREEN_SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=tag:team,Values=green" --query "Subnets[0].SubnetId" --output text)
if [ "$EXISTING_GREEN_SUBNET_ID" != "None" ] && [ -n "$EXISTING_GREEN_SUBNET_ID" ]; then
  aws ec2 delete-subnet --subnet-id "$EXISTING_GREEN_SUBNET_ID"
  echo "Deleted existing Team Green Subnet: $EXISTING_GREEN_SUBNET_ID"
fi

# Create Team Purple Subnet (Private)
TEAM_PURPLE_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$TEAM_PURPLE_CIDR" \
  --availability-zone "$(aws ec2 describe-availability-zones --query "AvailabilityZones[0].ZoneName" --output text)" \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=team-purple-subnet},{Key=karpenter.sh/discovery,Value=$CLUSTER_NAME},{Key=team,Value=purple},{Key=kubernetes.io/cluster/$CLUSTER_NAME,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]" \
  --query 'Subnet.SubnetId' --output text)
echo "Team Purple Subnet ID: $TEAM_PURPLE_SUBNET_ID"

# Create Team Green Subnet (Private)
TEAM_GREEN_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$TEAM_GREEN_CIDR" \
  --availability-zone "$(aws ec2 describe-availability-zones --query "AvailabilityZones[1].ZoneName" --output text)" \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=team-green-subnet},{Key=karpenter.sh/discovery,Value=$CLUSTER_NAME},{Key=team,Value=green},{Key=kubernetes.io/cluster/$CLUSTER_NAME,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]" \
  --query 'Subnet.SubnetId' --output text)
echo "Team Green Subnet ID: $TEAM_GREEN_SUBNET_ID"

# Retrieve the NAT Gateway ID
NAT_GATEWAY_ID=$(aws ec2 describe-nat-gateways \
  --filter "Name=vpc-id,Values=$VPC_ID" "Name=state,Values=available" \
  --query "NatGateways[0].NatGatewayId" --output text)
echo "NAT Gateway ID: $NAT_GATEWAY_ID"

# Create a route table for Team Purple Subnet and name it
TEAM_PURPLE_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=team-purple-route-table},{Key=karpenter.sh/discovery,Value=$CLUSTER_NAME},{Key=team,Value=purple},{Key=kubernetes.io/cluster/$CLUSTER_NAME,Value=shared}]" \
  --query 'RouteTable.RouteTableId' --output text)
echo "Team Purple Route Table ID: $TEAM_PURPLE_ROUTE_TABLE_ID"

# Associate the route table with the Team Purple Subnet
aws ec2 associate-route-table \
  --route-table-id "$TEAM_PURPLE_ROUTE_TABLE_ID" \
  --subnet-id "$TEAM_PURPLE_SUBNET_ID"

# Create a default route to the NAT Gateway for Team Purple
aws ec2 create-route \
  --route-table-id "$TEAM_PURPLE_ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id "$NAT_GATEWAY_ID"

# Create a route table for Team Green Subnet and name it
TEAM_GREEN_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=team-green-route-table},{Key=karpenter.sh/discovery,Value=$CLUSTER_NAME},{Key=team,Value=green},{Key=kubernetes.io/cluster/$CLUSTER_NAME,Value=shared}]" \
  --query 'RouteTable.RouteTableId' --output text)
echo "Team Green Route Table ID: $TEAM_GREEN_ROUTE_TABLE_ID"

# Associate the route table with the Team Green Subnet
aws ec2 associate-route-table \
  --route-table-id "$TEAM_GREEN_ROUTE_TABLE_ID" \
  --subnet-id "$TEAM_GREEN_SUBNET_ID"

# Create a default route to the NAT Gateway for Team Green
aws ec2 create-route \
  --route-table-id "$TEAM_GREEN_ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id "$NAT_GATEWAY_ID"

# Output completion message
echo "Subnets created and configured successfully."
