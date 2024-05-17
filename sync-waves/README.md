# What's New in Argo CD v2.11?
## Prune Resources In Reverse Order of Sync Waves
Argo CD executes a sync operation in three phases: pre-sync, sync and post-sync. Within each phase you can have one or more waves.

Sync waves are configured using the `argocd.argoproj.io/sync-wave` annotation on resources. By default, all resources are on sync wave 0. Therefore a sync wave of `-1` will get synced before all other resources that doesn't specify the annotation. 
```yaml
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
```

Sync waves are often used to ensure ensure certain resources are healthy before subsequent resources are synced, creating them in the correct order.

For example:
- Custom Resource Definition (CRD) before the Custom Resource (CR) that references it.
- Namespace synced before all other objects.
    - Argo CD will [apply Namespaces before all other resources](https://github.com/argoproj/gitops-engine/blob/8a3ce6d85caa4220cfcaa8aa8b6d6dff476909ec/pkg/sync/sync_tasks.go#L28) in the same wave by default. However if you are using negative sync waves (i.e. waves to apply resources before all other resources on the default wave `0`), then the namespace must be configured to be created in the lowest wave.
    - The [CreateNamespace](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/#create-namespace) sync option will ensure the namespace exists before starting the phases. However [Argo CD doesn't delete Namespaces created by this option](https://github.com/argoproj/argo-cd/issues/7875) when the Application is deleted. Which is why you might [include the Namespace in the manifests](https://github.com/argoproj/argo-cd/issues/7875#issuecomment-1551192762).
- To ensure that an operator is synced and healthy before the resources it consumes.

Prior to Argo CD v2.11, sync waves were not respected. Instead, Argo CD tries to [delete everything at once](https://github.com/argoproj/argo-cd/issues/12376#issuecomment-1512938833). When an Application is deleted the order of the sync waves was ignored, which causes issues with the same resources that need to be created is a specific order.

If the operator is deleted before it can delete the resources it manages which typically have blocking finalizers (example below), the Application would be stuck deleting.

```yaml
apiVersion: v1
kind: PostgresUser
metadata:
  name: my-user
  annotations:
    argocd.argoproj.io/sync-wave: "10"
  finalizers:
  - example.com/operator-finalizer
```

The expected behaviour by most users and following the law of least surprise the correct behaviour, would be for the sync-waves to be respected in reverse order. Resources that are created first, should be deleted last.

You can test this out for yourself by deleting the `sync-waves` `Application` is Argo CD and watching as the `Deployments` and `Services` get deleted before the `Namespace` (sync wave `-1`).