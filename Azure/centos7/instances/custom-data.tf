data "template_file" "sftd-centos-custom-data" {
  template = "${file("${path.module}/custom-data/centos-custom-data-sftd.sh")}"

  vars {
    sftd_version     = "${var.sftd_version}"
    enrollment_token = "${var.enrollment_token}"
    public_ip        = "${var.public_ip}"
  }
}
