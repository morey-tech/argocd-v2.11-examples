# What's New in Argo CD v2.11?
## See Who Initiated A Sync In The History UI
For teams that have Argo CD Applications with auto-sync disabled (a common pattern for production environments), they want to know which person started a deployment. This new feature in 2.11 adds a new field (`status.history.[].initiatedBy`) to the Application CRD to track who initiated a sync.