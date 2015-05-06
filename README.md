# Tsuru Terraform

## Requirements

You need the terraform binary, e.g. `brew install terraform`.

You need an SSH key. The private key needs to be chmod to 600.

You need the cloud provider credentials. These will be entered on the command line.

### Extra requirements for GCE provisioning

1. The terraform provider for GCE requires access to an 'account.json' file - this is available from GCE's web interface in the 'credentials' section.

Please note, for our team this is currently shared as it's not clear that we can create multiple accounts. If you are on the team please obtain the credentials from someone else. There is a [story in our backlog](https://www.pivotaltracker.com/n/projects/1275640/stories/93990946) to address this.

2. The GCE provider for Terraform does not currently have support for managing DNS records, and as such we have created a wrapper around Google's 'gcloud' command which allows us to create DNS records as part of a local-provisioner step. It is necessary to manually install the 'gcloud' command line utility and authenticate it before running Terraform for the first time.

`$ curl https://sdk.cloud.google.com | bash`

`$ gcloud components update`

`$ gcloud auth activate-service-account --key-file ~/path/to/account.json`

`$gcloud config set project <name_of_project_in_GCE>`

Once the above steps are complete, performing a  `gcloud compute instances list` will confirm that authentication is working as expected.


## Notes

Change into one of the provider sub-directories before executing `terraform` commands.


For usage, refer to the [Terraform CLI doc](https://www.terraform.io/docs/commands/index.html).

We have found that `terraform destroy` doesn't work reliably. Possible cause [this issue](https://github.com/hashicorp/terraform/issues/1203). Workaround is to delete manually via the console.

