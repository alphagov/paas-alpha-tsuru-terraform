resource "azure_hosted_service" "api-servers" {
    name = "tsuru-api-dan"
    location = "North Europe"
    ephemeral_contents = false
    description = "API servers"
    label = "api-servers"
}

resource "azure_storage_service" "tfstor" {
    name = "tfstor1dan1tsuru"
    location = "North Europe"
    description = "Made by Terraform."
    account_type = "Standard_LRS"
}

resource "azure_instance" "web" {
    name = "terraform-test"
    hosted_service_name = "${azure_hosted_service.api-servers.name}"
    image = "Ubuntu Server 14.04.2-LTS"
    size = "Basic_A1"
    storage_service_name = "tfstor1dan1tsuru"

    location = "Europe West"
    username = "terraform"
    password = "Pass!admin123"

    endpoint {
        name = "SSH"
        protocol = "tcp"
        public_port = 22
        private_port = 22
    }
}