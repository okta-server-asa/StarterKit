data "template_file" "sftd-centos-userdata" {
  template = "${file("${path.module}/userdata-scripts/centos-userdata-sftd.sh")}"

  vars = {
    sftd_version     = "${var.sftd_version}"
    enrollment_token = "${var.enrollment_token}"
  }
}
