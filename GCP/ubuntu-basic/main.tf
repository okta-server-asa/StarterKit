data "template_file" "init" {
  template = "${file("install.sh")}"
  vars {
    enrollment_token  = "${var.enrollment_token}"
    name              = "${var.name}"
  }
}

resource "google_compute_instance" "ubuntu-xenial" {
   name = "${var.name}"
   machine_type = "f1-micro"
   zone = "us-west1-a"

   boot_disk {
      initialize_params {
         image = "ubuntu-1604-lts"
      }
   }

   network_interface {
      network = "default"
      access_config {}
   }

   metadata_startup_script = "${data.template_file.init.rendered}"
}