# Default EC2NodeClass

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
  status:
    amis:
    - id: ami-01637a5ffbb75ef5c
      name: amazon-eks-node-1.30-v20240928
      requirements:
      - key: kubernetes.io/arch
        operator: In
        values:
        - amd64
    - id: ami-0f9b86b5fcf375aca
      name: amazon-eks-arm64-node-1.30-v20240928
      requirements:
      - key: kubernetes.io/arch
        operator: In
        values:
        - arm64
    conditions:
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: AMIsReady
      status: "True"
      type: AMIsReady
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: InstanceProfileReady
      status: "True"
      type: InstanceProfileReady
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: Ready
      status: "True"
      type: Ready
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: SecurityGroupsReady
      status: "True"
      type: SecurityGroupsReady
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: SubnetsReady
      status: "True"
      type: SubnetsReady
    instanceProfile: blue_8146430464388342579
    securityGroups:
    - id: sg-0427f7dc2d9669ad9
      name: eks-cluster-sg-blue-3027034
    subnets:
    - id: subnet-00c521f6825b335ce
      zone: ap-southeast-2c
      zoneID: apse2-az2
    - id: subnet-0ca1366f6deba157c
      zone: ap-southeast-2b
      zoneID: apse2-az1
    - id: subnet-086598f901c48a72f
      zone: ap-southeast-2a
      zoneID: apse2-az3
kind: List
metadata:
  resourceVersion: ""
```

