# Infrastructure as Code (Terraform)

This directory contains modular, reusable Terraform code to provision AWS networking, EKS (Kubernetes), IAM, and supporting resources. The modules are designed for compliance, automation, and production-readiness.

## Structure
```
infra/
├── modules/
│   ├── network/      # VPC, subnets, NAT, etc.
│   ├── eks/          # Kubernetes cluster and node groups
│   ├── iam/          # IAM roles and policies
│   └── ...           # Other modules (e.g., RDS, S3)
├── environments/
│   ├── dev/          # Example environment
│   └── prod/         # Production environment
```

## Getting Started

1. **Install Terraform:**
   https://learn.hashicorp.com/tutorials/terraform/install-cli

2. **Configure AWS credentials:**
   - Use environment variables, AWS CLI, or `~/.aws/credentials`.

3. **Initialize and apply:**
   ```bash
   cd environments/dev
   terraform init
   terraform plan
   terraform apply
   ```

## Compliance & Tagging
- All resources are tagged for cost allocation and compliance.
- Example policies (see `../policy/`):
  - No public S3 buckets
  - Enforce required tags

## Automation
- Designed for use in CI/CD pipelines (see project root `.github/workflows/`).
- Supports ephemeral environments and automated teardown.

## Customization
- Edit variables in `environments/dev/variables.tf` to customize your deployment.
- Add or override modules as needed.

## Example Usage
See `environments/dev/main.tf` for a sample deployment using the modules.

---

For more details, see the main project README and the `policy/` directory for compliance examples.
