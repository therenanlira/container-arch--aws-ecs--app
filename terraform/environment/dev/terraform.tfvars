#### GENERAL CONFIGURATION ####

region = "us-east-1"

#### SSM VPC PARAMETERS ####

ssm_vpc_id           = "linuxtips-vpc-vpc-id"
ssm_private_subnet_1 = "linuxtips-vpc-private-subnet-1a"
ssm_private_subnet_2 = "linuxtips-vpc-private-subnet-1b"
ssm_private_subnet_3 = "linuxtips-vpc-private-subnet-1c"
ssm_listener_arn     = "linuxtips-ecscluster--load-balancer-http-listener-arn"

#### ECS TASK DEFINITION ####

cluster_name        = "linuxtips-ecscluster"
service_name        = "chip"
service_port        = 8080
service_cpu         = 128
service_memory      = 256
service_launch_type = "EC2"
service_task_count  = 2

environment_variables = [
  {
    name  = "foo"
    value = "bar"
  },
  {
    name  = "ping"
    value = "pong"
  }
]

capabilities = [
  "EC2"
]

service_healthcheck = {
  "healthy_threshold"   = 3
  "unhealthy_threshold" = 10
  "timeout"             = 10
  "interval"            = 60
  "matcher"             = "200-399"
  "path"                = "/healthcheck"
  "port"                = "8080"
}

service_hosts = [
  "chip.linuxtips.demo"
]

### ECS APP CONFIGURATION ###

scale_type   = "CPU"
task_minimum = 1
task_maximum = 3

scale_out_cpu_threshold       = 50
scale_out_adjustment          = 1
scale_out_comparison_operator = "GreaterThanOrEqualToThreshold"
scale_out_statistic           = "Average"
scale_out_period              = 60
scale_out_evaluation_periods  = 1
scale_out_cooldown            = 60