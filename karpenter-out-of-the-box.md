# Karpenter Out of The Box

Karpenter, by default, is designed to efficiently manage Kubernetes cluster resources by dynamically scaling nodes according to workloads.&#x20;

### Open your Grafana Dashboard

{% hint style="info" %}
You can check grafana credentials running

```shellscript
cat grafana-credentials.txt
```
{% endhint %}

### Scale Up&#x20;

When a deployment such as "inflate" is scaled up, Karpenter automatically provisions new nodes to accommodate the increased resource demand.&#x20;

{% code title="Set replicas to 20" %}
```bash
kubectl scale deploy inflate -n inflate --replicas 20
```
{% endcode %}

### Scale Down

Conversely, when the deployment is scaled down, Karpenter consolidates the workloads onto fewer nodes and terminates unnecessary nodes, optimising resource utilisation and reducing costs.&#x20;

{% code title="Set replicas to 10" %}
```bash
kubectl scale deploy inflate -n inflate --replicas 2
```
{% endcode %}

This behaviour ensures that the cluster remains responsive and cost-effective without manual intervention.

