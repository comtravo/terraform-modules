variable "region" {
  type        = string
  description = "AWS_REGION to emit cloudwatch event for updating launch configuration"
}

variable "launch_template_event_emitter_role" {
  description = "IAM role to assume while emitting launch template changes"
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "cluster" {
  description = "The name of the cluster"
  type        = string
}

variable "cluster_attributes" {
  description = "The ECS atributes for the cluster"
  default     = {}
  type        = map(string)
}

variable "cluster_uid" {
  description = "The name of the cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "aws_ami" {
  description = "The AWS ami id to use"
  type        = string
}

variable "max_size" {
  default     = 1
  description = "Maximum size of the nodes in the cluster"
  type        = number
}

variable "min_size" {
  default     = 10
  description = "Minimum size of the nodes in the cluster"
  type        = number
}

variable "desired_capacity" {
  default     = 1
  description = "The desired capacity of the cluster"
  type        = number
}

variable "iam_instance_profile_id" {
  description = "The id of the instance profile that should be used for the instances"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnets to place the instances in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "The list of security groups to place the instances in"
}

variable "depends_id" {
  type        = string
  description = "Inter module dependency hack"
}

variable "key_name" {
  description = "SSH key name to be used"
  type        = string
}

variable "ecs_logging" {
  default     = ["json-file", "awslogs", "gelf", "syslog"]
  description = "Adding logging option to ECS."
  type        = list(string)
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
  type        = string
}

# Revisit later
#
# Threshold for scale-out should be at most:
#     (maximum memory | memoryReservation of a container)
# 1 - ---------------------------------------------------------  * 100
#          Maximum memory units of a particular instance
#
# Does not hold good if no solid block of memory is available
# But hopefully, it will change with ordered placement strategies in Terraform by using binpack
# if the headroom of the instance is not enough to hold the largest container
variable "scale_out" {
  default = {
    type               = "MemoryReservation"
    threshold          = 65
    cooldown           = 300
    adjustment         = 1
    evaluation_periods = 2
  }

  type        = map(string)
  description = "Scale out type. Defaults to MemoryReservation and threshold of 65%"
}

variable "fleet_config" {
  type = map(string)
}

variable "ebs_root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
}

variable "instance_override" {
  type = list(object({
    instance_type     = string
    weighted_capacity = number
  }))
}

