---
icon: circle-nodes
description: Managing Custom Subnets for more tailored configuration
---

# Working with Custom Subnets

### Purpose

This blueprint demonstrates how to configure Karpenter to provision nodes in custom subnets, allowing different teams to have their own dedicated subnets and node configurations. By defining separate `EC2NodeClass` and `NodePool` resources for each team, workloads can be isolated within specific subnets, enhancing network segmentation and security. This setup is ideal for multi-tenant Kubernetes clusters where teams require isolated network environments.

### Requirements

* **Kubernetes Cluster**: A running Kubernetes cluster with Karpenter installed and configured.
* **AWS Configuration**:
  * An AWS EKS cluster named `blue` (as referenced in security group tags).
  * AWS subnets tagged for each team (e.g., `team: purple` and `team: green`).
* **kubectl Access**: Administrative access to the cluster via `kubectl`.

### Setup

**Create a directory for this scenario**

```bash
cd ~
mkdir subnets && cd subnets
```

**Download yaml and bash script files**

{% code overflow="wrap" %}
```bash
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/working-with-subnets/create-subnets.sh > create-subnets.sh
chmod +x create-subnets.sh
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/working-with-subnets/delete-subnets.sh > delete-subnets.sh
chmod +x delete-subnets.sh
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/working-with-subnets/subnets-nodeclass-nodepool.yaml > subnets-nodeclass-nodepool.yaml
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/working-with-subnets/workload-subnets.yaml > workload-subnets.yaml
```
{% endcode %}

**Create Subnets**

```bash
./create-subnets.sh
```

### Deploy

#### Verify AWS Subnets and Security Groups

* **Subnets**: Ensure AWS subnets are tagged with `team: purple` and `team: green`.

```bash
aws ec2 describe-subnets --filters "Name=tag:team,Values=purple"
```

```bash
aws ec2 describe-subnets --filters "Name=tag:team,Values=green"
```

* **Security Groups**: Verify security groups have the following tags:
  * Common cluster tag: `aws:eks:cluster-name: blue`

{% tabs %}
{% tab title="EC2NodeClass.yaml" %}
{% code overflow="wrap" fullWidth="true" %}
```yaml
# Define an EC2NodeClass resource for Team Green
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: team-green-nodeclass # Name of the EC2NodeClass
  labels:
    karpenter.sh/discovery: blue 
spec:
  role: KarpenterNodeRole-blue 
  tags:
    team: green # Tag indicating the team
  amiFamily: AL2
  amiSelectorTerms:
  - id: ami-01637a5ffbb75ef5c
  - id: ami-0f9b86b5fcf375aca
# Each term in the array of subnetSelectorTerms is ORed together
# Within a single term, all conditions are ANDed
  subnetSelectorTerms:
   # Select on any subnet that has "team: green" tag
  - tags:
      team: green # Subnet tag for the team
  securityGroupSelectorTerms:
  - tags:
      aws:eks:cluster-name: blue
  - tags:
      team: green # Security group tag for the team
```
{% endcode %}
{% endtab %}

{% tab title="NodePool.yaml" %}
{% code overflow="wrap" %}
```yaml
# Define a NodePool resource for Team Green
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: team-green-nodepool
spec:
  template:
    metadata:
    # Labels are arbitrary key-values that are applied to all nodes
      labels:
        team: green # tag for the team
    spec:
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: team-green-nodeclass # Name of the referenced EC2NodeClass
      # Provisioned nodes will have these taints
      # Taints may prevent pods from scheduling if they are not tolerated by the pod.
      taints:
        - key: team
          value: green
          effect: NoSchedulee
      requirements:
        - key: "karpenter.sh/capacity-type"
          operator: "In"
          values: ["spot"]
```
{% endcode %}
{% endtab %}

{% tab title="Deployment.yaml" %}
{% code overflow="wrap" fullWidth="true" %}
```yaml
#Application for Team Green
apiVersion: apps/v1
kind: Deployment
metadata:
  name: team-green-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: team-green-app
  template:
    metadata:
      labels:
        app: team-green-app
        team: green
    spec:
      nodeSelector:
        team: green
      tolerations:
        - key: team
          value: green
          effect: NoSchedule
      containers:
        - name: curl-container
          image: appropriate/curl
          command: ["/bin/sh", "-c", "while true; do echo 'Team Green Pod'; sleep 3600; done"]
```
{% endcode %}
{% endtab %}
{% endtabs %}

#### **Apply the EC2NodeClass and NodePool resources  and** Deploy Team-specific Applications

```bash
kubectl apply -f .
```

#### Verify Node Provisioning and Pod Scheduling

**Check Nodes:**

Verify that nodes are provisioned with the correct labels and configurations.

```bash
kubectl get nodes --show-labels
```

**Check Pods:**

Ensure that pods are running and scheduled on the correct nodes.

```bash
kubectl get pods -o wide
```

**Describe a Node (Optional):**

Inspect node details to confirm subnet and security group assignments.

```bash
kubectl describe node <node-name>
```

Replace `<node-name>` with the name of a node from the output of `kubectl get nodes`.

### Results

* **Isolated Environments**: Applications for Team Purple and Team Green are running in separate subnets, providing network isolation.
* **Customised Node Provisioning**: Nodes are provisioned with team-specific configurations, including AMIs, subnets, and security groups.
* **Dynamic Scaling**: Karpenter automatically adjusts node capacity based on the needs of each team's applications.
* **Verification**: Nodes and pods can be verified to confirm they are correctly associated with their respective teams.

By following this blueprint, you achieve a multi-tenant Kubernetes environment where each team's workloads are securely and efficiently managed within their own custom subnets.

### Cleanup

To clean up the resources in this scenario, delete sub by running the following command:

```bash
#from subnets directory
kubectl delete -f .
```

Also delete subnets by executin `delete-subnets.sh`

<pre class="language-bash"><code class="lang-bash"><strong>#from subnets directory
</strong><strong>./delete-subnets.sh
</strong></code></pre>
