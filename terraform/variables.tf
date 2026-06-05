variable "aws_region" {
  description = "Sao Paulo"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "t3.micro free-tier (1 vCPU, 1 GB RAM)."
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "EC2 key pair for SSH access."
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR notation"
  type        = string
}
