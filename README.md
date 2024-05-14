# What's New in Argo CD v2.11?

Try out the demos for yourself by opening up this repo in a Codespace, which will create a Kubernetes cluster with k3d and deploy Argo CD v2.11. You can then open the UI in a new window with port-forwarding from the Codespace, and use the pre-configured `argocd` CLI!

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/morey-tech/argocd-v2.11-examples)

Get the `admin` password for the UI from:
```
cat ~/argo-cd-admin-password.txt
```

## Prune Resources In Reverse Order of Sync Waves
Argo CD executes a sync operation in a number of steps. At a high-level, there are three phases pre-sync, sync and post-sync.

Within each phase you can have one or more waves, that allows you to ensure certain resources are healthy before subsequent resources are synced.

Sync waves are often used to ensure that certain resources are created in the correct order. For example:
- Custom Resource Definition (CRD) before the Custom Resource (CR) that references it.
- Namespace synced before all other objects.
    - Argo CD will [apply Namespaces before all other resources](https://github.com/argoproj/gitops-engine/blob/8a3ce6d85caa4220cfcaa8aa8b6d6dff476909ec/pkg/sync/sync_tasks.go#L28) in the same wave by default. However if you are using negative sync waves (i.e. waves to apply resources before all other resources on the default wave `0`), then the namespace must be configured to be created in the lowest wave.
    - The [CreateNamespace](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/#create-namespace) sync option will ensure the namespace exists before starting the phases. However [Argo CD doesn't delete Namespaces created by this option](https://github.com/argoproj/argo-cd/issues/7875) when the Application is deleted. Which is why you might [include the Namespace in the manifests](https://github.com/argoproj/argo-cd/issues/7875#issuecomment-1551192762).

## Auto-Label Clusters With K8s Version

## CLI Support For Applications with Multiple Sources
