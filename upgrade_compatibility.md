# Upgrade Compatibility

While we try and make all changes backwards-compatible, sometimes we have to make changes that mean you cannot cleanly provision a new environment.


## DNS resources already exist

Error:

`Error creating DNS RecordSet: googleapi: Error 409: The resource 'entity.change.additions[0]' named 'env-proxy.tsuru2.paas.alphagov.co.uk. (A)' already exists, alreadyExists`

This is caused by [7780fe9d](https://github.com/alphagov/tsuru-terraform/commit/7780fe9), which also contains the scrips you can use to fix it.
