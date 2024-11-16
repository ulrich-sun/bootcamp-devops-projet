security_groups_name  = "sg_project"
security_groups_ports = [22, 80, 8080, 8069, 30080, 30010, 30011]
instance_type         = "t2.medium"
username              = "ubuntu"
# key_name              = "key_project"
protocol              = "tcp"
region                = "us-east-1"
stack                 = "kubernetes"