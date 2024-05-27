# What's New in Argo CD v2.11?
## Apps In Any Namespace Feature Promoted To Stable
Since Argo CD 2.5,Application resources can be managed in namespaces other than the control plane's namespace (which is usually `argocd`). Administrators can define a certain set of namespaces where Applications may be created, updated and reconciled in.

This allows ordinary Argo CD users (e.g. application teams) to own the declarative management of their Application resources, implement the app-of-apps pattern, and more without the risk of a privilege escalation through usage of other AppProjects that would exceed the permissions granted to the application teams. This way users can configure notifications for their Argo CD applications in the namespaces they own.