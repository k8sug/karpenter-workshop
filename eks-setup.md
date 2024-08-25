# EKS Setup

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



