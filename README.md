# Homelab OCI Infrastructure

[![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://cloud.oracle.com)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io)

[![Terraform Validation](https://github.com/vribeirodev/homelab-oci-infrastructure/workflows/Terraform%20Validation/badge.svg)](https://github.com/vribeirodev/homelab-oci-infrastructure/actions/workflows/terraform-validation.yml)
[![Documentation](https://github.com/vribeirodev/homelab-oci-infrastructure/workflows/Documentation%20Sync/badge.svg)](https://github.com/vribeirodev/homelab-oci-infrastructure/actions/workflows/documentation.yml)

Infraestrutura como código para Oracle Cloud Infrastructure (OCI) usando Terraform, para criar um cluster Kubernetes (OKE) gratuito para projetos pessoais, portfólio e uso pela comunidade.

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    Oracle Cloud (OCI)                       │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                VCN (10.0.0.0/16)                     │  │
│  │  ┌─────────────────┐    ┌─────────────────────────┐  │  │
│  │  │  Public Subnet  │    │    Private Subnet       │  │  │
│  │  │  (10.0.1.0/24)  │    │    (10.0.2.0/24)       │  │  │
│  │  │                 │    │                         │  │  │
│  │  │ • OKE Control   │    │ • Worker Nodes          │  │  │
│  │  │   Plane         │    │   (ARM A1.Flex)        │  │  │
│  │  │ • Load Balancers│    │ • 2x2 OCPUs + 12GB     │  │  │
│  │  │                 │    │                         │  │  │
│  │  └─────────────────┘    └─────────────────────────┘  │  │
│  │           │                         │                │  │
│  │    Internet Gateway            NAT Gateway           │  │
│  └───────────┼─────────────────────────┼────────────────┘  │
│              │                         │                   │
│          Internet                 Outbound Traffic         │
└─────────────────────────────────────────────────────────────┘
```

### Componentes

- **VCN**: Rede virtual isolada (10.0.0.0/16)
- **Public Subnet**: Control plane e load balancers (10.0.1.0/24)
- **Private Subnet**: Worker nodes seguros (10.0.2.0/24)
- **OKE Cluster**: Kubernetes gerenciado (Basic tier gratuito)
- **Security Lists**: Regras específicas para OKE

## Custos

### Always Free Tier
- **Custo**: $0/mês (permanente)
- **Recursos**: 4 OCPUs ARM, 24GB RAM, 200GB storage
- **Limitações**: Disponibilidade de capacidade pode ser baixa

### Pay-as-you-go (Recomendado)
- **Custo**: ~$0 (Desde que nao altere o shape configurado)
- **Vantagens**: Melhor disponibilidade, shapes adicionais
- **Proteção**: Configure budget alerts

> **⚠️ Importante**
> > **⚠️** A região é definida na criação da conta OCI e não pode ser alterada depois. 
> > Ao fazer o upgrade da conta a Oracle realiza uma cobrança no cartao no valor de 100 dolares que e estornada automaticamente
> > tenha certeza de criar um alerta de budget para nao falir

## Quick Start

### Pré-requisitos

```bash
# Instalar OCI CLI
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

# Instalar Terraform
sudo dnf install terraform  # Fedora
# ou
brew install terraform      # macOS

# Instalar kubectl
sudo dnf install kubernetes1.33-client  # Fedora
# ou
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/
```

### Configuração

1. **Clone o repositório**:
```bash
  git clone <seu-repo>
cd homelab-oci-infrastructure
```

2. **Configure OCI CLI**:
```bash
  oci setup config
```

3. **Configure variáveis**:
```bash
  cd environments/production/terraform
cp terraform.tfvars.example terraform.tfvars
```

4. **Edite `terraform.tfvars`**:
```hcl
# OBRIGATÓRIO
compartment_id = "ocid1.compartment.oc1..aaaaaaaa..."
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC..."

# OPCIONAL (ajuste conforme sua região)
region             = "sa-vinhedo-1"  # ou sua região
cluster_name       = "homelab"
kubernetes_version = "v1.33.1"
```

### Deploy

```bash
# Inicializar Terraform
terraform init

# Planejar deployment
terraform plan

# Aplicar (Always Free)
terraform apply

# OU usar script de retry para ARM A1.Flex
chmod +x scripts/retry-deploy.sh
./scripts/retry-deploy.sh
```

### Conectar ao cluster

```bash
# Configurar kubectl
oci ce cluster create-kubeconfig \
  --cluster-id <cluster-id-do-output> \
  --file ~/.kube/config \
  --region <sua-região> \
  --token-version 2.0.0 \
  --kube-endpoint PUBLIC_ENDPOINT

# Verificar nodes
kubectl get nodes

# Verificar pods do sistema
kubectl get pods -A
```

## Configurações

### Always Free (Padrão)
```hcl
node_count         = 2
node_shape         = "VM.Standard.A1.Flex"
node_ocpus         = 2   # Por node (4 total)
node_memory_gb     = 12  # Por node (24GB total)
```

##  Troubleshooting

### Problema: "Out of host capacity" (ARM A1.Flex)

**Sintomas**:
```
Error: 500, InternalError, Out of host capacity
```

**Soluções**:

1. **Use o script de retry**:
```bash
./scripts/retry-deploy.sh
```

2. **Upgrade para pay-as-you-go**:
   - Melhor disponibilidade de recursos
   - Configure budget para proteção

### Problema: "Node shape and image are not compatible"

**Sintomas**:
```
Error: Invalid nodeShape: Node shape and image are not compatible
```

**Causa**: Imagem ARM sendo usada com shape x86 (ou vice-versa)

**Solução**: O código já tem lógica automática para resolver isso. Se persistir:
```bash
  terraform destroy -target=module.oke_cluster.oci_containerengine_node_pool.oke_node_pool
terraform apply
```

### Problema: "2 node(s) register timeout"

**Sintomas**:
```
Error: work request did not succeed... 2 nodes(s) register timeout
```

**Causa**: Security lists bloqueando comunicação OKE

**Solução**: Os security lists já estão configurados corretamente com:
- Porta 6443 (Kubernetes API)
- Porta 10250 (Kubelet)
- Portas 30000-32767 (NodePort)
- Comunicação entre subnets

### Problema: kubectl não funciona

**Sintomas**:
```bash
kubectl: comando não encontrado
```

**Solução**:
```bash
# Fedora/RHEL
sudo dnf install kubernetes1.33-client

# Ubuntu/Debian
sudo apt-get install kubectl

# macOS
brew install kubectl
```

## Ambientes

### Production
```bash
  cd environments/production/terraform
terraform apply
```

### Staging (Preparado)
```bash
  cd environments/staging/terraform
# Configurar terraform.tfvars similar ao production
terraform apply
```

## Estrutura do Projeto

```
.
├── environments/
│   ├── production/          # Ambiente de produção
│   │   └── terraform/
│   └── staging/             # Ambiente de teste
│       └── terraform/
├── modules/
│   ├── networking/          # VCN, subnets, security lists
│   └── oke-cluster/         # Cluster OKE e node pools
├── applications/            # Aplicações futuras
│   └── monitoring/
└── scripts/
    └── retry-deploy.sh      # Script para ARM A1.Flex
```

### Módulos

**networking/**:
- VCN e subnets
- Internet e NAT Gateways
- Security lists otimizados para OKE
- Route tables

**oke-cluster/**:
- Cluster OKE (Basic tier gratuito)
- Node pools com seleção automática de imagem
- Configuração ARM/x86 inteligente

## Configurações Avançadas

### Personalizar Security Lists

```hcl
# Adicionar porta customizada
ingress_security_rules {
  protocol = "6"
  source   = "0.0.0.0/0"
  description = "Custom application"
  
  tcp_options {
    min = 8080
    max = 8080
  }
}
```

### Diferentes Shapes

```hcl
# Always Free ARM
node_shape = "VM.Standard.A1.Flex"

# x86 econômico
node_shape = "VM.Standard.E2.1"

# x86 performático
node_shape = "VM.Standard.E2.4"
```

### Multi-AZ (Preparado)

O código está preparado para multi-AZ. Para habilitar:
```hcl
# Em oke-cluster/main.tf, adicione placement_configs adicionais
placement_configs {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  subnet_id          = var.private_subnet_id
}
```

## Próximos Passos

### Aplicações

```bash
# Instalar ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Instalar cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

### Monitoramento

```bash
# Preparado em applications/monitoring/
# Prometheus, Grafana, AlertManager
```

### CI/CD

```bash
# GitHub Actions / GitLab CI preparado
# Auto-deploy para staging/production
```

## Segurança

### Recomendações

- **SSH Keys**: Use chaves SSH fortes (Ed25519)
- **Network**: Workers em subnet privada
- **RBAC**: Configure roles Kubernetes adequados
- **Secrets**: Use OCI Vault para secrets sensíveis

### Security Lists

O projeto implementa security lists seguindo princípios de menor privilégio:
- Comunicação OKE mínima necessária
- Acesso SSH restrito a subnets específicas
- Pod-to-pod isolado por namespace (configurável)

## Contribuindo

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/amazing-feature`)
3. Commit suas mudanças (`git commit -m 'Add amazing feature'`)
4. Push para a branch (`git push origin feature/amazing-feature`)
5. Abra um Pull Request

### Guidelines

- Teste 
- Documente mudanças significativas
- Mantenha compatibilidade com Always Free
- Siga convenções Terraform

## Referências

- [Oracle Cloud Documentation](https://docs.oracle.com/en-us/iaas/)
- [OKE Documentation](https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm)
- [Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [Always Free Resources](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)

## ⚖️ Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

---
