variable vpc_cidr {
  type = string
  default = "10.0.0.0/16"
}

variable az_1 {
  type = string
  default = "us-east-1a"
}

variable pub_sub_cidr_block_1 {
  type = string
  default = "10.0.0.0/24"
}

variable prv_sub_cidr_block_1 {
  type = string
  default = "10.0.1.0/24"
}

variable az_2 {
  type = string
  default = "us-east-1b"
}

variable pub_sub_cidr_block_2 {
  type = string
  default = "10.0.2.0/24"
}

variable prv_sub_cidr_block_2 {
  type = string
  default = "10.0.3.0/24"
}
