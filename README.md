# 🔰 Introduction and Welcome

**Introduction and Welcome:**

Welcome to the K8SUG CTL - Hands-on Workshop at NAB titled **"Optimizing K8S Cluster Autoscaling with Karpenter: Cost-Efficiency and Reliability."** In today’s session, we’ll dive into Karpenter, an open-source cluster autoscaler designed to scale Kubernetes workloads efficiently and reliably.

Our target audience includes **Managers, CTOs, DevOps Engineers, Platform Engineers**, and members of the **Kubernetes and Cloud Native community**. Whether you’re focused on reducing operational costs or improving the resilience and reliability of your clusters, this workshop is designed to provide valuable insights and hands-on experience.

#### Agenda Overview:

Throughout this hands-on workshop, you’ll learn how to leverage **Karpenter** to optimise your **EKS clusters** for cost and performance. By the end of this session, you will:

* **Gain a deep understanding** of Karpenter’s integration with EKS.
* Learn to **configure Karpenter** for cost-effective **NodePools** and **NodeClasses**.
* Implement strategies for **resource optimisation**, which will help reduce operational costs.
* Acquire practical skills in **monitoring**, **testing**, and **configuring** Karpenter with real-world scenarios.

We’ll begin with setting up the workshop environment, including AWS Lab access, navigating the AWS console, and bootstrapping the EKS cluster. As the environment is set up, we’ll discuss **Cluster Autoscaling 101**, the difference between the native AWS autoscaler and Karpenter, and cover the historical context of AWS’s adoption of Karpenter through the CNCF.

Once the environment is ready, we will move forward with testing default settings, followed by advanced configurations to unlock **cost-saving opportunities** such as **Spot Instances** and **Custom Subnet** management, while monitoring it using **Grafana and Prometheus**.

At the end of the workshop, you’ll be able to confidently apply **best practices** in **NodeClass** and **NodePool management**, ensuring your infrastructure is both reliable and cost-efficient.

***

#### Hands-On Activities Include:

1. **EKS Cluster and Workshop Tool Setup**:
   * AWS Lab access and console navigation.
   * Karpenter, Prometheus, and Grafana installation.
2. **Cluster Autoscaling Concepts**:
   * Deep dive into **NodePools** and **NodeClasses**.
   * Testing the default configurations with auto-scaling events (scale-up and scale-down).
3. **Advanced Configuration Scenarios**:
   * **Scenario 1**: Cutting costs with **Spot Instances**.
   * **Scenario 2**: Managing **Custom Subnets** for more tailored configurations.
4. **Testing and Monitoring**:
   * Load tests to trigger autoscaling and monitor **Grafana dashboards**.
5. **Wrap-Up and Cleanup**:
   * Guidance on cleaning up AWS resources after the session.
   * Q\&A to clarify any remaining questions.

***

#### Workshop Prerequisites:

* A laptop with internet connectivity.
* Basic knowledge of **Kubernetes** and **EKS (Elastic Kubernetes Service)**.
* Access to the **AWS Console**.
* A basic understanding of **Infrastructure as Code (IaC)** principles.

***

We look forward to guiding you through this hands-on session where you will gain both the knowledge and practical skills to make your Kubernetes clusters more cost-effective and reliable with Karpenter. Let's get started!
