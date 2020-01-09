variable cluster_name {
  description = "The name of the cluster, unique within the project and location."
}

variable description {
  description = "Description of the cluster."
  default     = ""
}

variable location {
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable network {
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network."
}

variable subnetwork {
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched."
}

variable initial_node_count {
  description = "The number of nodes to create in this cluster's default node pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Must be set if node_pool is not set. If you're using google_container_node_pool objects with no default node pool, you'll need to set this to a value of at least 1, alongside setting remove_default_node_pool to true."
  default     = 1
}

variable cluster_labels {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type        = map
  default     = {}
}

//node_pools
// node_count (default: 3)
// machine_type (default: n1-standard-1)
// disk_size_gb (default: 10)
// preemptible (default: false)
// service_account (default: default)
// local_ssd_count (default: 0)
// min_node_count (default: 1)
// max_node_count (default: 3)
// auto_repair (default: true)
// auto_upgrade (default: true)
// metadata (default: {})
variable node_pools {
  type        = list
  default     = []
  description = "Node pool setting to create"
}

variable tags {
  type        = list
  default     = []
  description = "The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls"
}

variable labels {
  description = "The Kubernetes labels (key/value pairs) to be applied to each node"
  type        = map
  default     = {}
}

variable metadata {
  description = "The metadata key/value pairs assigned to instances in the cluster"
  type        = map
  default     = {}
}
