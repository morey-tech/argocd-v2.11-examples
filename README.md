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
In the context of Argo CD, the monorepo pattern refers to a Git repository that many (if not all) Applications refer to. When there is a new target revision of the monorepo, it triggers the cache for all of Applications to be invalidated. The repo-server will then regenerate the manifests from the source for each Application. Despite the fact that in the new revision there may have been no changes to the specific path that an Application references.

To get around this behaviour, user's can add the `argocd.argoproj.io/manifest-generate-paths` annotation which contains a list of paths within the Git repository that are used during manifest generation. However, prior to v2.11, the annotation was only used when a Git webhook was configured in Argo CD for the repository because the event contained the files changed.

