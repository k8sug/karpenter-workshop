---
icon: circle-nodes
---

# Working with Custom Subnets

### Purpose

This blueprint demonstrates how to configure Karpenter to provision nodes in custom subnets, allowing different teams to have their own dedicated subnets and node configurations. By defining separate `EC2NodeClass` and `NodePool` resources for each team, workloads can be isolated within specific subnets, enhancing network segmentation and security. This setup is ideal for multi-tenant Kubernetes clusters where teams require isolated network environments.

### Requirements

* **Kubernetes Cluster**: A running Kubernetes cluster with Karpenter installed and configured.
* **AWS Configuration**:
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
* **Security Groups**: Verify security groups have the following tags:
  * Common cluster tag: `aws:eks:cluster-name: blue`

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
