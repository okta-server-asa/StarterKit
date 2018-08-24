output "public_subnet_ids" {
  value = [
    "${module.public_subnet.subnet_ids}",
  ]
}

output "vpc_id" {
  value = "${module.vpc_main.vpc_id}"
}
