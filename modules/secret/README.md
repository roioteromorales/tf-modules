## Usage

```hcl-terraform
module "my_secret" {
  source = "github.com/roioteromorales/tf-modules.git//modules/secret"
  name = "${var.name}"
}
```
