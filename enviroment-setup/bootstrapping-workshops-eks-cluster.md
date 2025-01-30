---
icon: gear-code
---

# Bootstrapping Workshop's EKS Cluster

In this section, we will run a script inside CloudShell to set up the EKS cluster.

The script will:

* install [eksdemo](https://github.com/awslabs/eksdemo),
* set up auto-completion for kubectl commands,
* create the EKS cluster,
* install Karpenter, Prometheus, and Grafana,
* deploy a simple workload.

{% hint style="info" %}
For more information about what the script does, you can view the contents on GitHub:\
[https://github.com/k8sug/karpenter-workshop/blob/main/resources/karpenter-workshop-setup.sh](../resources/karpenter-workshop-setup.sh)
{% endhint %}



1. **Download the Setup Script**\
   Execute the following command in CloudShell to download the setup script from GitHub:

{% code overflow="wrap" %}
```bash
curl -s -L "https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/karpenter-workshop-setup.sh" > karpenter-workshop-setup.sh
```
{% endcode %}

2. **Make the Script Executable**\
   Run the following command to give the script execution permissions:

{% code overflow="wrap" %}
```bash
chmod +x karpenter-workshop-setup.sh
```
{% endcode %}

3.  **Run the Script**\


    {% hint style="info" %}
    The script may take approximately 15-20 minutes to complete.
    {% endhint %}

    \
    Execute the script with the following command:

{% code overflow="wrap" %}
```bash
source karpenter-workshop-setup.sh
```
{% endcode %}

4. **Verify Installation**\
   Once the script finishes executing, you will see a successful result message.

<figure><img src="../.gitbook/assets/Complete (3).png" alt=""><figcaption></figcaption></figure>
