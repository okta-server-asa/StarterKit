output "public_ip" {
  value = "${aws_instance.node[0].public_ip}"
}

output "private_ip" {
  value = "${aws_instance.node[0].private_ip}"
}

output "id" {
  value = "${aws_instance.node[0].id}"
}
