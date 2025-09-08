variable "compartment_id" {
  description = "OCID do compartimento"
  type        = string
}

variable "environment" {
  description = "Ambiente (staging ou production)"
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR da VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_domain" {
  description = "Availability domain"
  type        = string
}
