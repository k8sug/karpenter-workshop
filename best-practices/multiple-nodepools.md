# Multiple NodePools

### Best Practices for Setting Up Multiple NodePools

### 1. **Define Clear Use Cases**

* **Team-Based NodePools**: Create separate NodePools for different teams or applications that have distinct requirements, such as operating systems (e.g., Bottlerocket vs. Amazon Linux) or specialised hardware (e.g., GPU nodes).
* **Workload Characteristics**: Different workloads may require varying instance types or configurations. Tailor NodePools to match these characteristics to ensure optimal performance and cost efficiency.

### 2. **Ensure Mutual Exclusivity**

* **Avoid Overlap**: Design NodePools to be mutually exclusive, meaning no pod should match multiple NodePools. This prevents Karpenter from randomly selecting a NodePool, which can lead to unpredictable scheduling outcomes.
* **Use Weights**: If mutual exclusivity isn't feasible, assign weights to NodePools. Karpenter will prioritise the NodePool with the highest weight when multiple pools are matched.

### 3. **Implement Layered Constraints**

* **Complex Scheduling**: Use layered constraints to finely control node provisioning based on pod requirements. This includes specifying taints, labels, and resource limits that align with your cloud provider’s capabilities.
* **Availability Zones**: Consider co-locating pods in specific availability zones to minimise cross-AZ traffic, especially if certain applications must communicate with resources located in those zones.

### 4. **Resource Limits and Expiration**

* **Set Limits**: Define CPU and memory limits for each NodePool to prevent over-provisioning and manage costs effectively. Karpenter will not provision additional nodes once these limits are reached.
* **Node Expiration**: Implement expiration policies for nodes within your NodePools to ensure that underutilized resources are released, optimising cluster efficiency over time.

### 5. **Use Taints and Tolerations Wisely**

* **Control Pod Scheduling**: Utilise taints in your NodePools to restrict which pods can be scheduled on certain nodes. This is especially useful for expensive resources like GPU nodes, ensuring only specific workloads utilise them.
* **Temporary Taints**: Consider using startup taints that are applied temporarily during node initialisation, allowing pods without tolerations to still run on those nodes until the taint is removed by another process.

### 6. **Monitor and Adjust**

* **Continuous Evaluation**: Regularly monitor the performance and utilization of your NodePools. Adjust configurations based on changing workload demands or resource availability to maintain optimal performance.
* **Feedback Loop**: Use feedback from your workloads to refine your NodePool configurations over time, ensuring they remain aligned with operational needs.
