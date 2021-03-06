# Fargate Service

Creates a fargate task service


Sample:

```hcl-terraform
module "fargate_service" {
  source = "github.com/roioteromorales/tf-modules.git//modules/fargate_service"
  service_name = var.service_name
  region = var.region
  repository = var.repository
  cluster_id = module.context.cluster_id
  vpc_id = module.context.vpc_id
  assign_public_ip = true
  subnets = module.context.public_subnets
  ecs_execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  lb_arn = module.context.lb_arn
  lb_path = "/"
}
```


### Properties

#### ecs_execution_role_arn

Default role for task execution

```hcl-terraform
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
```
