---
description: Split Between On-Demand & Spot Instances
---

# 💸 Cut Costs with Spot Instances

### Purpose

This setup works if you're interested in having a portion the EKS nodes running using On-Demand instances, and another portion on Spot. For example, a split of 20% On-Demand, and 80% on Spot. You can take advantage of the labels that Karpenter adds automatically to each node, and use [Topology Spread Constraints (TSC)](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) within a `Deployment` or `Pod` to split capacity in a desired ratio.

To do this, you can create a NodePool each for Spot and On-Demand with disjoint values for a unique new label called [`capacity-spread`](https://karpenter.sh/docs/concepts/scheduling/#on-demandspot-ratio-split). Then, assign values to this label to configure the split. If you'd like to have a 20/80 split, you could add the values`["1"]` for the On-Demand NodePool, and`["2","3","4","5"]` for the Spot NodePool.



| NodePools                                                                  | Deployment                                                                |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| <img src="../.gitbook/assets/2 NodePools.png" alt="" data-size="original"> | <img src="../.gitbook/assets/3 Workload.png" alt="" data-size="original"> |

### Why Spot Instances?

Spot instances can offer cost savings of up to 90% compared to on-demand instances.​ Spot instances are ideal for workloads that are flexible and can tolerate interruptions since AWS reclaims these instances when demand for on-demand instances increases.

<figure><img src="../.gitbook/assets/1 Save percentage (1).png" alt=""><figcaption><p>Savings on m5.large Spot instances over On-Demand in the Melbourne region</p></figcaption></figure>

{% hint style="info" %}
Check real-time savings at [https://aws.amazon.com/ec2/spot/instance-advisor/](https://aws.amazon.com/ec2/spot/instance-advisor/)
{% endhint %}

### Steps

Create a directory for this scenario.

```bash
mkdir cutcost && cd cutcost
```

Download the YAML manifests containing a sample deployment and two NodePools (one for On Demand and one for Spot instances).

{% code overflow="wrap" %}
```bash
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/od-spot-split/workload.yaml > workload.yaml
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/od-spot-split/od-spot.yaml > nodepool.yaml
```
{% endcode %}

Create the resources in this folder.

{% code overflow="wrap" %}
```bash
kubectl apply -f .
```
{% endcode %}

### Results

You can review the Karpenter logs and watch how it's deciding to launch multiple nodes following the workload constraints:

{% code overflow="wrap" %}
```bash
kubectl -n karpenter logs -l app.kubernetes.io/name=karpenter --all-containers=true -f --tail=20
```
{% endcode %}

Wait for one minute and you should see the pods running within multiple nodes, run this command:

{% code overflow="wrap" %}
```bash
kubectl get nodes -L karpenter.sh/capacity-type,beta.kubernetes.io/instance-type,karpenter.sh/nodepool,topology.kubernetes.io/zone -l karpenter.sh/initialized=true
```
{% endcode %}

{% hint style="info" %}
You can also view the number of spot and on-demand instances on Grafana for better visualisation.
{% endhint %}

### Scaling Replicas

To play around with the number of replicas, run the following command. You can adjust the number of replicas as desired, and watch the changes on Grafana:

{% hint style="info" %}
Replace with the desired number of replicas to see how the changes impact the cluster’s performance and resource utilisation.
{% endhint %}

```bash
kubectl scale deployments workload-split --replicas=<number>
```

### Cleanup

Before moving to the next scenario, remove all resources by running the following command:

<pre class="language-bash"><code class="lang-bash"><strong>#from cutcost directory
</strong><strong>kubectl delete -f .
</strong></code></pre>
