# What's New in Argo CD v2.11?
## Auto-Label Clusters With K8s Version
The `in-cluster` Argo CD cluster connection is created automatically when Argo CD is deployed. However the declarative configuration (the Kubernetes `Secret` in the `argocd` namespace) for the `in-cluster` is not. 

Run the following command to create it with the label to tell Argo CD to add cluster info:
```bash
argocd cluster add k3d-dev --in-cluster --name "in-cluster" -y --label argocd.argoproj.io/auto-label-cluster-info="true"
```

This will generate a `Secret` in the `argocd` namespace named `cluster-kubernetes.default.svc-XXXXXXXXXX` that looks like this:
```yaml
kind: Secret
metadata:
  labels:
    # Indicate secret for cluster.
    argocd.argoproj.io/secret-type: cluster
    # Enable auto labeling with cluster info.
    argocd.argoproj.io/auto-label-cluster-info: "true"
    # Label added by Argo CD.
    argocd.argoproj.io/kubernetes-version: "1.29"
  name: cluster-kubernetes.default.svc-3396314289
  namespace: argocd
type: Opaque
```

If the `argocd.argoproj.io/kubernetes-version` label is not present yet, wait a moment for the controller to react to the `argocd.argoproj.io/auto-label-cluster-info` label.

The `whalesay-k8s-version` `ApplicationSet` in this demo takes advantage of the `kubernetes-version` label added by Argo CD. It uses the `cluster` generator to generate an `Application` per cluster that contains `kubernetes-version` label.

```yaml
generators:
- clusters:
    selector:
      matchExpressions:
      # Only deploy to clusters with the required label.
      - {key: 'argocd.argoproj.io/kubernetes-version', operator: Exists}
```

And passes the value of that label to the Helm chart.
```yaml
source:
# ...
  helm:
    valuesObject:
      whalesay: 'Kubernetes version {{index .metadata.labels "argocd.argoproj.io/kubernetes-version"}}'
```

So that the pod will print it in the logs.
```
 _________________________
< Kubernetes version 1.29 >
 -------------------------
    \
     \
      \
                    ##        .
              ## ## ##       ==
           ## ## ## ##      ===
       /""""""""""""""""___/ ===
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
       \______ o          __/
        \    \        __/
          \____\______/
```
