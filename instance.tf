
##################################################### DB Instance Creation ###########################################


resource "aws_instance" "terraform-private" {
  ami   = "${lookup(var.ami_id, var.region)}"
  instance_type = "${var.instanc_type}"
  key_name = "${var.private_key_path}"
  user_data = "${data.template_file.ec2-userdata-mysql.rendered}"
  private_ip = "${var.db_privateip}"

#####  count = "var.instance_count"

provisioner "local-exec" {
  command = "echo ${aws_instance.terraform-public.private_ip} >> ipaddress.txt"
}

##### Subnet assign to instance #####
  subnet_id     = aws_subnet.private_1.id

##### Security group assign to instance #####
  vpc_security_group_ids=[aws_security_group.allow_db.id]

 tags = {
   Name = "DB-Server"
 }

}

data "template_file" "ec2-userdata-mysql" {
template = "${file("${path.module}/files/mysql.sh")}"
#vars = { }
}

######################################### Word Press Creation ##################################################### 
resource "aws_instance" "terraform-public" {
  ami   = "${lookup(var.ami_id, var.region)}"
  instance_type = "${var.instanc_type}"
  key_name = "${var.private_key_path}"
  user_data = "${data.template_file.ec2-userdata.rendered}"

#####  count = "var.instance_count"

provisioner "local-exec" {
 command = "echo ${aws_instance.terraform-public.public_ip} >> ipaddress.txt"
}

##### Public Subnet assign to instance #####
  subnet_id     = aws_subnet.public_1.id

##### Security group assign to instance #####
  vpc_security_group_ids=[aws_security_group.allow_ssh.id]

 tags = {
   Name = "Wordpress-Server"
 }

}

data "template_file" "ec2-userdata" {
template = "${file("${path.module}/files/wordpressuserdata.sh")}"
vars = { 
  DB_HOST = "${var.db_privateip}" 
 }
}


######################################### Nat Instance ################################################

resource "aws_instance" "terraform-nat" {
  ami   = "${lookup(var.ami_id, "nat")}"
  instance_type = "${var.instanc_type}"
  key_name = "${var.private_key_path}"

#####  count = "var.instance_count"

provisioner "local-exec" {
  command = "echo ${aws_instance.terraform-public.public_ip} >> ipaddress.txt"
}

##### Subnet assign to instance #####
  subnet_id     = aws_subnet.public_1.id

##### Security group assign to instance #####
  vpc_security_group_ids=[aws_security_group.allow-nat.id]
  associate_public_ip_address = true
  source_dest_check = false

 tags = {
   Name = "Nat Server"
 }

}


resource "aws_eip" "nat" { 
instance = "${aws_instance.terraform-nat.id}" 
vpc = true 
}

