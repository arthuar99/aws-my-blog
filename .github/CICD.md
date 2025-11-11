# CI/CD Pipeline Documentation

This project uses GitHub Actions for continuous integration and continuous deployment (CI/CD) of Terraform infrastructure.

## Workflows Overview

### 1. **Terraform Validate & Format** (`terraform-validate.yml`)
**Triggers:** On push and pull requests to `main` branch when `.tf` files change

**What it does:**
- ✓ Validates Terraform syntax
- ✓ Checks code formatting (terraform fmt)
- ✓ Runs TFLint for best practices
- ✓ Scans for hardcoded secrets

**Status:** Runs automatically on every commit
**Required:** No secrets needed for this workflow

---

### 2. **Terraform Plan & Cost Check** (`terraform-plan.yml`)
**Triggers:** On pull requests to `main` branch when `.tf` files change

**What it does:**
- ✓ Plans infrastructure changes
- ✓ Posts plan summary to PR comments
- ✓ Estimates cost impact (optional, with Infracost)
- ✓ Uploads plan file for review

**Status:** Runs automatically on PR
**Required Secrets:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `INFRACOST_API_KEY` (optional)

---

### 3. **Terraform Apply** (`terraform-apply.yml`)
**Triggers:** Manual trigger via "Run workflow" button in GitHub Actions tab

**What it does:**
- ✓ Applies approved Terraform changes
- ✓ Requires manual approval (workflow_dispatch)
- ✓ Captures and saves Terraform outputs
- ✓ Sends Slack notifications (optional)

**Status:** Manual trigger only (safer for production)
**Required Secrets:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `SLACK_WEBHOOK_URL` (optional)

---

## Required GitHub Secrets Setup

### Step 1: Generate AWS Credentials

1. Go to AWS IAM Console: https://console.aws.amazon.com/iam/
2. Create a new IAM user for CI/CD:
   - User name: `github-actions-ci`
   - Grant programmatic access
3. Attach policy: `AdministratorAccess` (or more restrictive based on your needs)
4. Save the Access Key ID and Secret Access Key

### Step 2: Add Secrets to GitHub Repository

1. Go to your GitHub repository: `https://github.com/arthuar99/aws-my-blog`
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secrets:

#### Required Secrets

| Secret Name | Value | Source |
|---|---|---|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key | AWS IAM Console |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key | AWS IAM Console |

#### Optional Secrets

| Secret Name | Value | Source |
|---|---|---|
| `INFRACOST_API_KEY` | Infracost API key | https://www.infracost.io/ (free tier available) |
| `SLACK_WEBHOOK_URL` | Slack webhook URL | Slack Workspace Settings → Apps & Integrations |

### Step 3: Create Slack Webhook (Optional)

To enable Slack notifications:

1. Go to your Slack Workspace
2. Navigate to **Settings** → **Features** → **Custom Integrations** → **Incoming WebHooks**
3. Create a new webhook
4. Copy the webhook URL
5. Add it as `SLACK_WEBHOOK_URL` secret in GitHub

---

## Workflow Configuration

### Branch Protection Rules (Recommended)

1. Go to **Settings** → **Branches** → **Add rule**
2. Branch name pattern: `main`
3. Enable:
   - ✓ Require a pull request before merging
   - ✓ Require status checks to pass
   - ✓ Dismiss stale pull request approvals when new commits are pushed
   - ✓ Require branches to be up to date before merging

This ensures all workflows pass before code is merged to `main`.

### Environment Protection (For Apply Workflow)

1. Go to **Settings** → **Environments**
2. Create environments: `production` and `staging`
3. Set **Required reviewers** for each environment
4. Add your team members as reviewers

This prevents accidental deployments without approval.

---

## How to Use

### For Development (Push to Feature Branch)

```bash
git checkout -b feature/my-changes
# Make your Terraform changes
git add .
git commit -m "Add new S3 bucket"
git push origin feature/my-changes
```

**Automatic checks:**
- Terraform format validation
- Syntax validation
- Secret scanning

### For Review (Open Pull Request)

```bash
# On GitHub: Create Pull Request from feature branch to main
```

**Automatic checks:**
- All validate workflow checks
- Terraform plan preview
- Cost impact estimation

### For Production (Merge & Deploy)

1. Get PR approved by team member
2. Merge PR to `main`
3. Go to **Actions** → **Terraform Apply (Manual)**
4. Click **Run workflow**
5. Select environment: `production` or `staging`
6. Confirm and deploy

---

## Monitoring & Logs

### View Workflow Status

1. Go to **Actions** tab in your GitHub repository
2. Click on a workflow run to see details
3. Each step shows logs and output

### Common Issues & Troubleshooting

#### Secret not found error
```
Error: Secret AWS_ACCESS_KEY_ID not found
```
**Solution:** Add the secret in Settings → Secrets and variables → Actions

#### Terraform state lock
```
Error: Error acquiring the lock
```
**Solution:** Check if another run is in progress, or force unlock:
```bash
terraform force-unlock LOCK_ID
```

#### AWS credentials expired
```
Error: InvalidClientTokenId
```
**Solution:** Regenerate AWS credentials and update GitHub secrets

#### Slack notification fails
```
Error: Incoming webhook not found
```
**Solution:** Verify webhook URL is correct in `SLACK_WEBHOOK_URL` secret

---

## Best Practices

### 1. **Always Use Pull Requests**
- Never push directly to `main`
- All changes go through PR review first
- Enables plan preview before apply

### 2. **Review Terraform Plan**
- Always review the PR comment with `terraform plan` output
- Ensure changes match your expectations
- Watch for resource deletions

### 3. **Separate Environments**
- Use GitHub Environments for `production` and `staging`
- Require reviewers for production deployments
- Test in staging before production apply

### 4. **Secure Secrets**
- Use IAM roles with minimal permissions (not full admin)
- Rotate AWS credentials regularly
- Never commit `.tfvars` files with secrets

### 5. **Monitor Costs**
- Review cost estimates in PR comments (if using Infracost)
- Set up AWS Budget alerts
- Monitor monthly bills in AWS Console

---

## Customization

### Change AWS Region
Edit `.github/workflows/*.yml` and update:
```yaml
env:
  AWS_REGION: us-west-2  # Change to your region
```

### Change Terraform Version
Edit `.github/workflows/*.yml` and update:
```yaml
terraform_version: 1.7.0  # Change to desired version
```

### Add Additional Checks
Add new steps in `terraform-validate.yml`:
```yaml
- name: Custom Security Check
  run: |
    # Your custom checks here
    ./scripts/security-check.sh
```

---

## Useful Commands

### Manually Validate Locally (Before Push)

```bash
# Initialize Terraform
terraform init -backend=false

# Validate syntax
terraform validate

# Check formatting
terraform fmt -check -recursive

# Run plan
terraform plan -no-color
```

### Troubleshoot Workflow Locally

```bash
# Download GitHub Actions locally (optional)
# https://github.com/nektos/act

act push  # Simulate push event
act pull_request  # Simulate PR event
```

---

## Support & Debugging

For detailed logs:
1. Go to **Actions** → Click failed workflow
2. Expand the failed step
3. Check output and error messages
4. Review GitHub Actions documentation: https://docs.github.com/en/actions

---

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Infracost Documentation](https://www.infracost.io/docs/)
- [Slack Webhooks](https://api.slack.com/messaging/webhooks)

---

**Last Updated:** November 11, 2025
