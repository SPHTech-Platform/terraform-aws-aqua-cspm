<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.65.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 1.5.0 |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 4.10.1 |
| <a name="module_lambda_role"></a> [lambda\_role](#module\_lambda\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~> 5.9.0 |
| <a name="module_sechub_integration_lambda"></a> [sechub\_integration\_lambda](#module\_sechub\_integration\_lambda) | terraform-aws-modules/lambda/aws | ~> 4.10.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aqua_cspm_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aqua_cspm_supplemental](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aquasec_importfindings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aqua_cspm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.aqua_cspm_sechub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aqua_cspm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aqua_cspm_sechub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_invocation.external_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.onboarding](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.sechub_integration_external_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.sechub_integration_onboarding](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_secretsmanager_secret.aqua_cspm_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.aqua_cspm_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.aqua_cspm_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [time_sleep.sechub_integration_wait_10_aqua_cspm_secret](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.sechub_integration_wait_10_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_10_aqua_cspm_secret](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_10_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.aqua_cspm_control_tower_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aqua_cspm_custom_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aqua_cspm_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aqua_cspm_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aqua_cspm_supplemental](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aquahub_sechub_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aquasec_importfindings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_cspm_apikey"></a> [aqua\_cspm\_apikey](#input\_aqua\_cspm\_apikey) | Aqua CSPM API key: Account Management > API Keys > Generate Key | `string` | n/a | yes |
| <a name="input_aqua_cspm_secretkey"></a> [aqua\_cspm\_secretkey](#input\_aqua\_cspm\_secretkey) | Aqua CSPM Secret | `string` | n/a | yes |
| <a name="input_aqua_group_name"></a> [aqua\_group\_name](#input\_aqua\_group\_name) | Aqua CSPM Group Name from the Aqua Wave console | `string` | `"Default"` | no |
| <a name="input_aqua_sechub_integration"></a> [aqua\_sechub\_integration](#input\_aqua\_sechub\_integration) | Enables aqua security hub integration. If enabled, findings from Aquasec will be pushed to security hub.<br>Notification type can be either "send\_all" or "send\_only\_failed". Default is "send\_all" | <pre>object({<br>    enabled           = bool<br>    notification_type = optional(string, "send_all")<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_enable_kms_key_rotation"></a> [enable\_kms\_key\_rotation](#input\_enable\_kms\_key\_rotation) | Specifies whether key rotation is enabled. Defaults to true | `bool` | `true` | no |
| <a name="input_kms_aliases"></a> [kms\_aliases](#input\_kms\_aliases) | A list of aliases to create. Note - due to the use of toset(), values must be static strings and not computed values | `list(string)` | <pre>[<br>  "alias/AquaCSPM-Control-Tower-AquaSec"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_onboarding_data"></a> [onboarding\_data](#output\_onboarding\_data) | Details of the onboarding |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Create Lambda Zip Archive

Need to Python Zip Archive with build libraries, Steps as follows:
* Switch to `src/lambda_fuction` directory
    `cd src/lambda_fuction`

* Install the libraries by executing the following command
    `pip3 install -r requirements.txt -t .`

* Zip the directory
    `zip -r9 lambda_function.zip *`
