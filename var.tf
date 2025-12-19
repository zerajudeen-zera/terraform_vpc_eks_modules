variable "name_vpc_tag" {
    description = "name of vpc"
    default = "my_private_vpc"
  
}
variable "vpc_cidr_block" {
    description = "cidr_block_vpc"
    default = "10.0.0.0/16"
  
}
variable "azs" {
    description = "az"
    default = ["us-east-1a", "us-east-1b"]
    type = list(string)
  
}
variable "public_subnet_cidrs" {
    description = "cidr pubsub"
    type = list(string)

  
}
variable "private_subnet_cidrs" {
    description = "cidr private subnet"
    type = list(string)

}
variable "ig-name" {
    description = "ig name"
    type = string
  
}
