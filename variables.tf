# Required

variable "aws_vpc" {
  type        = string
  description = "AWS VPC"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_session_token" {
  type        = string
  description = "AWS session token used to create AWS infrastructure"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region used for rancher resources"
  default     = "eu-central-1"
}

variable "kube_version" {
  type        = string
  description = "Kubernetes RKE2 version for downstream clusters"
  default     = "v1.23.5+k3s1"
}

variable "rancher_kube_version" {
  type        = string
  description = "Kubernetes version for rancher cluster"
  default     = "v1.22.8+k3s1"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format v0.0.0)"
  default     = "v2.6.4"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.5.3"
}

variable "ssh_key_location" {
  type        = string
  description = "Location of ssh key needed for access"
  default     = "~/.ssh/id_rsa"
}

variable "kube_config_location" {
  type        = string
  description = "Location of ssh key needed for access"
  default     = "./kube_config_cluster.yml"
}
