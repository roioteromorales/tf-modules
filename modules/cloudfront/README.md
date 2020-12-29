# Cloudfront with versioned S3

Creates a Cloudfront with versioned S3

Example Usage:

```terraform
module "website" {
  source = "github.com/mulecode/terraform.git//module/cloudfront"
  name = "web"
  domain_name = "mulecode.co.uk"
}
```

This module uses a default root object under a folder in order to facilitate the visualisation of versioned items in S3

```terraform
  default_root_object = "static/index.html"
  error_response_page_path = "/static/index.html"
```

For angular distributions deploy-url must be set as `static/`, example:

```shell
ng build --prod --base-href / --deploy-url static/
```
