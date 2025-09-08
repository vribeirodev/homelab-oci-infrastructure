terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# Data source para availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Data source para imagens do worker node
data "oci_containerengine_node_pool_option" "oke_node_pool_option" {
  node_pool_option_id = "all"
}

# Cluster OKE (Basic tier - gratuito)
resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "${var.cluster_name}-${var.environment}"
  vcn_id             = var.vcn_id

  # Configuração do cluster tipo Basic (gratuito)
  type = "BASIC_CLUSTER"

  # Endpoint configuration
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id           = var.public_subnet_id
  }

  options {
    service_lb_subnet_ids = [var.public_subnet_id]

    # Complementos básicos
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled              = false
    }

    # Política de admissão
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }

    # Rede de pods e serviços
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
  }
}

# Node Pool para worker nodes
resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "${var.cluster_name}-${var.environment}-pool"

  # Configuração dos nodes
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id          = var.private_subnet_id
    }

    size = var.node_count
  }

  # Configuração da imagem e shape
  node_source_details {
    image_id                = local.node_image_id
    source_type            = "IMAGE"
    boot_volume_size_in_gbs = var.node_boot_volume_size_gb
  }

  node_shape = var.node_shape

  # Configuração do shape flexível (ARM A1)
  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_gb
  }

  # Metadados para SSH
  node_metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  # Configuração inicial dos nodes
  initial_node_labels {
    key   = "environment"
    value = var.environment
  }

  initial_node_labels {
    key   = "node-type"
    value = "worker"
  }
}

data "oci_containerengine_node_pool_option" "oke_node_pool_option_image" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

locals {
  # Filtrar imagens por arquitetura
  arm_images = [
    for image in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources :
    image if length(regexall("Oracle-Linux.*aarch64.*OKE", image.source_name)) > 0
  ]

  x86_images = [
    for image in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources :
    image if length(regexall("Oracle-Linux.*OKE", image.source_name)) > 0 &&
             length(regexall("aarch64", image.source_name)) == 0 &&
             length(regexall("GPU", image.source_name)) == 0
  ]

  # Selecionar imagem com fallback para evitar erro
  node_image_id = var.node_shape == "VM.Standard.A1.Flex" ? (
    length(local.arm_images) > 0 ? local.arm_images[0].image_id :
    data.oci_containerengine_node_pool_option.oke_node_pool_option.sources[0].image_id
  ) : (
    length(local.x86_images) > 0 ? local.x86_images[0].image_id :
    data.oci_containerengine_node_pool_option.oke_node_pool_option.sources[0].image_id
  )
}

output "debug_selected_image" {
  value = local.node_image_id
}

output "debug_all_images" {
  value = [
    for image in data.oci_containerengine_node_pool_option.oke_node_pool_option.sources :
    {
      id = image.image_id
      name = image.source_name
    } if length(regexall("Oracle-Linux.*OKE", image.source_name)) > 0
  ]
}