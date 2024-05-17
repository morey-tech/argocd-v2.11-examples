# What's New in Argo CD v2.11?
## CLI Support For Applications with Multiple Sources
The initial support for multiple sources for `Applications` [added in Argo CD v2.6](https://youtu.be/2VF2x72dZsQ), check out the [full demo](https://www.youtube.com/watch?v=MlAWr8bVr0I&t=733s) of when you'd use this. But there were several places in the CLI and the UI where support hadn't been added for multiple sources.

In Argo CD v2.11, support was added for multiple-source `Applications` in several area of the `argocd` CLI:
```
argocd app add-source
argocd app remove-source
argocd app create
argocd app edit
argocd app set
argocd app unset
argocd app diff
```

And the Manifests and History tabs of the UI.