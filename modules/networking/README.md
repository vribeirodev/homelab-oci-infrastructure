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
| [oci_core_internet_gateway.homelab](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_nat_gateway.homelab](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_nat_gateway) | resource |
| [oci_core_route_table.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.homelab](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID do compartimento | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Ambiente (staging ou production) | `string` | n/a | yes |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | CIDR da subnet privada | `string` | `"10.0.2.0/24"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | CIDR da subnet pública | `string` | `"10.0.1.0/24"` | no |
| <a name="input_vcn_cidr"></a> [vcn\_cidr](#input\_vcn\_cidr) | CIDR da VCN | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_domains"></a> [availability\_domains](#output\_availability\_domains) | Lista de availability domains disponíveis |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | OCID do Internet Gateway |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | OCID do NAT Gateway |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | OCID da subnet privada |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | OCID da subnet pública |
| <a name="output_vcn_cidr"></a> [vcn\_cidr](#output\_vcn\_cidr) | CIDR da VCN |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | OCID da VCN criada |
<!-- END_TF_DOCS -->