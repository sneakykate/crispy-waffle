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

resource "aws_s3_bucket" "crispy_waffle_bucket" {
  bucket = "crispy-waffle-bucket-1"
  acl = "private"
  # for testing only so we can destroy later -- don't do in prod
  # terraform by default won't destroy a bucket with stuff in it.
  force_destroy = true
  versioning {
    # good idea to enable
    enabled = true
  }
  tags = {
    Name = "bucket_of_waffles"
  }
}

