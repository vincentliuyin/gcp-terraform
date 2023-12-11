data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-vincent-demo"
    prefix = "network/state/${terraform.workspace}"
  }
}

data "terraform_remote_state" "storage" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-vincent-demo"
    prefix = "storage/state/${terraform.workspace}"
  }
}

data "terraform_remote_state" "security" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-vincent-demo"
    prefix = "security/state/${terraform.workspace}"
  }
}

# VM Instance
resource "google_compute_instance" "vm_instance" {
  name         = "vincent-demo-vm-${terraform.workspace}"
  machine_type = "f1-micro"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = data.terraform_remote_state.network.outputs.vpc_id
    subnetwork = data.terraform_remote_state.network.outputs.subnet_ids[0]

    access_config {

    }
  }

metadata = {
  ssh-keys = "${var.ssh_username}:${file(var.public_ssh_key_path)}"
  "startup-script" = <<EOF
    #!/bin/bash
    apt update
    apt install -y python3 python3-pip
    pip3 install Flask requests

    cat <<EOPY > /home/vincent/app.py
    from flask import Flask
    import socket
    import os
    import requests

    app = Flask(__name__)

    @app.route('/')
    def hello():
        hostname = socket.gethostname()
        storage_link = os.getenv('STORAGE_LINK')
        web_content = "Storage content has problem"

        if storage_link:
            try:
                response = requests.get(storage_link)
                if response.status_code == 200:
                    web_content = f"<p>{response.text}</p><p>(Content fetched from cloud storage)</p>"
                else:
                    web_content += " (unable to fetch)"
            except Exception as e:
                web_content += f" (Error: {e})"

        return f"<!DOCTYPE html><html><body><h1>Flask App on: {hostname}</h1>{web_content}</body></html>"

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=8080)
    EOPY

    export STORAGE_LINK=${data.terraform_remote_state.storage.outputs.uploaded_file_url}
    nohup python3 /home/vincent/app.py &
  EOF
}


#   tags = [data.terraform_remote_state.security.outputs.firewall_target_tag]
  tags = ["web"]
}



