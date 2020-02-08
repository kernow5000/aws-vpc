output "vpc-id" {
  value = "${aws_vpc.vpc-tf.id}"
}

output "ngw-eip" {
  value = "${aws_eip.vpc-tf-ngw-eip}"
}

output "pub-subnet-1-id" {
  value = "${aws_subnet.vpc-tf-pub_subnet_1.id}"
}

output "pub-subnet-2-id" {
  value = "${aws_subnet.vpc-tf-pub_subnet_2.id}"
}


