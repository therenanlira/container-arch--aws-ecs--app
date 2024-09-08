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
