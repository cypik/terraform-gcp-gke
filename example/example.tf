provider "google" {
  project = "opz0-xxxx"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::git@github.com:opz0/terraform-gcp-vpc.git?ref=master"
  name                                      = "app"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  project_id                                = "opz0-xxxx"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

####==============================================================================
#### subnet module call.
####==============================================================================
module "subnet" {
  source        = "git::git@github.com:opz0/terraform-gcp-subnet.git?ref=master"
  name          = "subnet"
  environment   = "test"
  gcp_region    = "asia-northeast1"
  network       = module.vpc.vpc_id
  project_id    = "opz0-xxxx"
  source_ranges = ["10.10.0.0/16"]
}

####==============================================================================
#### firewall module call.
####==============================================================================
module "firewall" {
  source        = "git::git@github.com:opz0/terraform-gcp-firewall.git?ref=master"
  name          = "app11"
  environment   = "test"
  project_id    = "opz0-xxxx"
  network       = module.vpc.vpc_id
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

####==============================================================================
#### service-account module call.
####==============================================================================
module "service-account" {
  source                             = "git@github.com:opz0/terraform-gcp-Service-account.git"
  name                               = "app"
  environment                        = "test"
  project_id                         = "opz0-xxxx"
  google_service_account_key_enabled = true
  key_algorithm                      = "KEY_ALG_RSA_2048"
  public_key_type                    = "TYPE_X509_PEM_FILE"
  private_key_type                   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  members                            = []
}

####==============================================================================
#### gke module call.
####==============================================================================
module "gke" {
  source              = "../"
  name                = "test"
  environment         = "app"
  project_id          = "opz0-xxxx"
  region              = "asia-northeast1"
  image_type          = "UBUNTU_CONTAINERD"
  location            = "asia-northeast1"
  min_master_version  = "1.27.3-gke.100"
  kubectl_config_path = "~/.kube/config"
  service_account     = ""
  initial_node_count  = 1
  node_count          = 0
  min_node_count      = 1
  max_node_count      = 1
  disk_size_gb        = 20
  network             = module.vpc.vpc_id
  subnetwork          = module.subnet.subnet_id
}