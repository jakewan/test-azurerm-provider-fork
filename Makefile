init-and-plan:
	cd src/azure && rm -rf .terraform
	cd src/azure && rm -f .terraform.lock.hcl
	cd src/azure && terraform init
	cd src/azure && terraform plan
