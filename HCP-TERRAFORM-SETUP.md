# HCP Terraform Setup Guide

Complete step-by-step guide to deploy AWS S3 using HCP Terraform.

## Step 1: Create HCP Terraform Account

1. Go to [app.terraform.io](https://app.terraform.io)
2. Sign up for a free account
3. Create a new organization or join existing one

## Step 2: Create Workspace

1. Click **"New workspace"**
2. Choose workflow type:
   - **VCS-driven**: Connect to GitHub/GitLab repo (recommended)
   - **API-driven**: For CI/CD pipelines
   - **CLI-driven**: For local development

3. Configure workspace:
   - **Name**: `aws-s3-production`
   - **Description**: AWS S3 bucket deployment
   - **Working directory**: Leave empty (root)

## Step 3: Configure Environment Variables

In your workspace, go to **Variables** tab and add:

### Environment Variables (Sensitive)
| Key | Value | Description |
|-----|-------|-------------|
| `AWS_ACCESS_KEY_ID` | `your-access-key` | AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | `your-secret-key` | AWS Secret Access Key |
| `AWS_DEFAULT_REGION` | `us-east-1` | Default AWS region |

**Important**: Mark AWS credentials as **Sensitive**

## Step 4: Configure Terraform Variables

Add these as **Terraform variables**:

| Key | Value | Description |
|-----|-------|-------------|
| `tfc_organization` | `your-org-name` | Your HCP Terraform organization |
| `tfc_workspace` | `aws-s3-production` | Workspace name |
| `bucket_name` | `company-prod-bucket-2024` | Unique S3 bucket name |
| `environment` | `prod` | Environment tag |
| `aws_region` | `us-east-1` | AWS region |
| `enable_website_hosting` | `false` | Enable website hosting |
| `enable_cors` | `true` | Enable CORS |
| `enable_lifecycle` | `true` | Enable lifecycle policies |

## Step 5: Workspace Settings

### General Settings
- **Execution Mode**: Remote (recommended)
- **Apply Method**: Manual apply (for production safety)
- **Auto Apply**: Disabled

### Notifications
Set up notifications for:
- Plan and apply events
- Errors and failures
- Slack/email integration

### Team Access
Configure team permissions:
- **Plan**: Team members can create plans
- **Write**: Can apply changes
- **Admin**: Full workspace access

## Step 6: Deploy via Different Methods

### Method A: VCS Integration (Recommended)

1. **Connect Repository**:
   - Go to workspace **Settings** > **Version Control**
   - Connect your GitHub/GitLab repository
   - Set branch to `main`

2. **Automatic Deployment**:
   - Push code changes to repository
   - HCP Terraform automatically triggers plan
   - Review plan and apply if approved

### Method B: CLI Deployment

1. **Install Terraform CLI**:
   ```bash
   # macOS
   brew install terraform
   
   # Windows
   choco install terraform
   
   # Linux
   wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
   ```

2. **Login to HCP Terraform**:
   ```bash
   terraform login
   ```

3. **Initialize and Deploy**:
   ```bash
   terraform init
   terraform validate
   terraform plan
   terraform apply
   ```

### Method C: API Integration

For CI/CD pipelines, use HCP Terraform API:

```bash
# Create configuration version
curl \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload.json \
  https://app.terraform.io/api/v2/workspaces/ws-WORKSPACE_ID/configuration-versions
```

## Step 7: Monitoring and Management

### State Management
- State is automatically managed by HCP Terraform
- State locking prevents concurrent modifications
- State history and rollback capabilities

### Plan History
- View all historical plans and applies
- Compare changes between runs
- Audit trail for compliance

### Cost Estimation
- Enable cost estimation in workspace settings
- View projected AWS costs before applying
- Set up cost alerts and budgets

## Step 8: Environment Strategy

### Multiple Environments
Create separate workspaces:

```
Development: aws-s3-dev
Staging:     aws-s3-staging  
Production:  aws-s3-prod
```

### Variable Management
Use workspace-specific variables:

**Development**:
```hcl
environment = "dev"
bucket_name = "company-dev-bucket-2024"
lifecycle_noncurrent_version_expiration_days = 7
```

**Production**:
```hcl
environment = "prod"
bucket_name = "company-prod-bucket-2024"
lifecycle_noncurrent_version_expiration_days = 90
```

## Step 9: Security Best Practices

### Workspace Security
- Enable workspace locking during sensitive operations
- Use workspace-level permissions
- Regular access review

### Variable Security
- Mark sensitive variables appropriately
- Use environment variables for secrets
- Never commit credentials to VCS

### State Security
- HCP Terraform encrypts state at rest
- Access controlled via workspace permissions
- Audit logs for state access

## Step 10: Troubleshooting

### Common Issues

**Invalid Credentials**:
```
Error: error configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found.
```
**Solution**: Verify AWS environment variables are set correctly in workspace

**Bucket Exists**:
```
Error: error creating S3 Bucket: BucketAlreadyExists: The requested bucket name is not available
```
**Solution**: Change `bucket_name` variable to a unique value

**Permission Denied**:
```
Error: error creating S3 Bucket: AccessDenied: Access Denied
```
**Solution**: Ensure AWS credentials have S3 permissions

**Organization Not Found**:
```
Error: organization "your-org" at hostname app.terraform.io not found
```
**Solution**: Verify organization name in terraform cloud block

### Debug Steps

1. **Check Workspace Logs**:
   - Go to workspace **Runs** tab
   - Click on failed run
   - Review plan/apply logs

2. **Validate Configuration**:
   ```bash
   terraform validate
   terraform fmt -check
   ```

3. **Test Credentials**:
   ```bash
   aws s3 ls  # Test AWS credentials locally
   ```

## Step 11: Next Steps

### Advanced Features
- **Policy as Code**: Implement Sentinel policies
- **Module Registry**: Use private module registry
- **Run Triggers**: Set up workspace dependencies
- **API Integration**: Integrate with CI/CD systems

### Monitoring
- Set up CloudWatch monitoring for S3
- Configure HCP Terraform notifications
- Implement cost monitoring and alerts

### Backup and DR
- Enable cross-region replication
- Set up backup strategies
- Document disaster recovery procedures

## Support Resources

- **HCP Terraform Documentation**: [terraform.io/cloud-docs](https://terraform.io/cloud-docs)
- **AWS Provider Documentation**: [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws)
- **Community Forum**: [discuss.hashicorp.com](https://discuss.hashicorp.com)
- **Support**: Enterprise customers can open support tickets