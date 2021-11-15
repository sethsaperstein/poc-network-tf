output vpc {
  value = aws_vpc.main
}

output public_subnet_1 {
  value = module.subnets_1.pub_sub
}

output private_subnet_1 {
  value = module.subnets_1.prv_sub
}

output public_subnet_2 {
  value = module.subnets_2.pub_sub
}

output private_subnet_2 {
  value = module.subnets_2.prv_sub
}
