#!/bin/bash
# Set your EKS cluster name
export CLUSTER_NAME=blue

# Retrieve the VPC ID of the EKS cluster
export VPC_ID=$(aws eks describe-cluster --name "$CLUSTER_NAME" --query "cluster.resourcesVpcConfig.vpcId" --output text)
echo "VPC ID: $VPC_ID"

# Function to delete a subnet by tag
delete_subnet_by_tag() {
  local TEAM_COLOR=$1
  SUBNET_ID=$(aws ec2 describe-subnets \
    --filters "Name=tag:team,Values=$TEAM_COLOR" \
    --query "Subnets[].SubnetId" --output text)
  
  if [ -n "$SUBNET_ID" ]; then
    echo "Deleting subnet(s) for team '$TEAM_COLOR': $SUBNET_ID"
    aws ec2 delete-subnet --subnet-id "$SUBNET_ID"
  else
    echo "No subnet found for team '$TEAM_COLOR'."
  fi
}

# Function to delete route table by tag
delete_route_table_by_tag() {
  local TEAM_COLOR=$1
  ROUTE_TABLE_ID=$(aws ec2 describe-route-tables \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=team-$TEAM_COLOR-route-table" \
    --query "RouteTables[].RouteTableId" --output text)

  if [ -n "$ROUTE_TABLE_ID" ]; then
    echo "Processing route table for team '$TEAM_COLOR': $ROUTE_TABLE_ID"

    # Disassociate any subnets associated with this route table
    ASSOCIATIONS=$(aws ec2 describe-route-tables \
      --route-table-id "$ROUTE_TABLE_ID" \
      --query "RouteTables[].Associations[].RouteTableAssociationId" --output text)

    for ASSOC_ID in $ASSOCIATIONS; do
      echo "Disassociating route table association: $ASSOC_ID"
      aws ec2 disassociate-route-table --association-id "$ASSOC_ID"
    done

    # Delete routes in the route table (except the local route)
    ROUTE_DESTINATIONS=$(aws ec2 describe-route-tables \
      --route-table-id "$ROUTE_TABLE_ID" \
      --query "RouteTables[].Routes[?DestinationCidrBlock!='${VPC_CIDR_BLOCK}' && GatewayId!='local'].DestinationCidrBlock" --output text)

    for DEST in $ROUTE_DESTINATIONS; do
      echo "Deleting route to destination: $DEST"
      aws ec2 delete-route --route-table-id "$ROUTE_TABLE_ID" --destination-cidr-block "$DEST"
    done

    # Finally, delete the route table
    echo "Deleting route table: $ROUTE_TABLE_ID"
    aws ec2 delete-route-table --route-table-id "$ROUTE_TABLE_ID"
  else
    echo "No route table found for team '$TEAM_COLOR'."
  fi
}

# Delete subnets for Team Purple and Team Green
delete_subnet_by_tag "purple"
delete_subnet_by_tag "green"

# Delete route tables for Team Purple and Team Green
delete_route_table_by_tag "purple"
delete_route_table_by_tag "green"

echo "Deletion of subnets and route tables completed."
