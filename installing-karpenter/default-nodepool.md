# Default NodePool

````yaml
```yaml
apiVersion: v1
items:
- apiVersion: karpenter.sh/v1
  kind: NodePool
  metadata:
    annotations:
      karpenter.sh/nodepool-hash: "6821555240594823858"
      karpenter.sh/nodepool-hash-version: v3
    creationTimestamp: "2024-10-12T00:39:10Z"
    generation: 1
    name: default
    resourceVersion: "4370"
    uid: 6fb3793b-e7e4-4b30-9da4-709b5526c3e5
  spec:
    disruption:
      budgets:
      - nodes: 10%
      consolidateAfter: 1m
      consolidationPolicy: WhenEmptyOrUnderutilized
    limits:
      cpu: 1000
    template:
      spec:
        expireAfter: 720h
        nodeClassRef:
          group: karpenter.k8s.aws
          kind: EC2NodeClass
          name: default
        requirements:
        - key: kubernetes.io/arch
          operator: In
          values:
          - amd64
        - key: kubernetes.io/os
          operator: In
          values:
          - linux
        - key: karpenter.sh/capacity-type
          operator: In
          values:
          - on-demand
          - spot
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values:
          - c
          - m
          - r
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values:
          - "2"
  status:
    conditions:
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: NodeClassReady
      status: "True"
      type: NodeClassReady
    - lastTransitionTime: "2024-10-12T00:39:12Z"
      message: ""
      reason: Ready
      status: "True"
      type: Ready
    - lastTransitionTime: "2024-10-12T00:39:10Z"
      message: ""
      reason: ValidationSucceeded
      status: "True"
      type: ValidationSucceeded
    resources:
      cpu: "0"
      ephemeral-storage: "0"
      memory: "0"
      nodes: "0"
      pods: "0"
kind: List
metadata:
  resourceVersion: ""

```
````

