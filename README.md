# AWS S3 Terraform Configuration for HCP Terraform

This repository contains Terraform configuration files to deploy an AWS S3 bucket using HCP Terraform (Terraform Cloud).

## Architecture

This configuration creates:
- S3 bucket with security best practices
- Bucket versioning enabled
- Server-side encryption (AES256)
- Public access blocked by default
- Optional website hosting configuration
- Optional CORS configuration  
- Optional lifecycle policies

## File Structure

```
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example variables file
└── README.md                  # This file
```

## Prerequisites

1. **HCP Terraform Account**: Sign up at [app.terraform.io](https://app.terraform.io)
2. **AWS Account**: With appropriate S3 permissions
3. **Terraform CLI**: Installed locally for development

## Quick Start

### 1. Set Up HCP Terraform Workspace

1. Log in to HCP Terraform
2. Create a new organization (if needed)
3. Create a new workspace:
   - Name: `aws-s3-production`
   - Choose workflow type (VCS or API-driven)

### 2. Configure AWS Credentials

In your HCP Terraform workspace, add these **Environment Variables** (mark as sensitive):

```
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_DEFAULT_REGION=us-east-1
```

### 3. Configure Terraform Variables

In your HCP Terraform workspace, add these **Terraform Variables**:

```hcl
tfc_organization = "your-organization-name"
tfc_workspace = "aws-s3-production"
bucket_name = "your-unique-bucket-name-2024"
environment = "prod"
enable_website_hosting = false
enable_cors = true
enable_lifecycle = true
```

### 4. Deploy

**Option A: Via HCP Terraform UI**
1. Connect your VCS repository
2. Trigger plan/apply from the UI

**Option B: Via Terraform CLI**
```bash
# Login to HCP Terraform
terraform login

# Initialize and deploy
terraform init
terraform validate
terraform plan
terraform apply
```

## Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `tfc_organization` | HCP Terraform organization name | string | `"your-organization-name"` |
| `tfc_workspace` | HCP Terraform workspace name | string | `"aws-s3-workspace"` |
| `aws_region` | AWS region | string | `"us-east-1"` |
| `bucket_name` | S3 bucket name (globally unique) | string | `"my-unique-bucket-name-12345"` |
| `environment` | Environment tag | string | `"dev"` |
| `enable_website_hosting` | Enable static website hosting | bool | `false` |
| `enable_cors` | Enable CORS configuration | bool | `false` |
| `enable_lifecycle` | Enable lifecycle policies | bool | `true` |
| `lifecycle_noncurrent_version_expiration_days` | Days to keep old versions | number | `90` |
| `lifecycle_abort_incomplete_multipart_upload_days` | Days before aborting incomplete uploads | number | `7` |

## Outputs

| Output | Description |
|--------|-------------|
| `bucket_id` | S3 bucket ID |
| `bucket_name` | S3 bucket name |
| `bucket_arn` | S3 bucket ARN |
| `bucket_domain_name` | S3 bucket domain name |
| `bucket_regional_domain_name` | S3 bucket regional domain name |
| `bucket_hosted_zone_id` | Route 53 hosted zone ID |
| `bucket_region` | AWS region of the bucket |
| `website_endpoint` | Website endpoint (if hosting enabled) |
| `website_domain` | Website domain (if hosting enabled) |

## Security Features

- **Encryption**: AES256 server-side encryption enabled by default
- **Public Access**: All public access blocked by default
- **Versioning**: Enabled to protect against accidental deletions
- **Lifecycle**: Automatic cleanup of old versions and incomplete uploads
- **IAM**: Follows principle of least privilege

## Cost Optimization

- Lifecycle policies automatically delete old versions after 90 days
- Incomplete multipart uploads are cleaned up after 7 days
- Configurable retention periods via variables

## Environment Management

Create separate workspaces for different environments:

```
aws-s3-development
aws-s3-staging  
aws-s3-production
```

Each with environment-specific variable values.

## Troubleshooting

### Common Issues

**Authentication Failed**
- Verify AWS credentials are set as environment variables in HCP Terraform workspace
- Ensure credentials have S3 permissions

**Bucket Name Already Exists**
- S3 bucket names must be globally unique
- Change the `bucket_name` variable value

**Terraform Cloud Organization Not Found**
- Verify organization name matches exactly in HCP Terraform
- Check workspace name is correct

**Permission Denied**
- Ensure AWS IAM user/role has necessary S3 permissions:
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketEncryption",
          "s3:PutBucketEncryption",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:DeleteBucketWebsite",
          "s3:GetBucketCors",
          "s3:PutBucketCors",
          "s3:DeleteBucketCors",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:DeleteLifecycleConfiguration"
        ],
        "Resource": "*"
      }
    ]
  }
  ```

## Best Practices

1. **Naming**: Use consistent naming conventions for buckets
2. **Tagging**: Apply consistent tags across all resources
3. **Security**: Never commit AWS credentials to version control
4. **State**: Let HCP Terraform manage state remotely
5. **Planning**: Always review plans before applying
6. **Environments**: Use separate workspaces per environment

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes and test
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in this repository
- Check HCP Terraform documentation
- Review AWS S3 documentation