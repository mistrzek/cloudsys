resource "aws_instance" "ansible_server" {
    ami           = "ami-3e713f4d"
    count         = 1
    instance_type = "t2.micro"
    key_name      = "DevSSH"
    subnet_id     = "${var.app_subnet_id}"
    vpc_security_group_ids      = ["${aws_security_group.allow_admin_sg.id}"]
    associate_public_ip_address = "false"
    user_data                   = "${data.template_file.ansible_user_data.rendered}"

    tags {
        Name    = "ansible.home.co.uk"
        Creator = "terraform"
    }
}

data "template_file" "ansible_user_data" {
    template = "${file("${path.module}/bin/user_data_ansible.sh")}"

    vars {
	node_ip = "${aws_instance.test_node.private_ip}"
    }
}

