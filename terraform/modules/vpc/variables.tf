#VPC Variables

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "public_subnet" {
  description = "The CIDR block for the public subnet"
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = []
}

variable "private_subnet" {
  description = "The CIDR block for the private subnet"
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = []
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = false

  validation {
    condition     = !var.create_nat_gateway || length(var.public_subnet) > 0
    error_message = "At least one public subnet is required when create_nat_gateway is true."
  }
}