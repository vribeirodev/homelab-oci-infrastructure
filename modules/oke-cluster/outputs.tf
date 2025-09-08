output "cluster_id" {
  description = "OCID do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.id
}

output "cluster_name" {
  description = "Nome do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.endpoints[0].public_endpoint
}

output "node_pool_id" {
  description = "OCID do node pool"
  value       = oci_containerengine_node_pool.oke_node_pool.id
}

output "kubernetes_version" {
  description = "Versão do Kubernetes em uso"
  value       = oci_containerengine_cluster.oke_cluster.kubernetes_version
}

output "kubeconfig_command" {
  description = "Comando para configurar kubeconfig"
  value       = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.oke_cluster.id} --file ~/.kube/config --region ${var.compartment_id} --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT"
}

output "cluster_state" {
  description = "Estado atual do cluster"
  value       = oci_containerengine_cluster.oke_cluster.state
}

output "worker_nodes_subnet" {
  description = "Subnet onde estão os worker nodes"
  value       = var.private_subnet_id
}

output "load_balancer_subnet" {
  description = "Subnet para load balancers"
  value       = var.public_subnet_id
}
