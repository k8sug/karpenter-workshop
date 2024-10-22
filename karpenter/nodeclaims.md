# NodeClaims

Karpenter uses NodeClaims to manage the lifecycle of Kubernetes Nodes with the underlying cloud provider. Karpenter will create and delete NodeClaims in response to the demands of Pods in the cluster. It does this by evaluating the requirements of pending pods, finding a compatible [NodePool](https://karpenter.sh/docs/concepts/nodepools/) and [NodeClass](https://karpenter.sh/docs/concepts/nodeclasses/) pair, and creating a NodeClaim which meets both sets of requirements. Although NodeClaims are immutable resources managed by Karpenter, you can monitor NodeClaims to keep track of the status of your Nodes.

<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption><p> NodeClaims interacting with other components</p></figcaption></figure>

