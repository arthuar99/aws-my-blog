# AWS Blog Infrastructure

![CI/CD](https://github.com/arthuar99/aws-my-blog/workflows/Terraform%20Validate%20%26%20Format/badge.svg)

Infrastructure as Code (IaC) for a serverless blog application deployed on AWS using Terraform. This project provisions API Gateway, Lambda functions, DynamoDB, S3, CloudFront, SES, and related AWS services.

**Features:**
- 🚀 Fully automated CI/CD pipeline with GitHub Actions
- ☁️ Serverless architecture on AWS
- 📦 Automatic Lambda packaging and deployment
- 🔒 Security scanning and best practices validation
- 💰 Cost estimation on pull requests (optional)

## Project Structure

```
.
├── apigateway.tf              # API Gateway configuration and endpoints
├── archive.tf                 # archive_file data sources for packaging Lambdas
├── cloudfront.tf              # CloudFront CDN configuration
├── dynamodb.tf                # DynamoDB tables for blog posts
├── iam.tf                     # IAM roles and policies for Lambda functions
├── lambda-api.tf              # Lambda function for blog posts API
├── lambda-thumbnail.tf        # Lambda function for thumbnail generation
├── s3-photo.tf                # S3 bucket for photo storage
├── s3-static.tf               # S3 bucket for static assets
├── ses.tf                     # SES configuration for email notifications
├── outputs.tf                 # Terraform outputs (endpoints, bucket names, etc.)
├── provider.tf                # AWS provider configuration
├── random.tf                  # Random resource IDs for unique naming
├── variables.tf               # Terraform variables and defaults
├── lambda/
│   ├── api_posts/             # API Lambda source (packaged by archive_file)
│   │   └── lambda_function.py
│   ├── thumbnail/             # Thumbnail Lambda source (packaged by archive_file)
│   │   └── lambda_function.py
│   ├── welcome_email/         # Welcome-email Lambda source (packaged by archive_file)
│   │   └── lambda_function.py
│   └── build/                 # Generated ZIPs (ignored by Git)
│       ├── api_posts_function.zip
│       ├── thumbnail_function.zip
│       └── welcome_email_function.zip
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## Prerequisites

Before deploying this infrastructure, ensure you have the following installed:

- **Terraform** (v1.0 or later) — [Install Terraform](https://www.terraform.io/downloads)
- **AWS CLI** (v2) — [Install AWS CLI](https://aws.amazon.com/cli/)
- **Python 3.12+** — [Install Python](https://www.python.org/downloads)
- **Git** — For version control

## Getting Started

### 1. Clone and Configure AWS Credentials

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd aws-blog
aws configure
```

Enter your AWS Access Key ID, Secret Access Key, default region, and output format when prompted.

### 2. Review and Set Variables

Create a `terraform.tfvars` file in the project root with your custom values:

```hcl
# terraform.tfvars
region = "us-east-1"
# Add any other variable overrides here
```

For reference, see `variables.tf` for all available configuration options.

### 3. Initialize Terraform

```bash
terraform init
```

This command downloads the AWS provider plugin and initializes the `.terraform/` directory.

### 4. Plan the Deployment

```bash
terraform plan -out=tfplan
```

Review the plan to ensure all resources match your expectations. This creates a snapshot plan file.

### 5. Apply the Configuration

```bash
terraform apply tfplan
```

Terraform will provision all AWS resources. This may take several minutes. After completion, review the outputs (API endpoints, S3 bucket names, etc.) displayed in the terminal.

### 6. Verify Deployment

```bash
terraform output
```

This displays all outputs defined in `outputs.tf`, including API Gateway URL, CloudFront distribution domain, and S3 bucket names.

## Lambda Packaging (via archive_file)

Lambdas are packaged automatically by Terraform using the `archive_file` data source (see `archive.tf`).

- Place handler code here:
  - `lambda/api_posts/lambda_function.py`
  - `lambda/thumbnail/lambda_function.py`
  - `lambda/welcome_email/lambda_function.py`
- On `terraform plan/apply`, Terraform zips each directory into `lambda/build/*.zip` and injects:
  - `filename = data.archive_file.<name>.output_path`
  - `source_code_hash = data.archive_file.<name>.output_base64sha256`

No manual zipping or committing binaries is required. The `lambda/build/` directory is ignored by Git.

## Environment Variables

Create a `.env` file in the project root for local development (not tracked by Git):

```
AWS_PROFILE=default
AWS_REGION=us-east-1
TF_VAR_environment=production
```

This file is ignored by `.gitignore` to prevent accidentally committing secrets.

## Security

### Best Practices Implemented

- **State File Security:** Terraform state files are excluded from version control. Store remote state in AWS S3 with encryption and versioning enabled.
- **Secrets Management:** No AWS credentials are hardcoded. Use AWS IAM roles, assume roles, or AWS Secrets Manager.
- **Least Privilege IAM:** Each Lambda function has a dedicated IAM role with minimal required permissions.
- **Environment Isolation:** Use separate AWS accounts or Terraform workspaces for dev, staging, and production environments.

### Recommended Next Steps

1. **Enable Remote State:** Configure S3 backend for Terraform state:

   ```bash
   # Create backend.tf with your S3 bucket details
   ```

2. **Enable State Encryption:** Use S3 server-side encryption and DynamoDB for state locking.

3. **Use AWS Secrets Manager:** Store sensitive data like SES email addresses and API keys.

4. **Enable CloudTrail:** Audit all AWS API calls for compliance.

## CI/CD

GitHub Actions workflows are provided under `.github/workflows`.

Key behaviors related to Lambda packaging:
- `terraform-plan.yml` runs on pull requests that change Terraform or Lambda source files:
  - paths:
    - `**.tf`
    - `lambda/**`
- `terraform-validate.yml` performs basic checks and scans for obvious secrets across nested Lambda sources:
  - grep target updated to `lambda/**/*.py`

Manual apply is available via the "Terraform Apply (Manual)" workflow.

## Testing

To test the deployed infrastructure:

```bash
# Test API Gateway endpoint
curl https://YOUR_API_ENDPOINT/posts

# List S3 buckets created
aws s3 ls

# Check Lambda functions
aws lambda list-functions --region us-east-1
```

## Cleanup

To destroy all provisioned AWS resources and avoid unnecessary charges:

```bash
terraform destroy
```

Review the plan carefully. When prompted, type `yes` to confirm deletion.

**Important:** This command is destructive and will delete:

- DynamoDB tables and data
- S3 buckets (if empty)
- Lambda functions
- API Gateway endpoints
- IAM roles and policies
- All other infrastructure defined in Terraform files

If you have important data in S3 or DynamoDB, back it up before running destroy.

## Troubleshooting

### Terraform Init Fails

```bash
rm -rf .terraform .terraform.lock.hcl
terraform init
```

### Lambda Function Errors

Check CloudWatch logs:

```bash
aws logs tail /aws/lambda/myblog-api-posts --follow
```

### State Lock Issues

If Terraform is stuck on a locked state:

```bash
terraform force-unlock LOCK_ID
```

(Replace `LOCK_ID` from the error message)

### S3 Bucket Name Conflicts

S3 bucket names are globally unique. If you encounter a "bucket already exists" error, modify the `random_string` resource in `random.tf` to generate a unique suffix.

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make changes and test with `terraform plan`
3. Commit with clear messages: `git commit -m "Add feature description"`
4. Push to GitHub: `git push origin feature/your-feature`
5. Open a pull request for review

## Cost Estimation

Use Terraform Cost Estimation (requires `infracost` CLI):

```bash
infracost breakdown --path .
```

For a rough estimate, this infrastructure incurs costs for:

- DynamoDB provisioned throughput
- Lambda invocations and duration
- S3 storage and data transfer
- CloudFront distribution
- SES email sending

Monitor AWS Billing Dashboard regularly: https://console.aws.amazon.com/billing/

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Support

For issues, questions, or contributions, please open a GitHub issue or contact the repository maintainer.

---

**Last Updated:** November 11, 2025
**Terraform Version:** 1.0+
**AWS Region:** Configurable (default: us-east-1)
