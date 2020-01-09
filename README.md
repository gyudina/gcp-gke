# GKE module

## About

This Terraform module creates Kubernetes cluster without default node pool for GCP project.


```
export GOOGLE_CLOUD_KEYFILE_JSON=<path_to_key_json_file>
export GOOGLE_CREDENTIALS=<path_to_key_json_file>
```

## Usage Example
```
module "" {
  source = ""

  cluster_name = "<CLUSTER NAME>"
  location     = "us-central1"
  network      = "<NETWORK>"
  subnetwork   = "<SUBNETWORK>"

  cluster_labels = {
    env     = "",
  }

 
  node_pools = [
    {
      machine_type   = "n1-standard-8"
      disk_size_gb   = 20
      min_node_count = 0
      max_node_count = 50
      service_account = ""
    },
  ]
}
```