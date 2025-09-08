terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# Provider OCI
provider "oci" {
  region = var.region
}

# Data source para availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Módulo de networking
module "networking" {
  source = "../../../modules/networking"

  compartment_id      = var.compartment_id
  environment         = "production"
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  # Configuração de rede para produção
  vcn_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

# Módulo do cluster OKE
module "oke_cluster" {
  source = "../../../modules/oke-cluster"

  compartment_id     = var.compartment_id
  cluster_name       = var.cluster_name
  environment        = "production"

  # Networking do módulo anterior
  vcn_id             = module.networking.vcn_id
  public_subnet_id   = module.networking.public_subnet_id
  private_subnet_id  = module.networking.private_subnet_id

  # Configuração SSH
  ssh_public_key     = var.ssh_public_key

  # Configuração dos worker nodes (Always Free)
  node_count         = 2
  node_shape         = "VM.Standard.A1.Flex"
  node_ocpus         = 2  # 2 OCPUs por node = 4 total (limite Always Free)
  node_memory_gb     = 12 # 12GB por node = 24GB total (limite Always Free)
  node_boot_volume_size_gb = 100

  # Versão do Kubernetes
  kubernetes_version = var.kubernetes_version
}
