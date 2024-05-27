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
## [Improved Monorepo Performance](./monorepo-performance/)
## [Apps In Any Namespace Feature Promoted To Stable](./apps-in-any-ns-stable/)
## [See Who Initiated A Sync In The History UI](./who-init-a-sync/)
## [Cluster Sharding By Number Of Applications](./sharding-by-apps/)