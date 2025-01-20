protocol = "tcp"
security_groups_ports = [22, 8080, 8081, 8082, 8069, 30012, 30010, 30011, 6443]
instance_type = "t2.medium"
username = "ubuntu"
region = "us-east-1"
stack = "docker"
security_groups_name = "kube_sg"