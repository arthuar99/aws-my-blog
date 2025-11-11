# GitHub Secrets Setup Guide

This guide walks you through setting up the required secrets for CI/CD workflows to function properly.

## Quick Start

1. [Generate AWS IAM Credentials](#step-1-generate-aws-credentials)
2. [Add Secrets to GitHub](#step-2-add-secrets-to-github)
3. [Verify Workflows](#step-3-verify-workflows)

---

## Step 1: Generate AWS Credentials

### Option A: Using AWS Management Console (Recommended for Beginners)

1. **Sign in to AWS Console**
   - Go to https://console.aws.amazon.com/
   - Sign in with your AWS account

2. **Navigate to IAM**
   - Search for "IAM" in the search bar
   - Click "Identity and Access Management"

3. **Create New IAM User**
   - Left sidebar → **Users**
   - Click **Create user**
   - User name: `github-actions-ci`
   - Click **Next**

4. **Set Permissions**
   - Select **Attach policies directly**
   - Search for and select: `AdministratorAccess`
   - Click **Next** → **Create user**

5. **Generate Access Keys**
   - Click on the newly created user `github-actions-ci`
   - Go to **Security credentials** tab
   - Scroll to **Access keys**
   - Click **Create access key**
   - Select **Command Line Interface (CLI)**
   - Acknowledge the warning
   - Click **Create access key**
   - **IMPORTANT:** Copy and save these keys immediately:
     - Access Key ID: `AKIA...`
     - Secret Access Key: `wJalr...`

> ⚠️ **Warning:** Secret Access Key is only shown once. Save it securely!

---

## Step 2: Add Secrets to GitHub

### Add AWS Credentials

1. **Go to GitHub Repository Settings**
   - Navigate to: https://github.com/arthuar99/aws-my-blog/settings
   - Or: Repository → Settings → Secrets and variables → Actions

2. **Add AWS_ACCESS_KEY_ID**
   - Click **New repository secret**
   - Name: `AWS_ACCESS_KEY_ID`
   - Value: Paste your Access Key ID (from Step 1)
   - Click **Add secret**

3. **Add AWS_SECRET_ACCESS_KEY**
   - Click **New repository secret**
   - Name: `AWS_SECRET_ACCESS_KEY`
   - Value: Paste your Secret Access Key (from Step 1)
   - Click **Add secret**

### Verify Secrets Are Added

```
✓ AWS_ACCESS_KEY_ID
✓ AWS_SECRET_ACCESS_KEY
```

You should see both in your Secrets list now.

---

## Step 3: (Optional) Add Infracost for Cost Estimation

### Get Free Infracost API Key

1. **Sign Up for Infracost**
   - Go to https://www.infracost.io/
   - Click **Get free API key**
   - Sign up with GitHub (or email)
   - Verify your email

2. **Get Your API Key**
   - After login, you'll see your API key
   - Copy it

3. **Add to GitHub Secrets**
   - Go to GitHub → Settings → Secrets and variables → Actions
   - Click **New repository secret**
   - Name: `INFRACOST_API_KEY`
   - Value: Paste your API key
   - Click **Add secret**

---

## Step 4: (Optional) Add Slack Notifications

### Create Slack Incoming Webhook

1. **Go to Slack Workspace Settings**
   - Open your Slack workspace
   - Click your workspace name → **Settings & administration** → **Manage apps**

2. **Search for Incoming WebHooks**
   - Search for "Incoming WebHooks"
   - Click it, then **Install** (or **Reinstall**)

3. **Create New Webhook**
   - Click **Add New Webhook to Workspace**
   - Select the channel where notifications should go (e.g., #deployments)
   - Click **Allow**

4. **Copy Webhook URL**
   - You'll see your Webhook URL: `https://hooks.slack.com/services/T.../B.../...`
   - Copy it

5. **Add to GitHub Secrets**
   - Go to GitHub → Settings → Secrets and variables → Actions
   - Click **New repository secret**
   - Name: `SLACK_WEBHOOK_URL`
   - Value: Paste your webhook URL
   - Click **Add secret**

---

## Step 5: Verify Everything Works

### Test the Validate Workflow

1. **Make a test change**
   ```bash
   git checkout -b test-ci
   # Make a small change to a .tf file
   git add .
   git commit -m "Test CI workflow"
   git push origin test-ci
   ```

2. **Open a Pull Request**
   - Go to GitHub repository
   - Create PR from `test-ci` → `main`

3. **Watch Workflows Run**
   - Go to **Actions** tab
   - You should see "Terraform Validate & Format" running
   - It should complete in 2-3 minutes with ✓ checkmarks

4. **Check Plan on PR**
   - Go back to your PR
   - Scroll down to see:
     - Workflow status ✓
     - Terraform plan output (if AWS secrets added)

---

## Troubleshooting

### Secret Not Found Error

```
Error: Secret AWS_ACCESS_KEY_ID not found
```

**Solution:**
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Verify the secret exists
3. Check the exact name matches (case-sensitive)

### AWS Credentials Invalid

```
Error: InvalidClientTokenId
```

**Solution:**
1. Verify the Access Key ID is correct in GitHub secret
2. Verify the Secret Access Key is correct in GitHub secret
3. Check the IAM user exists in AWS Console
4. Regenerate credentials if needed

### Workflows Not Running

```
No workflows found
```

**Solution:**
1. Check `.github/workflows/` directory exists
2. Verify YAML files have correct syntax
3. Check repository has `.github` folder committed to git
   ```bash
   git status
   git add .github/
   git commit -m "Add CI/CD workflows"
   git push
   ```

### Terraform State Lock Error

```
Error: Error acquiring the lock
```

**Solution:**
1. Check if another workflow is running
2. Wait for it to complete, then retry
3. Or manually force unlock:
   ```bash
   aws dynamodb delete-item \
     --table-name terraform-locks \
     --key '{"LockID": {"S": "YOUR_LOCK_ID"}}'
   ```

---

## Security Best Practices

### ✓ DO:
- ✓ Rotate AWS credentials every 90 days
- ✓ Use IAM roles with minimal permissions
- ✓ Enable MFA on your AWS root account
- ✓ Review GitHub Actions logs for sensitive data
- ✓ Use separate AWS accounts for dev/staging/prod

### ✗ DON'T:
- ✗ Never commit `.tfvars` files with secrets
- ✗ Never share AWS credentials in chat
- ✗ Never use root account credentials for CI/CD
- ✗ Never hardcode secrets in `.tf` files
- ✗ Never add secrets in repository code

---

## Next Steps

After secrets are configured:

1. **Test a deployment**
   ```bash
   git checkout -b feature/test
   # Make a small Terraform change
   git push origin feature/test
   # Open PR and review plan
   ```

2. **Set up branch protection**
   - Settings → Branches → Add rule
   - Require status checks before merge

3. **Configure environments** (optional but recommended)
   - Settings → Environments
   - Create `production` and `staging`
   - Set required reviewers

4. **Monitor deployments**
   - Go to **Actions** tab after each merge
   - Review logs and outputs

---

## Questions or Issues?

- Check workflow logs: Repository → **Actions** → Click workflow run → Expand failed step
- Review error messages for specific guidance
- Consult GitHub Actions docs: https://docs.github.com/en/actions
- Check Terraform docs: https://www.terraform.io/docs

---

**Last Updated:** November 11, 2025
