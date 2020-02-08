# VPC settings

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "pub_subnet_1_cidr" {
  description = "CIDR for public subnet 1"
  default     = "10.0.1.0/24"
}

variable "pub_subnet_2_cidr" {
  description = "CIDR for public subnet 2"
  default     = "10.0.2.0/24"
}

variable "priv_subnet_1_cidr" {
  description = "CIDR for private subnet 1"
  default     = "10.0.10.0/24"
}

variable "priv_subnet_2_cidr" {
  description = "CIDR for private subnet 2"
  default     = "10.0.11.0/24"
}

variable "enable_dns_hostnames" {
  description = "Enable dns hostnames"
  default     = true
}

