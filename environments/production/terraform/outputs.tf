output "cluster_info" {
  description = "Informações do cluster OKE"
  value = {
    cluster_id       = module.oke_cluster.cluster_id
    cluster_name     = module.oke_cluster.cluster_name
    cluster_endpoint = module.oke_cluster.cluster_endpoint
    cluster_state    = module.oke_cluster.cluster_state
  }
}

output "networking_info" {
  description = "Informações da rede"
  value = {
    vcn_id            = module.networking.vcn_id
    public_subnet_id  = module.networking.public_subnet_id
    private_subnet_id = module.networking.private_subnet_id
  }
}

output "kubeconfig_command" {
  description = "Comando para configurar acesso ao cluster"
  value       = module.oke_cluster.kubeconfig_command
}

output "quick_access" {
  description = "Comandos úteis para acesso rápido"
  value = {
    configure_kubectl = module.oke_cluster.kubeconfig_command
    check_nodes      = "kubectl get nodes"
    check_pods       = "kubectl get pods -A"
  }
}

output "environment_summary" {
  description = "Resumo do ambiente"
  value = {
    environment        = "production"
    cluster_name       = module.oke_cluster.cluster_name
    kubernetes_version = module.oke_cluster.kubernetes_version
    region            = var.region
    worker_nodes      = 2
    total_cpu         = "4 OCPUs"
    total_memory      = "24 GB"
  }
}
