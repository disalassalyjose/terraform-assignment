variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-2"
}
 variable "private_key_path" {
   default = "awskeypair"
 }
 variable "instanc_type" {
   type    = "string"
   default = "t2.micro"
 }

 #variable "instance_count" {
#    default = "2"
# }
  variable "ami_id" {
  type = "map"
  default = {
    us-east-1 = "ami-0f7919c33c90f5b58"
    us-west-2 = "ami-0f7919c33c90f5b58"

    us-east-2 = "ami-0f7919c33c90f5b58"
    nat = "ami-044ff7657da2e9f07"
  }
}

 variable "db_privateip" {
 default = "10.0.2.100"
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "Vpc-Terraform"
}
