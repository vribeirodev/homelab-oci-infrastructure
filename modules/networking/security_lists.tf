# Security List para subnet pública
resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.homelab.id
  display_name   = "homelab-${var.environment}-public-security-list"

  # Egress rules - saída permitida para tudo
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound traffic"
  }

  # Ingress rules
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    description = "SSH access"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    description = "HTTP access"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    description = "HTTPS access"

    tcp_options {
      min = 443
      max = 443
    }
  }

  # Kubernetes API Server access
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    description = "Kubernetes API Server"

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Allow traffic from worker nodes subnet
  ingress_security_rules {
    protocol = "all"
    source   = var.private_subnet_cidr
    description = "Allow all traffic from worker nodes"
  }
}

# Security List para subnet privada (worker nodes)
resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.homelab.id
  display_name   = "homelab-${var.environment}-private-security-list"

  # Egress rules - permitir saída para internet via NAT Gateway
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound traffic"
  }

  # Ingress rules
  # SSH access from public subnet
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.public_subnet_cidr
    description = "SSH from public subnet"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Communication within private subnet
  ingress_security_rules {
    protocol = "all"
    source   = var.private_subnet_cidr
    description = "Allow all traffic within private subnet"
  }

  # Communication from public subnet (control plane)
  ingress_security_rules {
    protocol = "all"
    source   = var.public_subnet_cidr
    description = "Allow traffic from public subnet (control plane)"
  }

  # Kubelet port
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.public_subnet_cidr
    description = "Kubelet API"

    tcp_options {
      min = 10250
      max = 10250
    }
  }

  # Worker node ports
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.public_subnet_cidr
    description = "Worker node ports"

    tcp_options {
      min = 30000
      max = 32767
    }
  }

  # Pod-to-pod communication
  ingress_security_rules {
    protocol = "all"
    source   = "10.244.0.0/16"  # Pods CIDR
    description = "Pod to pod communication"
  }
}