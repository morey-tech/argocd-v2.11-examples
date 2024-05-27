# What's New in Argo CD v2.11?
## Improved Monorepo Performance
> Introduced by Alexy Mantha (GoTo) in https://github.com/argoproj/argo-cd/pull/15636 

In the context of Argo CD, the monorepo pattern refers to a Git repository that many (if not all) Applications refer to. When there is a new target revision of the monorepo, it triggers the cache for all of Applications to be invalidated. The repo-server will then regenerate the manifests from the source for each Application. Despite the fact that in the new revision there may have been no changes to the specific path that an Application references.

To get around this behaviour, user's can add the `argocd.argoproj.io/manifest-generate-paths` annotation which contains a list of paths within the Git repository that are used during manifest generation. However, prior to v2.11, the annotation was only used when a Git webhook was configured in Argo CD for the repository because the event contained the files changed.

Now in Argo CD v2.11 the `manifest-generate-paths` annotation is supported in normal sync operations, which improves both the speed and the user experience mono-repos with Argo CD installations for users without Git webhooks. They will experience fewer sync operations for Applications that are not affected by any of the files found in the latest commit. And the Argo CD history UI will only list the commits that actually affected the Application.