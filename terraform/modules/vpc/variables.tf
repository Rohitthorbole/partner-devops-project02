#VPC Variables

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "create_public_subnet" {
  description = "Whether to create a public subnet"
  type        = bool
  default     = false
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = object({
    cidr_block = string
    availability_zone = string
  })
  default = null
}

variable "create_private_subnet" {
  description = "Whether to create a private subnet"
  type        = bool
  default     = false
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = object({
    cidr_block = string
    availability_zone = string
  })
  default = null
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = false
}