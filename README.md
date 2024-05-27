# What's New in Argo CD v2.11?

Try out the demos for yourself by opening up this repo in a Codespace, which will create a Kubernetes cluster with k3d and deploy Argo CD v2.11. You can then open the UI in a new window with port-forwarding from the Codespace, and use the pre-configured `argocd` CLI!

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/morey-tech/argocd-v2.11-examples)

Get the `admin` password for the UI from:
```
cat ~/argo-cd-admin-password.txt
```

## [Prune Resources In Reverse Order of Sync Waves](./sync-waves/)
## [Auto-Label Clusters With K8s Version](./auto-label-clusters/)
## [CLI Support For Applications with Multiple Sources](./multi-source-cli/)
## Improved Monorepo Performance
> Introduced by Alexy Mantha (GoTo) in https://github.com/argoproj/argo-cd/pull/15636 

In the context of Argo CD, the monorepo pattern refers to a Git repository that many (if not all) Applications refer to. When there is a new target revision of the monorepo, it triggers the cache for all of Applications to be invalidated. The repo-server will then regenerate the manifests from the source for each Application. Despite the fact that in the new revision there may have been no changes to the specific path that an Application references.

To get around this behaviour, user's can add the `argocd.argoproj.io/manifest-generate-paths` annotation which contains a list of paths within the Git repository that are used during manifest generation. However, prior to v2.11, the annotation was only used when a Git webhook was configured in Argo CD for the repository because the event contained the files changed.

Now in Argo CD v2.11 the `manifest-generate-paths` annotation is supported in normal sync operations, which improves both the speed and the user experience mono-repos with Argo CD installations for users without Git webhooks. They will experience fewer sync operations for Applications that are not affected by any of the files found in the latest commit. And the Argo CD history UI will only list the commits that actually affected the Application.

## Apps In Any Namespace Feature Promoted To Stable
Since Argo CD 2.5,Application resources can be managed in namespaces other than the control plane's namespace (which is usually `argocd`). Administrators can define a certain set of namespaces where Applications may be created, updated and reconciled in.

This allows ordinary Argo CD users (e.g. application teams) to own the declarative management of their Application resources, implement the app-of-apps pattern, and more without the risk of a privilege escalation through usage of other AppProjects that would exceed the permissions granted to the application teams. This way users can configure notifications for their Argo CD applications in the namespaces they own.

## See Who Initiated A Sync In The History UI
For teams that have Argo CD Applications with auto-sync disabled (a common pattern for production environments), they want to know which person started a deployment. This new feature in 2.11 adds a new field (`status.history.[].initiatedBy`) to the Application CRD to track who initiated a sync.

## Cluster Sharding By Number Of Applications
> Introduced by Andrew Lee (AWS) in https://github.com/argoproj/argo-cd/pull/17014

When a single Argo CD instance is managing multiple clusters, there is the capability to shard the `application-controllers` to be responsible for specific clusters (rather than a single controller managing all of them). The primary sharding algorithm, used to determine which shard is responsible for which clusters, distributed clusters based on hashing the IDs.

The challenge with this algorithm is that it's not always uniform, resulting in some shards managing many clusters while others manage very few. Additional, if the clusters aren't uniform (e.g. some clusters are large managing many Applications, but others manage a handful of Applications) this isn't taken into consideration. This results in some shards being under heavy load while others sit idle.

In Argo CD 2.11, the sharding cache has been updated to include data on the number of Applications manage by clusters (which is one of the main indicators of load). This will allow future sharding algorithms to distribute clusters between shards based on the number of Applications they manage.