output "public_ip" {
  value = "${aws_instance.sft-windows.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.sft-windows.private_ip}"
}

output "id" {
  value = "${aws_instance.sft-windows.id}"
}
