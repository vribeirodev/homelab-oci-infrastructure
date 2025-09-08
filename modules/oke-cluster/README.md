<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_containerengine_cluster.oke_cluster](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_cluster) | resource |
| [oci_containerengine_node_pool.oke_node_pool](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_node_pool) | resource |
| [oci_containerengine_node_pool_option.oke_node_pool_option](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_node_pool_option) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nome do cluster OKE | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID do compartimento | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Ambiente (staging ou production) | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Versão do Kubernetes | `string` | `"v1.29.1"` | no |
| <a name="input_node_boot_volume_size_gb"></a> [node\_boot\_volume\_size\_gb](#input\_node\_boot\_volume\_size\_gb) | Tamanho do boot volume em GB | `number` | `100` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Número de worker nodes | `number` | `2` | no |
| <a name="input_node_memory_gb"></a> [node\_memory\_gb](#input\_node\_memory\_gb) | Memória em GB por worker node | `number` | `12` | no |
| <a name="input_node_ocpus"></a> [node\_ocpus](#input\_node\_ocpus) | OCPUs por worker node | `number` | `2` | no |
| <a name="input_node_shape"></a> [node\_shape](#input\_node\_shape) | Shape dos worker nodes | `string` | `"VM.Standard.A1.Flex"` | no |
| <a name="input_private_subnet_id"></a> [private\_subnet\_id](#input\_private\_subnet\_id) | OCID da subnet privada para worker nodes | `string` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | OCID da subnet pública para load balancers | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Chave SSH pública para acesso aos worker nodes | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | OCID da VCN onde criar o cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint do cluster OKE |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | OCID do cluster OKE |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Nome do cluster OKE |
| <a name="output_cluster_state"></a> [cluster\_state](#output\_cluster\_state) | Estado atual do cluster |
| <a name="output_debug_all_images"></a> [debug\_all\_images](#output\_debug\_all\_images) | n/a |
| <a name="output_debug_selected_image"></a> [debug\_selected\_image](#output\_debug\_selected\_image) | n/a |
| <a name="output_kubeconfig_command"></a> [kubeconfig\_command](#output\_kubeconfig\_command) | Comando para configurar kubeconfig |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | Versão do Kubernetes em uso |
| <a name="output_load_balancer_subnet"></a> [load\_balancer\_subnet](#output\_load\_balancer\_subnet) | Subnet para load balancers |
| <a name="output_node_pool_id"></a> [node\_pool\_id](#output\_node\_pool\_id) | OCID do node pool |
| <a name="output_worker_nodes_subnet"></a> [worker\_nodes\_subnet](#output\_worker\_nodes\_subnet) | Subnet onde estão os worker nodes |
<!-- END_TF_DOCS -->