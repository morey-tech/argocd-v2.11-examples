# What's New in Argo CD v2.11?
## Cluster Sharding By Number Of Applications
> Introduced by Andrew Lee (AWS) in https://github.com/argoproj/argo-cd/pull/17014

When a single Argo CD instance is managing multiple clusters, there is the capability to shard the `application-controllers` to be responsible for specific clusters (rather than a single controller managing all of them). The primary sharding algorithm, used to determine which shard is responsible for which clusters, distributed clusters based on hashing the IDs.

The challenge with this algorithm is that it's not always uniform, resulting in some shards managing many clusters while others manage very few. Additional, if the clusters aren't uniform (e.g. some clusters are large managing many Applications, but others manage a handful of Applications) this isn't taken into consideration. This results in some shards being under heavy load while others sit idle.

In Argo CD 2.11, the sharding cache has been updated to include data on the number of Applications manage by clusters (which is one of the main indicators of load). This will allow future sharding algorithms to distribute clusters between shards based on the number of Applications they manage.