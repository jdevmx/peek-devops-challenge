TF_DIR=terraform/
ENVIRONMENT=local

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
	
run: init setWorkspace plan apply