---
description: Split Between On-Demand & Spot Instances
---

# Cut Costs with Spot Instances

### Purpose

This setup works if you're interested in having a portion the EKS nodes running using On-Demand instances, and another portion on Spot. For example, a split of 20% On-Demand, and 80% on Spot. You're can take advantage of the labels Karpenter adds automatically to each node, and use [Topology Spread Constraints (TSC)](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) within a `Deployment` or `Pod` to split capacity in a desired ratio.

To do this, you can create a NodePool each for Spot and On-Demand with disjoint values for a unique new label called `capacity-spread`. Then, assign values to this label to configure the split. If you'd like to have a 20/80 split, you could add the values `["2","3","4","5"]` for the Spot NodePool, and `["1"]` for the On-Demand NodePool.



### Requirements

* A Kubernetes cluster with Karpenter installed. You can use the blueprint we've used to test this pattern at the `cluster` folder in the root of this repository.
* A `default` Karpenter NodePool as that's the one we'll use in this blueprint. You did this already in the ["Deploy a Karpenter Default EC2NodeClass and NodePool"](https://github.com/aws-samples/karpenter-blueprints/blob/main/README.md) section from this repository.



{% code overflow="wrap" %}
```
#Create a directory for this scenario
mkdir cut-cost
cd cutcost
#Download the YAML manifests
curl -s -L "https://raw.githubusercontent.com/aws-samples/karpenter-blueprints/refs/heads/main/blueprints/od-spot-split/workload.yaml" > workload.yaml
curl -s -L  "https://raw.githubusercontent.com/aws-samples/karpenter-blueprints/refs/heads/main/blueprints/od-spot-split/od-spot.yaml" > od-spot.yaml
#Create the objects
kubectl apply -f .
```
{% endcode %}



### Results



You can review the Karpenter logs and watch how it's deciding to launch multiple nodes following the workload constraints:

```
kubectl -n karpenter logs -l app.kubernetes.io/name=karpenter --all-containers=true -f --tail=20
```

Wait one minute and you should see the pods running within multiple nodes, run this command:

```
kubectl get nodes -L karpenter.sh/capacity-type,beta.kubernetes.io/instance-type,karpenter.sh/nodepool,topology.kubernetes.io/zone -l karpenter.sh/initialized=true
```

\




