# VPC public

Creates a 3 zoned public VPC


Sample:

```hcl-terraform
module "vpc_public" {
  source = "github.com/roioteromorales/tf-modules.git//modules/vpc_public"
  name = "roisoftstudio"
  cidr = "172.10.0.0/20"
  region = "eu-west-2"
}
```