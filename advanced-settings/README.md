---
icon: wpexplorer
---

# Exploring Scenarios

Now that we've covered the fundamentals, let's dive into Karpenter's capabilities. In this workshop, we'll focus on two key scenarios:

* **Scenario 1**: Reducing costs using **Spot Instances**.
* **Scenario 2**: Managing **Custom Subnets** for more specific configurations.

These scenarios are based on the **aws-sample/karpenter-blueprints** structure. For additional scenarios, you can explore more at the following link:

{% embed url="https://github.com/aws-samples/karpenter-blueprints" %}
Karpenter blueprints
{% endembed %}

This repository includes a list of common workload scenarios, some of them go in depth with the explanation of why configuring Karpenter and Kubernetes objects in such a way is important.

### Blueprint Structure

Each blueprint follows the same structure to help you better understand what's the motivation and the expected results:

| Concept      | Description                                                                               |
| ------------ | ----------------------------------------------------------------------------------------- |
| Purpose      | Explains what the blueprint is about, and what problem is solving.                        |
| Requirements | Any pre-requisites you might need to use the blueprint (i.e. An `arm64` container image). |
| Deploy       | The steps to follow to deploy the blueprint into an existing Kubernetes cluster.          |
| Results      | The expected results when using the blueprint.                                            |
