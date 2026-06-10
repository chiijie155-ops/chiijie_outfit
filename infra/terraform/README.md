# Terraform Skeleton

This folder contains a starter Terraform skeleton for the Chiijie Outfit infrastructure.

## Structure
- `main.tf` - root module wiring network, EKS, RDS, Redis, and app modules.
- `provider.tf` - provider configuration.
- `variables.tf` - root input variables.
- `outputs.tf` - root outputs.
- `modules/` - skeleton modules for each infrastructure layer.

## Usage
1. Customize variables in a `terraform.tfvars` file.
2. Implement actual resources under each module.
3. Run `terraform init` and `terraform plan`.

Note: current modules are placeholders and must be completed before production use.
