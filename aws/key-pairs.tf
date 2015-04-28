resource "aws_key_pair" "deployer" {
  key_name   = "deployer-tsuru-example" 
  public_key = "${file(\"ssh/insecure-deployer.pub\")}"
}

