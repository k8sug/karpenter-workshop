---
icon: file-code
---

# EC2NodeClass



When you first installed Karpenter during this workshop, you set up a default EC2NodeClass. The NodePool enables configuration of AWS specific settings.

{% hint style="info" %}
See full documenation on

[https://karpenter.sh/v1.0/concepts/nodeclasses/](https://karpenter.sh/v1.0/concepts/nodeclasses/)

Example of EC2NodeClass and NodePool pair settings

[https://github.com/aws/karpenter-provider-aws/tree/v1.0.3/examples/v1](https://github.com/aws/karpenter-provider-aws/tree/v1.0.3/examples/v1)
{% endhint %}

{% code title="default EC2NodeClass " %}
```yaml
apiVersion: v1
items:
- apiVersion: karpenter.k8s.aws/v1
  kind: EC2NodeClass
  metadata:
    annotations:
      karpenter.k8s.aws/ec2nodeclass-hash: "3511393923618188278"
      karpenter.k8s.aws/ec2nodeclass-hash-version: v3
    creationTimestamp: "2024-10-12T00:39:10Z"
    finalizers:
    - karpenter.k8s.aws/termination
    generation: 1
    name: default
    resourceVersion: "4369"
    uid: fe07bcbf-da2e-44ce-a322-6e5e27c8d080
  spec:
    amiFamily: AL2
    amiSelectorTerms:
    - id: ami-01637a5ffbb75ef5c
    - id: ami-0f9b86b5fcf375aca
    metadataOptions:
      httpEndpoint: enabled
      httpProtocolIPv6: disabled
      httpPutResponseHopLimit: 1
      httpTokens: required
    role: KarpenterNodeRole-blue
    securityGroupSelectorTerms:
    - tags:
        aws:eks:cluster-name: blue
    subnetSelectorTerms:
    - tags:
        Name: eksctl-blue-cluster/SubnetPrivate*
    tags:
      eksdemo.io/version: 0.16.0
```
{% endcode %}

