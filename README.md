# Terraform Single Page Apps

This is the terraform needed to deploy a cloudfront backed s3 website.

**This Terraform will create a certificate and validate it which can take some time, please be aware that the first time this is run it can take 30+ minutes for validation to occur.**

### Usage

```terraform
# .tfvars (or however you name your variable file)

# this is the name that is on your route53 hosted zone
route53_zone = ""

# this is the name that you want to deploy to, by splitting them out you can deploy to subdomains specifically.
domain_name = ""
```

```shell
terraform init
terraform plan
terraform apply --auto-approve -var-file=<your_var_file>
```

### Continuous Deployments

```shell
aws s3 sync <website assets> s3://<domain_name>
```

```shell
aws cloudfront create-invalidation --distribution-id <distribution_id> --paths '/*'
```

