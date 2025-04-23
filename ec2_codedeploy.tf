resource "aws_iam_role" "codedeploy_ec2_role" {
  name = "CodeDeployEC2ServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "codedeploy_profile" {
  name = "codedeploy-ec2-instance-profile"
  role = aws_iam_role.codedeploy_ec2_role.name
}

resource "aws_instance" "codedeploy_instance" {
  ami                    = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 in ap-south-1 (verify latest)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.codedeploy_profile.name
  key_name               = var.key_pair_name
  tags                   = merge(var.tags, { Name = "codedeploy-instance" })

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y ruby wget python3-pip
              pip3 install flask
              cd /home/ubuntu
              cat <<EOF2 > app.py
              from flask import Flask
              app = Flask(__name__)

              @app.route('/')
              def hello():
                  return "Hello from CodeDeploy EC2 Instance!"

              if __name__ == "__main__":
                  app.run(host='0.0.0.0', port=80)
              EOF2

              nohup python3 /home/ubuntu/app.py &
              
              wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              systemctl enable codedeploy-agent
              systemctl start codedeploy-agent
              EOF
}
