# What's New in Argo CD v2.11?
## CLI Support For Applications with Multiple Sources
> Introduced by Mangaal Angom Meetei and Ishita Sequeira (Red Hat)

The initial support for multiple sources for `Applications` [added in Argo CD v2.6](https://youtu.be/2VF2x72dZsQ). But there were several places in the CLI and the UI where support hadn't been added for multiple sources.

Check out a [full demo](https://www.youtube.com/watch?v=MlAWr8bVr0I&t=733s) of using multiple sources to manage remote Helm values files. 

In Argo CD v2.11, support was added for multiple-source `Applications` in several area of the `argocd` CLI:
```
argocd app add-source
argocd app remove-source
argocd app create
argocd app edit
argocd app set
argocd app unset
argocd app diff
argocd app manifests
argocd app history
```

```
# Prior to v2.11
$ argocd app history argocd/multi-source-app
ID  DATE                           REVISION
0   2024-05-17 18:56:22 +0000 UTC 

# v2.11
$ argocd app history argocd/multi-source-app
SOURCE  https://helm.github.io/examples
ID      DATE                           REVISION
0       2024-05-17 18:56:22 +0000 UTC  0.1.0

SOURCE  https://github.com/morey-tech/argo-cd-helm-values-demo
ID      DATE                           REVISION
0       2024-05-17 18:56:22 +0000 UTC  HEAD (fad7d80)
```

```
# Set and override application parameters for a source at position 1 under spec.sources of app my-app. source-position starts at 1.
argocd app set my-app --source-position 1 --repo https://github.com/argoproj/argocd-example-apps.git
```