data "template_file" "sftd-windows-custom-data" {
  template = "${file("${path.module}/custom-data/windows-custom-data-sftd.ps1")}"

  vars {
    sftd_version     = "${var.sftd_version}"
    enrollment_token = "${var.enrollment_token}"
    public_ip        = "${var.public_ip}"
  }
}
