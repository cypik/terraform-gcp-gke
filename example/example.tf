provider "google" {
  project = "opz0-397319"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::https://github.com/opz0/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "app"
  environment                               = "test"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

####==============================================================================
#### subnet module call.
####==============================================================================
module "subnet" {
  source        = "git::https://github.com/opz0/terraform-gcp-subnet.git?ref=v1.0.0"
  name          = "app"
  environment   = "test"
  gcp_region    = "asia-northeast1"
  network       = module.vpc.vpc_id
  ip_cidr_range = "10.10.0.0/16"
}

####==============================================================================
#### firewall module call.
####==============================================================================
module "firewall" {
  source        = "git::https://github.com/opz0/terraform-gcp-firewall.git?ref=v1.0.0"
  name          = "app"
  environment   = "test"
  network       = module.vpc.self_link
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

#####==============================================================================
##### service-account module call .
#####==============================================================================
module "service-account" {
  source           = "git::https://github.com/opz0/terraform-gcp-Service-account.git?ref=v1.0.0"
  name             = "app"
  environment      = "test"
  key_algorithm    = "KEY_ALG_RSA_2048"
  public_key_type  = "TYPE_X509_PEM_FILE"
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"
  members          = []
}

####==============================================================================
#### gke module call.
####==============================================================================
module "gke" {
  source             = "../"
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