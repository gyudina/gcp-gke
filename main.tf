locals {
    // Build a map of maps of node pools from a list of objects
  node_pool_names = [for np in toset(var.node_pools) : np.name]
  node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))
}

resource "google_container_cluster" "gke_private_cluster" {
  provider = google-beta

  project           = var.project
  name              = var.cluster_name
  description       = var.description
  resource_labels   = var.cluster_labels
  location          = var.location
  network           = var.network
  subnetwork        = var.subnetwork

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  private_cluster_config{
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
  
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        # display_name = cidr_blocks.value.display_name
      }
    }
  }

  enable_binary_authorization = true    

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  ip_allocation_policy {

 }

  network_policy {
    enabled  = var.network_policy
  }

  addons_config {
    network_policy_config {
      disabled = ! var.network_policy
    }
  }

  workload_identity_config { 
    identity_namespace = var.identity_namespace
  }

  lifecycle {
    ignore_changes = [node_pool, initial_node_count]
  }

  resource_usage_export_config {
    enable_network_egress_metering = var.enable_network_egress_metering

    bigquery_destination {
      dataset_id = var.dataset_id
    }
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    node_config {
      service_account = var.service_account
    }
  }

  remove_default_node_pool = true
}

resource "google_container_node_pool" "gke_private_cluster_node_pool" {
  name       = each.key
  for_each = local.node_pools
  
  location   = var.location
  cluster    = google_container_cluster.gke_private_cluster.name

  initial_node_count = lookup(each.value, "initial_node_count", 1)

  node_config {
    disk_size_gb    = lookup(each.value, "disk_size_gb", 20)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")
    image_type      = lookup(each.value, "image_type", "COS")
    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    machine_type    = lookup(each.value, "machine_type", "n1-standard-2")
    preemptible     = lookup(each.value, "preemptible", false)
    service_account = lookup(each.value, "service_account", "default")
    tags            = compact(split(",",lookup(each.value, "tags", "")))
    oauth_scopes    = compact(split(",",lookup(each.value, "oauth_scopes", "storage-ro,logging-write,monitoring")))   //https://cloud.google.com/sdk/gcloud/reference/container/node-pools/create
    labels          = lookup(var.node_pools_labels, lookup(each.value, "name", ""), {})
    metadata        = merge(lookup(var.node_pools_metadata, lookup(each.value, "name", ""), {}), var.metadata)

    guest_accelerator {
      type = lookup(each.value, "guest_accelerator_type", "")
      count = lookup(each.value, "guest_accelerator_count", 0)
    }

  }

  autoscaling {
    min_node_count = lookup(each.value, "min_node_count", 1)
    max_node_count = lookup(each.value, "max_node_count", 3)
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

