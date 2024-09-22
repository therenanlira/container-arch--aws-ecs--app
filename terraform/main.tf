module "service" {
  source = "../../container-arch--aws-ecs--module/"
  region = var.region

  cluster_name         = var.cluster_name
  service_name         = var.service_name
  service_port         = var.service_port
  service_cpu          = var.service_cpu
  service_memory       = var.service_memory
  service_listener_arn = data.aws_ssm_parameter.listener_arn.value
  service_healthcheck  = var.service_healthcheck
  service_launch_type  = var.service_launch_type
  service_task_count   = var.service_task_count
  service_hosts        = var.service_hosts

  service_task_execution_role_arn = aws_iam_role.service_task_execution_role.arn

  vpc_id = data.aws_ssm_parameter.vpc_id.value

  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1a.value,
    data.aws_ssm_parameter.private_subnet_1b.value,
    data.aws_ssm_parameter.private_subnet_1c.value
  ]

  environment_variables = var.environment_variables
  capabilities          = var.capabilities

  scale_type   = var.scale_type
  task_minimum = var.task_minimum
  task_maximum = var.task_maximum

  scale_out_cpu_threshold       = var.scale_out_cpu_threshold
  scale_out_adjustment          = var.scale_out_adjustment
  scale_out_comparison_operator = var.scale_out_comparison_operator
  scale_out_statistic           = var.scale_out_statistic
  scale_out_period              = var.scale_out_period
  scale_out_evaluation_periods  = var.scale_out_evaluation_periods
  scale_out_cooldown            = var.scale_out_cooldown
}
