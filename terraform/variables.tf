#### GENERAL CONFIGURATION ####

variable "region" {
  description = "The region where the resources will be created"
  type        = string
}

#### ECS APP CONFIGURATION ####

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "service_port" {
  description = "The port on which the service listens"
  type        = number
}

variable "service_cpu" {
  description = "The number of CPU units to reserve for the service"
  type        = number
}

variable "service_memory" {
  description = "The amount of memory to reserve for the service"
  type        = number
}

variable "service_healthcheck" {
  description = "The healthcheck for the service"
  type        = map(string)
}

variable "service_launch_type" {
  description = "The launch type for the service"
  type        = string
}

variable "service_task_count" {
  description = "The number of tasks to run"
  type        = number
}

variable "service_hosts" {
  description = "The hosts for the service"
  type        = list(string)
}

#### ECS TASK DEFINITION ####

variable "environment_variables" {
  description = "The environment variables for the task definition"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "capabilities" {
  description = "The capabilities for the task definition"
  type        = list(string)
}

#### SSM VPC PARAMETERS ####

variable "ssm_vpc_id" {
  description = "The SSM parameter name for the VPC ID"
  type        = string
}

variable "ssm_private_subnet_1" {
  description = "The SSM parameter name for the private subnet 1"
  type        = string
}

variable "ssm_private_subnet_2" {
  description = "The SSM parameter name for the private subnet 2"
  type        = string
}

variable "ssm_private_subnet_3" {
  description = "The SSM parameter name for the private subnet 3"
  type        = string
}

variable "ssm_listener_arn" {
  description = "The listener rule for the service"
  type        = string
}

variable "scale_type" {
  description = "The scale type for the task definition"
  type        = string
}

variable "task_minimum" {
  description = "The minimum number of tasks to run"
  type        = number
}

variable "task_maximum" {
  description = "The maximum number of tasks to run"
  type        = number
}