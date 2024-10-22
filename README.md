# Agenda

Workshop Title: Optimizing K8S cluster Autoscaling with Karpenter: Cost-Efficiency and Reliability

Target Audience: Managers/CTO, DevOps, Platform Engineers, K8S and Cloud Native community

Prerequisites: \
Laptop with internet connectivity \
Basic knowledge of Kubernetes and EKS (Elastic Kubernetes Service) \
Access to AWS console \
Basic understanding of infrastructure as code (IaC)

By the end of this workshop, participants will: \
Gain a comprehensive understanding of how Karpenter integrates with EKS. \
Learn to configure Karpenter for cost-effective and reliable NodePools. \
Implement strategies to optimize resource allocation, reducing operational costs. \
Acquire hands-on experience with Karpenter configuration and management, applying best practices to optimize resource allocation.

Hands-on Activities:&#x20;

EKS cluster and workshop tool setup: 20 minutes \
While it is setting up Lets learn about Cluster Autoscalling And Karpenter main concepts and the fundamentals objects NodePools and NodeClass.

Once we have our enviroment set, lets import our K8SUG Karpenter Dashboard to grafana so we can monitor and start testing Karpenter.

Default setting test. Deployment scale replicas up and donw and monitor what happens.

Advanced Settings Scenarios

Scenario 1: Cut Cost with Spot Instances

Scenario 2: Working with Custom Subnets

\
\
Setup

AWS access

Setup EKS  - (Cloud Formation/ SDK AWS/ Python/ Terraform/ Helm)

Setup for Karpenter

Setup for Prometheus Grafana&#x20;

Setup for stress test ([https://youtu.be/LRswBUZ2OLM?si=rgzNFIWguGayZAFZ](https://youtu.be/LRswBUZ2OLM?si=rgzNFIWguGayZAFZ))

Setup the simple kube app deploy to trigger autoscalling&#x20;



## Configuration - Customisation

* EC2NodeClass&#x20;
* NodePools

Instances Types and Family Selection

AMI selection

Network selection

Workload selection

Namespace, Tags and so forth



## Testing and Monitoring

Load test to trigger autoscalingOr a simpler option



## Cleaning Up and Questions
