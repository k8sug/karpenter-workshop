---
icon: monitor-waveform
---

# Setting Up Grafana for Monitoring

In this section, we’ll guide you through the steps to access the Grafana dashboard, which has been installed in your Kubernetes cluster, and upload a custom dashboard to visualise metrics collected by Prometheus.



**Step 1: Access Grafana Dashboard**

1.  Retrieve the Grafana URL and Credentials

    Run the following command in CloudShell to retrieve the Grafana load balancer URL and credentials for login:

{% code overflow="wrap" %}
```bash
cat grafana-credentials.txt
```
{% endcode %}

2. Open Grafana in Your Browser\
   Copy and paste the load balancer URL into your web browser.

{% hint style="warning" %}
Ensure that the URL is using http and not https.&#x20;

You may receive a browser warning because the site is not using https. Simply click “Continue to site” as this is a demo environment, and the connection is safe for the workshop.
{% endhint %}

3. Log in to Grafana\
   On the Grafana login portal, enter the following credentials:
   * Username: `admin`
   * Password: `karpenter`

<figure><img src=".gitbook/assets/1 Login.png" alt=""><figcaption></figcaption></figure>

**Step 2: Upload Custom Grafana Dashboard**

1. Download the Custom Dashboard JSON File\
   On your local terminal (not CloudShell), download the pre-configured Grafana dashboard JSON file using the command:

```bash
curl -s -L https://raw.githubusercontent.com/k8sug/karpenter-workshop/refs/heads/main/resources/grafana/k8sug-karpenter-grafana-dashboard.json > k8sug-karpenter-grafana-dashboard.json
```

2. Navigate to Dashboards in Grafana\
   Once logged into Grafana, click the toggle menu button (three horizontal bars on the left) and select Dashboards.

<div data-full-width="true">

<figure><img src=".gitbook/assets/2 Dashboard Menu.png" alt=""><figcaption></figcaption></figure>

</div>

3. Start the Dashboard Import\
   In the Dashboards section, click the New button in the top right, and select Import from the dropdown.

<div data-full-width="true">

<figure><img src=".gitbook/assets/3 Import.png" alt=""><figcaption></figcaption></figure>

</div>

4. Upload the Custom Dashboard JSON File\
   On the Import Dashboard page, click the “Upload JSON file” button. Afterwards, select the JSON file (k8sug-karpenter-grafana-dashboard.json) that you downloaded earlier.

<div data-full-width="true">

<figure><img src=".gitbook/assets/4 Upload JSON.png" alt=""><figcaption></figcaption></figure>

</div>

5. Import the Dashboard\
   Once you’ve selected the file, click Import to load the custom dashboard.

<div data-full-width="true">

<figure><img src=".gitbook/assets/5 Import JSON.png" alt=""><figcaption></figcaption></figure>

</div>

**Step 3: Visualise Your Metrics**\
After completing the steps above, the custom Grafana dashboard will be displayed, showing real-time metrics collected by Prometheus. You can now explore the various panels and visualisations that provide insights into your EKS cluster and Karpenter’s activity.

{% hint style="info" %}
The appearance of the dashboard may vary depending on the current state of your cluster, such as the number of running nodes or active workloads.
{% endhint %}

By adjusting the timeline and refresh rate, you’ll be able to monitor real-time updates on your cluster’s performance, with the dashboard automatically refreshing every 5 seconds for the last 15 minutes.

<div data-full-width="true">

<figure><img src=".gitbook/assets/7 Adjust (1).png" alt=""><figcaption></figcaption></figure>

</div>
