variable "compartment_id" {
  description = "OCID do compartimento OCI"
  type        = string
}

variable "region" {
  description = "Região OCI"
  type        = string
  default     = "us-ashburn-1"
}

variable "cluster_name" {
  description = "Nome base do cluster"
  type        = string
  default     = "homelab"
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso aos worker nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "v1.29.1"
}