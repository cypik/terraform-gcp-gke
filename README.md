# terraform-gcp-gke
# Google Cloud Infrastructure Provisioning with Terraform
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create GKE .
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
# Example: gke
```hcl
module "gke" {
  source             = "git::https://github.com/cypik/terraform-gcp-gke.git?ref=v1.0.0"
  name               = "app"
  environment        = "test"
  region             = "asia-northeast1"
  image_type         = "UBUNTU_CONTAINERD"
  location           = "asia-northeast1"
  min_master_version = "1.27.3-gke.100"
  service_account    = ""
  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 1
  disk_size_gb       = 20
  network            = module.vpc.vpc_id
  subnetwork         = module.subnet.subnet_id
}
```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs

- 'name'  : The name of the gke.
- 'environment': The environment type.
- 'project_id' : The GCP project ID.
- 'location': The location (region or zone) in which the cluster master will be created, as well as the default node location.
- 'image_type':  The default image type used by NAP once a new node pool is being created.
- 'min_master_version' : The minimum version of the master.
- 'service_account' : The Google Cloud Platform Service Account to be used by the node VMs created by GKE Autopilot or NAP.
- 'initial_node_count' : The number of nodes to create in this cluster's default node pool.
- 'min_node_count' : Minimum number of nodes per zone in the NodePool.
- 'max_node_count' :  Maximum number of nodes per zone in the NodePool.
-'disk_size_gb' : Size of the disk attached to each node, specified in GB.
- 'network' :  The name or self_link of the Google Compute Engine network to which the cluster is connected.
- 'subnetwork' :  The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched.

## Module Outputs
Each module may have specific outputs. You can retrieve these outputs by referencing the module in your Terraform configuration.

- 'id' : An identifier for the resource with format.
- 'endpoint' : The IP address of this cluster's Kubernetes master.
- 'cluster_ca_certificate': Base64 encoded public certificate that is the root certificate of the cluster.
- 'self_link' : The server-defined URL for the resource.
- 'label_fingerprint': An identifier for the resource with format
- 'maintenance_policy': Duration of the time window, automatically chosen to be smallest possible in the given scenario.
- 'master_version' :The current version of the master in the cluster.
- 'cluster_location' :  Location of the GKE cluster .
- 'node_id' : An identifier for the resource with format.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-gcp-gke/tree/master/example) directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/cypik/terraform-gcp-gke/blob/master/LICENSE) file for details.
