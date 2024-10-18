---
description: This will set a cluster and all tools needed for this workshop
---

# Enviroment Setup

## 1 - Access AWS Console

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Set region to ap-southeast-2 Sydday and open CloudShell
{% endhint %}

<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Get the bash script from github:

<pre data-title="karpenter-workshop-setup.sh" data-overflow="wrap" data-full-width="false"><code><strong>#execute this on CloudShell
</strong><strong>curl -s -L "https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/karpenter-workshop-setup.sh" > karpenter-workshop-setup.sh
</strong></code></pre>

{% hint style="info" %}
Change it to be executable
{% endhint %}

```
#execute this on CloudShell
chmod 744 karpenter-workshop-setup.sh
```

Run the script

<pre><code>#execute this on CloudShell
<strong>./karpenter-workshop-setup.sh
</strong></code></pre>

Below you can check what it is doing.

```bash

#!/bin/bash

# Access AWS Console
# Note: Manual step required to log in to AWS Console

# Open CloudShell
# Note: Manual step to open AWS CloudShell in AWS Console

# Install eksdemo on AWS CloudShell
echo "Installing eksctl and eksdemo on AWS CloudShell"
curl -s -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
curl -s -L "https://github.com/awslabs/eksdemo/releases/latest/download/eksdemo_Linux_x86_64.tar.gz" | tar xz -C /tmp
mkdir -p ~/.local/bin && mv /tmp/eksctl ~/.local/bin && mv /tmp/eksdemo ~/.local/bin

# Install bash-completion for bash completion functionality
echo "Installing bash-completion"
sudo dnf install bash-completion -y

# Configure bash completion to persist across CloudShell sessions
echo "Configuring bash completion"
mkdir -p ~/.bashrc.d
cp /usr/share/bash-completion/bash_completion ~/.bashrc.d/
echo '. <(eksdemo completion bash)' >> ~/.bashrc
echo 'export AWS_REGION=ap-southeast-2' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
source ~/.bashrc
complete -o default -F __start_kubectl k


# Validate Installation
echo "Validating eksdemo installation"
eksdemo version

# Create EKS Cluster
echo "Creating EKS cluster named 'blue' with Bottlerocket OS"
eksdemo create cluster blue --os bottlerocket -i t3.medium -N 1

# Install Karpenter
echo "Installing Karpenter on cluster 'blue'"
eksdemo install karpenter -c blue

# Install Prometheus and Karpenter Dashboards
echo "Installing Prometheus and Karpenter dashboards on cluster 'blue'"
eksdemo install kube-prometheus-stack -c blue -P karpenter
eksdemo install kube-prometheus-karpenter-dashboards -c blue

# Create ServiceMonitor for Karpenter
cat <<EOF > servicemonitorpromethes-karpenter.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: karpenter
  namespace: monitoring  # Make sure this matches where your Prometheus Operator is deployed
spec:
  selector:
    matchLabels:
      app.kubernetes.io/instance: karpenter
      app.kubernetes.io/name: karpenter
  endpoints:
    - port: http-metrics
      interval: 3s
  namespaceSelector:
    matchNames:
      - karpenter  # Namespace where Karpenter is deployed
EOF

kubectl apply -f servicemonitorpromethes-karpenter.yaml

# Install Inflate App
eksdemo install example-inflate -c blue -n inflate --replicas 0

# Get Grafana address
GRAFANA_ADDRESS=$(kubectl get service grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Getting Grafana service HTTP address"
echo "Grafana available at: http://$GRAFANA_ADDRESS" 
echo "Username: admin"
echo "Password: karpenter"
echo "Grafana available at: http://$GRAFANA_ADDRESS" >> grafana-credentials.txt
echo "Username: admin"  >> grafana-credentials.txt
echo "Password: karpenter" >> grafana-credentials.txt
echo "Credentials saved in grafana-credentials.txt"

# Completion message
echo "Setup completed successfully. Lets get started with Karpenter!"
```

