# Cluster Autoscalling 101

## Introduction

Kubernetes requires nodes to run pods, providing capacity for both workloads and the Kubernetes system itself. Node autoscaling allows you to automatically adjust the resources in your cluster by either changing the number of nodes (horizontal scaling) or altering the capacity of existing nodes (vertical scaling). Kubernetes supports multidimensional automatic scaling to adapt to varying demands.

{% embed url="https://kubernetes.io/docs/concepts/cluster-administration/cluster-autoscaling/" %}

## Automatic horizontal scaling <a href="#autoscaling-horizontal" id="autoscaling-horizontal"></a>

### Cluster Autoscaler (CA)

<figure><img src=".gitbook/assets/image (9).png" alt=""><figcaption><p>Custer Autoscaler</p></figcaption></figure>

The Cluster Autoscaler automatically manages the scaling of nodes by integrating with cloud providers or Kubernetes' cluster API. It adds nodes when pods are unschedulable and removes nodes when they become unnecessary. CA scales Kubernetes node groups up and down by monitoring pending pods that cannot fit onto existing nodes and provisioning new ones based on node group definitions and underlying Auto Scaling Groups.

On AWS, while you can define multiple instance types for your node groups, CA calculates scaling based on a single instance type. This means you have less control over which instance types are actually provisioned, potentially leading to mismatched capacities and the need for further adjustments.

### Karpenter

<figure><img src=".gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

Karpenter is an open-source project that automates node provisioning and deprovisioning based on pod scheduling needs, enhancing scaling efficiency and cost optimization. Its main functions include:

* Monitoring pods that cannot be scheduled due to resource constraints.
* Evaluating the scheduling requirements of unschedulable pods.
* Provisioning new nodes that meet those requirements.
* Removing nodes when they are no longer needed.

With Karpenter, you can define NodePools with constraints such as taints, labels, instance types, zones, and total resource limits. When deploying workloads, you can specify scheduling constraints in the pod specification, and Karpenter will provision appropriately sized nodes to match those needs. It supports direct node management via cloud provider integrations, optimizing for overall cost and efficiency.

## Comparison of Cluster Autoscaler (CA) and Karpenter

<table data-full-width="true"><thead><tr><th>Aspect</th><th>Cluster Autoscaler (CA)</th><th>Karpenter</th><th>Best Option</th></tr></thead><tbody><tr><td><strong>Scaling Mechanism</strong></td><td>Adds/removes nodes based on unschedulable pods.</td><td>Provisions/deprovisions nodes based on detailed pod scheduling requirements.</td><td><strong>Karpenter</strong></td></tr><tr><td><strong>Integration</strong></td><td>Integrates with cloud providers and Kubernetes' cluster API.</td><td>Supports direct node management via cloud provider plugins.</td><td>Depends on needs</td></tr><tr><td><strong>Instance Type Selection</strong></td><td>Calculates scaling based on a single instance type in a node group, leading to less control over actual instances provisioned.</td><td>Evaluates pod requirements and provisions right-sized nodes matching specified constraints.</td><td><strong>Karpenter</strong></td></tr><tr><td><strong>Customization</strong></td><td>Works with predefined node groups and Auto Scaling Groups.</td><td>Allows defining NodePools with constraints (taints, labels, instance types, zones) and resource limits.</td><td><strong>Karpenter</strong></td></tr><tr><td><strong>Cost Optimization</strong></td><td>May result in mismatched capacities, requiring additional adjustments and potentially increasing costs.</td><td>Optimizes cost by provisioning appropriate resources that match actual needs.</td><td><strong>Karpenter</strong></td></tr><tr><td><strong>Complexity</strong></td><td>Simpler configuration using existing node groups.</td><td>May require more setup to define NodePools and understand advanced features.</td><td><strong>CA</strong></td></tr><tr><td><strong>Community Support</strong></td><td>Established tool with wide adoption and extensive community support.</td><td>Newer project with growing community and support.</td><td><strong>CA</strong></td></tr><tr><td><strong>Pod Scheduling Considerations</strong></td><td>Adds nodes when pods are unschedulable but may not consider detailed scheduling constraints.</td><td>Considers detailed scheduling requirements like resource requests, node selectors, affinities, tolerations, and topology spread constraints when provisioning nodes.</td><td><strong>Karpenter</strong></td></tr><tr><td><strong>Node Patch Management</strong></td><td>Relies on underlying infrastructure for node image updates; less flexibility in AMI selection and validation.</td><td>Offers flexible node patch management with support for custom AMIs and controlled AMI selection; can integrate with tools like Amazon EKS AMI Tester for validation.</td><td><strong>Karpenter</strong></td></tr><tr><td><strong>Bin Packing Efficiency</strong></td><td>Basic bin packing capabilities; may not fully optimize resource utilization across nodes.</td><td>High bin packing efficiency by right-sizing nodes and continuously consolidating workloads to improve resource utilization.</td><td>Karpenter</td></tr></tbody></table>

