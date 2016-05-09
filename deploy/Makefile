.PHONY: all build setup plan apply destroy

ENV := dev

all: setup plan apply

setup:
	terraform remote pull
plan:
	terraform plan -var-file=$(ENV).tfvars
apply:
	terraform apply -var-file=$(ENV).tfvars
destroy:
	terraform destroy -var-file=$(ENV).tfvars
