variable vpc_cidr {
  type = string
  default = "10.0.0.0/16"
}

variable pub_sub_cidr_block {
  type = string
  default = "10.0.0.0/24"
}

variable prv_sub_cidr_block {
  type = string
  default = "10.0.1.0/24"
}
