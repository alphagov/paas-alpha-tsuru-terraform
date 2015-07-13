.PHONY: all \
	aws start-aws start-gce

TERRAFORM_CMD = cd $(1) && \
	terraform $(2) \
	-var env=${DEPLOY_ENV} \
	${ARGS} && cd ..

all:
	$(error Usage: make <start-aws|start-gce> DEPLOY_ENV=name [ARGS=extra_args])

check-env-aws: check-env-var
ifndef AWS_SECRET_ACCESS_KEY
	$(error Environment variable AWS_SECRET_ACCESS_KEY must be set)
endif
ifndef AWS_ACCESS_KEY_ID
	$(error Environment variable AWS_ACCESS_KEY_ID must be set)
endif

check-env-var:
ifndef DEPLOY_ENV
	$(error Must pass DEPLOY_ENV=<name>)
endif

start-aws: check-env-var check-env-aws
	cd aws && \
	terraform taint aws_elb.api-ext && \
	terraform taint aws_elb.api-int && \
	terraform taint aws_elb.router && \
	cd .. && \
	$(call TERRAFORM_CMD,aws,apply)

start-gce: check-env-var
	$(call TERRAFORM_CMD,gce,apply)
