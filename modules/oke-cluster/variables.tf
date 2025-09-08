variable "compartment_id" {
  description = "OCID do compartimento"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster OKE"
  type        = string
}

variable "environment" {
  description = "Ambiente (staging ou production)"
  type        = string
}

variable "vcn_id" {
  description = "OCID da VCN onde criar o cluster"
  type        = string
}

variable "public_subnet_id" {
  description = "OCID da subnet pública para load balancers"
  type        = string
}

variable "private_subnet_id" {
  description = "OCID da subnet privada para worker nodes"
  type        = string
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso aos worker nodes"
  type        = string
}

variable "node_count" {
  description = "Número de worker nodes"
  type        = number
  default     = 2
}

variable "node_shape" {
  description = "Shape dos worker nodes"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "node_ocpus" {
  description = "OCPUs por worker node"
  type        = number
  default     = 2
}

variable "node_memory_gb" {
  description = "Memória em GB por worker node"
  type        = number
  default     = 12
}

variable "node_boot_volume_size_gb" {
  description = "Tamanho do boot volume em GB"
  type        = number
  default     = 100
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "v1.29.1"
}