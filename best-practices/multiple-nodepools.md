# Multiple NodePools

### Best Practices for Setting Up Multiple NodePools

### 1. **Define Clear Use Cases**

* **Team-Based NodePools**: Create separate NodePools for different teams or applications that have distinct requirements, such as operating systems (e.g., Bottlerocket vs. Amazon Linux) or specialized hardware (e.g., GPU nodes) [1](https://docs.aws.amazon.com/eks/latest/best-practices/karpenter.html)[2](https://karpenter.sh/docs/concepts/nodepools/).
* **Workload Characteristics**: Different workloads may require varying instance types or configurations. Tailor NodePools to match these characteristics to ensure optimal performance and cost efficiency [1](https://docs.aws.amazon.com/eks/latest/best-practices/karpenter.html).

### 2. **Ensure Mutual Exclusivity**

* **Avoid Overlap**: Design NodePools to be mutually exclusive, meaning no pod should match multiple NodePools. This prevents Karpenter from randomly selecting a NodePool, which can lead to unpredictable scheduling outcomes [2](https://karpenter.sh/docs/concepts/nodepools/)[4](https://karpenter.sh/v0.37/faq/).
* **Use Weights**: If mutual exclusivity isn't feasible, assign weights to NodePools. Karpenter will prioritize the NodePool with the highest weight when multiple pools are matched [1](https://docs.aws.amazon.com/eks/latest/best-practices/karpenter.html)[4](https://karpenter.sh/v0.37/faq/).

### 3. **Implement Layered Constraints**

* **Complex Scheduling**: Use layered constraints to finely control node provisioning based on pod requirements. This includes specifying taints, labels, and resource limits that align with your cloud provider’s capabilities [1](https://docs.aws.amazon.com/eks/latest/best-practices/karpenter.html)[2](https://karpenter.sh/docs/concepts/nodepools/).
* **Availability Zones**: Consider co-locating pods in specific availability zones to minimize cross-AZ traffic, especially if certain applications must communicate with resources located in those zones [1](https://docs.aws.amazon.com/eks/latest/best-practices/karpenter.html).

### 4. **Resource Limits and Expiration**

* **Set Limits**: Define CPU and memory limits for each NodePool to prevent over-provisioning and manage costs effectively. Karpenter will not provision additional nodes once these limits are reached [5](https://www.eksworkshop.com/docs/autoscaling/compute/karpenter/setup-provisioner).
* **Node Expiration**: Implement expiration policies for nodes within your NodePools to ensure that underutilized resources are released, optimizing cluster efficiency over time [6](https://aws.amazon.com/blogs/compute/applying-spot-to-spot-consolidation-best-practices-with-karpenter/).

### 5. **Use Taints and Tolerations Wisely**

* **Control Pod Scheduling**: Utilize taints in your NodePools to restrict which pods can be scheduled on certain nodes. This is especially useful for expensive resources like GPU nodes, ensuring only specific workloads utilize them [2](https://karpenter.sh/docs/concepts/nodepools/)[3](https://karpenter.sh/v0.37/concepts/nodepools/).
* **Temporary Taints**: Consider using startup taints that are applied temporarily during node initialization, allowing pods without tolerations to still run on those nodes until the taint is removed by another process [2](https://karpenter.sh/docs/concepts/nodepools/).

### 6. **Monitor and Adjust**

* **Continuous Evaluation**: Regularly monitor the performance and utilization of your NodePools. Adjust configurations based on changing workload demands or resource availability to maintain optimal performance [6](https://aws.amazon.com/blogs/compute/applying-spot-to-spot-consolidation-best-practices-with-karpenter/).
* **Feedback Loop**: Use feedback from your workloads to refine your NodePool configurations over time, ensuring they remain aligned with operational needs.
