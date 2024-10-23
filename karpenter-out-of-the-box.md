# 📦 Karpenter Out of The Box

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

{% hint style="info" %}
Set replicas up to 64 and monitor in Grafana after each step.

Optionally, you also may check&#x20;

`kubectl get nodeclaim`&#x20;
{% endhint %}

```bash
kubectl scale deploy inflate -n inflate --replicas 2
```

```bash
kubectl scale deploy inflate -n inflate --replicas 4
```

```bash
kubectl scale deploy inflate -n inflate --replicas 8
```

```bash
kubectl scale deploy inflate -n inflate --replicas 16
```

```bash
kubectl scale deploy inflate -n inflate --replicas 32
```

```bash
kubectl scale deploy inflate -n inflate --replicas 64
```

### Scale Down

Conversely, when the deployment is scaled down, Karpenter consolidates the workloads onto fewer nodes and terminates unnecessary nodes, optimising resource utilisation and reducing costs.&#x20;

```bash
kubectl scale deploy inflate -n inflate --replicas 2
```

```bash
kubectl scale deploy inflate -n inflate --replicas 0
```

This behaviour ensures that the cluster remains responsive and cost-effective without manual intervention.

