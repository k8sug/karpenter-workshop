# EKS Setup

## Access AWS Console

Set region to ap-southeast-2 Sydday

Open CloudShell

#### Install EKSdemo on AWS CloudShell

AWS CloudShell environments are mostly ephemeral and software you install is lost the next time you reconnect. There is [persistent storage available](https://docs.aws.amazon.com/cloudshell/latest/userguide/limits.html#persistent-storage-limitations) in the home directory that is retained for 120 days after the end of your last session. Use the following commands to install `eksdemo` on AWS CloudShell:

```
curl -s -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
curl -s -L "https://github.com/awslabs/eksdemo/releases/latest/download/eksdemo_Linux_x86_64.tar.gz" | tar xz -C /tmp
mkdir -p ~/.local/bin && mv /tmp/eksctl ~/.local/bin && mv /tmp/eksdemo ~/.local/bin
```

To configure Bash completion, first install the bash-completion package:

```
sudo dnf install bash-completion -y
```

Once that completes, run the following commands that will configure bash completion to work across CloudShell sessions by installing everything needed in the home directory:

```
mkdir -p ~/.bashrc.d
cp /usr/share/bash-completion/bash_completion ~/.bashrc.d/
echo '. <(eksdemo completion bash)' >> ~/.bashrc
echo 'export AWS_REGION=us-west-2'  >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
complete -o default -F __start_kubectl k
source ~/.bashrc
```

\
Validate Install

To validate installation, you can run the **`eksdemo version`** command and confirm you are running the latest version. The output will be similar to below:

```
» eksdemo version
eksdemo: version.Info{Version:"0.16.0", Date:"2024-08-19T17:41:55Z", Commit:"74fc767"}
```

## Create the cluster

It takes about 15minutes

```
eksdemo create cluster blue --os bottlerocket -i t3.medium -N 1
```

## Install Karpenter

```
eksdemo install karpenter -c blue
```

## install Prometheus And Karpenter Dashboards

```
eksdemo install kube-prometheus-stack -c blue -P karpenter
eksdemo install kube-prometheus-karpenter-dashboards -c blue
```








