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
echo 'alai'
complete -o default -F __start_kubectl k
source ~/.bashrc
```

\
Validate Install

To validate installation you can run the **`eksdemo version`** command and confirm you are running the latest version. The output will be similar to below:

```
» eksdemo version
eksdemo: version.Info{Version:"0.16.0", Date:"2024-08-19T17:41:55Z", Commit:"74fc767"}
```

## Create the cluster

It takes about 15minutes

```
eksdemo create cluster blue --os bottlerocket -i t3.xlarge -N 1
```

Validate

```
eksdemo get cluster
```

## Install Karpenter

```
eksdemo install karpenter -c blue
```



## Create a "k8sug-workshop" user











```
# Create IAM user
aws iam create-user --user-name k8sug-workshop

# Attach AdministratorAccess policy to the user
aws iam attach-user-policy --user-name k8sug-workshop --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Create a login profile for the user with a specific password
aws iam create-login-profile --user-name k8sug-workshop --password "K8SUG-handson" --no-password-reset-required

# Output the username and password
echo "User 'k8sug-workshop' created with the following credentials:"
echo "Username: k8sug-workshop"
echo "Password: K8SUG-handson"
```

```
https://<your-account-id>.signin.aws.amazon.com/console

```

Install EKSCTL

```
wget https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz -O eksctl.tar.gz
```



```
tar -xzf eksctl.tar.gz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```



