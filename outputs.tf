output vpc {
  value = aws_vpc.main
}

output public_subnet {
  value = aws_subnet.pub_sub
}

output private_subnet {
  value = aws_subnet.prv_sub
}
