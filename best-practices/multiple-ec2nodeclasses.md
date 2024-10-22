# Multiple EC2NodeClasses

### Best Practices for Setting Up Multiple EC2NodeClasses

### 1. **Define Specific Use Cases**

* **Workload Optimisation**: Create separate EC2NodeClasses for different types of workloads, such as general-purpose, memory-optimised, or compute-optimised tasks. This ensures that each workload runs on the most suitable instance type .
* **Specialised Needs**: Use distinct NodeClasses for specialised requirements, such as GPU instances for machine learning tasks or high I/O instances for databases .

### 2. **Leverage AMI Selection Wisely**

* **AMI Family Specification**: Specify the `amiFamily` in your EC2NodeClass to ensure that Karpenter provisions nodes with the latest Amazon EKS-optimised AMIs that match your cluster's version . This helps maintain consistency and security across your instances.
* **Custom AMIs**: If using custom AMIs, utilise `amiSelectorTerms` to define criteria for selecting the appropriate AMI. This is particularly useful if you have different AMIs for various applications or environments .

### 3. **Utilise Security Groups and Subnets**

* **Network Configuration**: Define `securityGroupSelectorTerms` and `subnetSelectorTerms` in your EC2NodeClass to control the networking environment of your nodes. This ensures that nodes are launched in the correct subnets and have the appropriate security configurations .
* **Isolation of Resources**: Use different security groups for different NodeClasses to isolate resources based on sensitivity or compliance requirements .

### 4. **IAM Role Management**

* **Role Specification**: Clearly specify an IAM role in your EC2NodeClass to manage permissions effectively. This role should have sufficient permissions to launch and manage EC2 instances as required by your workloads .
* **Instance Profile Management**: Avoid using `instanceProfile` unless you have pre-provisioned profiles. Instead, rely on Karpenter to manage instance profiles through roles, simplifying management and reducing errors .

### 5. **Monitor Resource Utilization**

* **Performance Tracking**: Regularly monitor the performance and utilisation of instances provisioned under each EC2NodeClass. Adjust configurations based on usage patterns to optimise costs and performance .
* **Scaling Strategies**: Implement scaling strategies based on workload demands, ensuring that each NodeClass can dynamically adjust to varying resource needs .

### 6. **Implement Taints and Tolerations**

* **Controlled Scheduling**: Use taints in your EC2NodeClasses to restrict which pods can be scheduled on certain nodes. This is particularly beneficial for high-cost resources or specialised hardware, ensuring only appropriate workloads utilise them .

### 7. **Documentation and Version Control**

* **Maintain Clear Documentation**: Document the purpose and configuration of each EC2NodeClass clearly. This aids in managing changes over time and assists team members in understanding the architecture .
* **Version Control Practices**: Use version control for your Karpenter configurations to track changes over time, making it easier to roll back if necessary .
