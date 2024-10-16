# Default NodePool

### NodePools

* **Definition**: A NodePool in Karpenter sets constraints on the nodes that can be created and the pods that can run on those nodes. You can configure multiple NodePools to cater to different workloads or requirements within your Kubernetes cluster[1](https://karpenter.sh/docs/concepts/nodepools/)[4](https://karpenter.sh/v0.37/concepts/nodepools/).
* **Configuration**: Each NodePool can have its own set of specifications, including instance types, zones, and taints. When you create additional NodePools, Karpenter will evaluate each one based on the pod's requirements and the constraints defined in the NodePools[1](https://karpenter.sh/docs/concepts/nodepools/)[3](https://www.eksworkshop.com/docs/autoscaling/compute/karpenter/setup-provisioner).
* **Mutual Exclusivity**: It is recommended to design NodePools to be mutually exclusive, meaning that no pod should match multiple NodePools. If a pod matches multiple pools, Karpenter will use the one with the highest weight

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
  
````

