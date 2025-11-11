# CI/CD Quick Start Guide

Your project now has a complete CI/CD pipeline! Follow these steps to activate it.

## 📋 Prerequisites

- GitHub repository: `https://github.com/arthuar99/aws-my-blog`
- AWS account with permissions to create IAM users
- Access to your AWS Console

---

## 🚀 Setup in 5 Minutes

### 1. Create AWS IAM User for CI/CD

**Shortest path:**
```bash
# Or do this via AWS Console GUI (recommended for beginners):
# 1. Go to https://console.aws.amazon.com/iam/
# 2. Click "Users" → "Create user"
# 3. User name: github-actions-ci
# 4. Next → Attach "AdministratorAccess" policy
# 5. Create user
# 6. Go to "Security credentials" → "Create access key"
# 7. Choose "Command Line Interface (CLI)"
# 8. Create and COPY the Access Key ID and Secret Access Key
```

### 2. Add AWS Credentials to GitHub Secrets

1. Open: https://github.com/arthuar99/aws-my-blog/settings/secrets/actions
2. Click **New repository secret**
3. Add these two secrets:

| Name | Value |
|------|-------|
| `AWS_ACCESS_KEY_ID` | Your Access Key ID from step 1 |
| `AWS_SECRET_ACCESS_KEY` | Your Secret Access Key from step 1 |

### 3. Test It!

```bash
# Create a test branch
git checkout -b test-workflow

# Make a small change to any .tf file
echo "# Test comment" >> variables.tf

# Commit and push
git add .
git commit -m "Test: Trigger CI workflow"
git push origin test-workflow

# Create a Pull Request on GitHub
# You should see ✓ "Terraform Validate & Format" start running!
```

### 4. Watch Workflows Run

- Go to: **Actions** tab in your repository
- You'll see workflows running:
  - ✓ Terraform Validate & Format
  - ✓ TFLint (best practices)
  - ✓ Terraform Plan (if you have AWS secrets)

---

## 📊 Workflow Stages

### Stage 1: On Every Commit (Automatic)
```
✓ Terraform syntax validation
✓ Code format check
✓ Best practices scan (TFLint)
✓ Secret scanning
```

### Stage 2: On Pull Request (Automatic)
```
✓ All Stage 1 checks
✓ Terraform plan preview
✓ Cost estimation (if Infracost enabled)
✓ Plan posted to PR comments
```

### Stage 3: Manual Deployment
```
Go to Actions → "Terraform Apply (Manual)" → "Run workflow"
✓ Select environment (production/staging)
✓ Deploy infrastructure
✓ Slack notification (if configured)
```

---

## 📚 Available Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `terraform-validate.yml` | Push/PR on `.tf` files | Validate syntax, format, lint |
| `terraform-plan.yml` | PR on `.tf` files | Preview changes, estimate cost |
| `terraform-apply.yml` | Manual (workflow_dispatch) | Deploy to AWS |

---

## 🔐 Optional: Add Cost Estimation

To enable cost estimates in pull requests:

1. Get free API key: https://www.infracost.io/
2. Add GitHub secret `INFRACOST_API_KEY` with your key
3. Cost estimates will appear in PR comments

---

## 🔔 Optional: Add Slack Notifications

To get deployment notifications in Slack:

1. Create Slack Incoming Webhook:
   - Go to Slack workspace settings
   - Add Incoming WebHooks app
   - Create webhook for #deployments channel

2. Add GitHub secret `SLACK_WEBHOOK_URL` with webhook URL

3. Slack notifications will appear after each deployment

---

## 📖 Full Documentation

For detailed setup and troubleshooting:
- **CI/CD Pipeline Guide**: `.github/CICD.md`
- **Secrets Setup Guide**: `.github/SECRETS_SETUP.md`

---

## ✅ Checklist

- [ ] AWS IAM user created (`github-actions-ci`)
- [ ] AWS Access Key ID saved
- [ ] AWS Secret Access Key saved
- [ ] GitHub secret `AWS_ACCESS_KEY_ID` added
- [ ] GitHub secret `AWS_SECRET_ACCESS_KEY` added
- [ ] Test workflow created and ran successfully
- [ ] Reviewed workflow in Actions tab
- [ ] (Optional) Added Infracost API key
- [ ] (Optional) Added Slack webhook URL

---

## 🎯 Next Steps

1. **Test a real deployment:**
   ```bash
   git checkout -b feature/add-something
   # Make a meaningful Terraform change
   git push origin feature/add-something
   # Open PR and review plan output
   ```

2. **Set up branch protection:**
   - Settings → Branches → Add rule for `main`
   - Require status checks to pass
   - Require code review

3. **Configure environments:**
   - Settings → Environments
   - Create `production` and `staging`
   - Set required reviewers for production

4. **Monitor deployments:**
   - Actions tab shows all workflow runs
   - Click run to see detailed logs

---

## 🆘 Troubleshooting

### Workflows not showing?
```bash
# Make sure .github/workflows files are committed
git status
# If .github/ files not committed:
git add .github/
git commit -m "Add CI/CD workflows"
git push
```

### AWS credentials error?
- Check secret names match exactly (case-sensitive)
- Verify values are correct in GitHub secrets
- Try regenerating AWS credentials

### Plan not showing in PR?
- You need AWS secrets configured
- Workflow must complete successfully
- Check Actions tab for error details

---

## 📞 Support

- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **Terraform Docs**: https://www.terraform.io/docs
- **AWS CLI Reference**: https://docs.aws.amazon.com/cli/

---

**Status:** ✅ CI/CD Ready!

Your project now has:
- ✓ Automated validation on every commit
- ✓ Plan preview on every PR
- ✓ Cost estimation (optional)
- ✓ One-click deployment to AWS
- ✓ Slack notifications (optional)

**Time to deploy:** < 5 minutes! 🚀
