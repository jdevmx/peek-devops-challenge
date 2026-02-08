TF_DIR=terraform/
UI_DIR=votes-ui
API_DIR=votes-api
ENVIRONMENT=local

build-ui:
	cd $(UI_DIR) && docker build -t peek-votes-ui .

build-api:
	cd $(API_DIR) && docker build -t peek-votes-api .

init:
	cd $(TF_DIR) && terraform init

setWorkspace:
	cd $(TF_DIR) && (terraform workspace select $(ENVIRONMENT) || terraform workspace new $(ENVIRONMENT))

plan:
	cd $(TF_DIR) && terraform plan

confirm:
	@echo "Are you sure you want to apply changes to $(ENVIRONMENT)? [y/N] " && read answer && [ $${answer:-N} = y ]

apply: confirm
	cd $(TF_DIR) && terraform apply -auto-approve

destroy: init
	cd $(TF_DIR) && terraform destroy && terraform workspace select default && terraform workspace delete $(ENVIRONMENT)

build: build-ui build-api

run-terraform: init setWorkspace plan apply

run-pipeline: build run-terraform