provider "aws" {
  region  = "us-east-1"
  version = "~> 1.60.0"
}

# -------------
#  Web server EC2
# -------------
resource "aws_instance" "web" {
  count = 1
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"

  user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p 8080 &
        EOF

  tags = {
    Name = "airflow"
  }
}
