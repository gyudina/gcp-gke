resource "google_container_cluster" "new_cluster" {
  name        = var.cluster_name
  description = var.description
  location    = var.location

  network                  = var.network
  subnetwork               = var.subnetwork
  initial_node_count       = var.initial_node_count
  remove_default_node_pool = true
  resource_labels          = var.cluster_labels

}

resource "google_container_node_pool" "new_cluster_node_pool" {
  count = length(var.node_pools)

  name       = "${var.cluster_name}-pool-${count.index}"
  location   = var.location
  cluster    = google_container_cluster.new_cluster.name

  node_config {
    disk_size_gb    = lookup(var.node_pools[count.index], "disk_size_gb", 10)
    disk_type       = lookup(var.node_pools[count.index], "disk_type", "pd-standard")
    image_type      = lookup(var.node_pools[count.index], "image", "COS")
    local_ssd_count = lookup(var.node_pools[count.index], "local_ssd_count", 0)
    machine_type    = lookup(var.node_pools[count.index], "machine_type", "n1-standard-1")
    preemptible     = lookup(var.node_pools[count.index], "preemptible", false)
    service_account = lookup(var.node_pools[count.index], "service_account", "default")
    labels          = var.labels
    tags            = var.tags
    metadata        = var.metadata
  }

  autoscaling {
    min_node_count = lookup(var.node_pools[count.index], "min_node_count", 1)
    max_node_count = lookup(var.node_pools[count.index], "max_node_count", 3)
  }

  management {
    auto_repair  = lookup(var.node_pools[count.index], "auto_repair", true)
    auto_upgrade = lookup(var.node_pools[count.index], "auto_upgrade", true)
  }
}