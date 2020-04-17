variable project {
  description = "The ID of the project in which the resource belongs."
}

variable cluster_name {
  description = "The name of the cluster, unique within the project and location."
}

variable description {
  description = "Description of the cluster."
  default     = ""
}

variable cluster_labels {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type        = map
  default     = {}
}

variable location {
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

variable network {
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network."
}

variable subnetwork {
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched."
}

variable logging_service {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable monitoring_service {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none."
  default     = "monitoring.googleapis.com/kubernetes"
}

variable enable_private_nodes {
  description = "Nodes have internal IP addresses only."
  default     = true
}

variable enable_private_endpoint {
  description = "The master's internal IP address is used as the cluster endpoint. If set to false the private endpoint is created, but it also creates the public endpoint which allows to add CIDR with external addresses to master authorized networks."
  default     = false
}

variable master_ipv4_cidr_block {
  description = "The IP range in CIDR notation to use for the hosted master network."
}

variable master_authorized_networks {
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  type = list(map(string))
  default     = []
}

variable network_policy {
  description = "Enable network policy addon."
  default     = true
}

variable identity_namespace {
  description = "Workload Identity allows Kubernetes service accounts to act as a user-managed Google IAM Service Account."
}

variable enable_network_egress_metering {
  description = "Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic."
}

variable dataset_id {
  description = "The ID of a BigQuery Dataset."
}

variable initial_node_count {
  description = "The number of nodes to create in this cluster's default node pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Must be set if node_pool is not set. If you're using google_container_node_pool objects with no default node pool, you'll need to set this to a value of at least 1, alongside setting remove_default_node_pool to true."
  default     = 1
}

variable service_account {
   description = "The service account to be used by the Node VMs. If not specified, the 'default' service account is used." 
   default = ""
}

variable metadata {
  description = "The metadata key/value pairs assigned to instances in the cluster."
  type        = map
  default     = {disable-legacy-endpoints:true}
}

//node_pools 

variable node_pools {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-pool"
    },
  ]
}

variable node_pools_labels {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"

  default = {}
}

variable node_pools_metadata {
  type        = map(map(string))
  description = "The metadata key/value pairs assigned to instances in the cluster."
  default     = {}
}