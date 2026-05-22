# Variables
ENVS := dev pp prd
GITHUB_ORG  := mrinmoy15
GITHUB_REPO := news-topic-classifier-infra

# Bootstrap (Run Once Manually)
init-bootstrap:
	cd bootstrap && terraform init

plan-bootstrap:
	cd bootstrap && terraform plan -out=tfplan

apply-bootstrap:
	cd bootstrap && terraform apply tfplan

bootstrap-secrets:
	@echo "📦 Setting GitHub Actions secrets..."
	gh secret set WIF_PROVIDER \
		--body "$$(cd bootstrap && terraform output -raw workload_identity_provider)" \
		--repo $(GITHUB_ORG)/$(GITHUB_REPO)
	gh secret set SA_EMAIL \
		--body "$$(cd bootstrap && terraform output -raw service_account_email)" \
		--repo $(GITHUB_ORG)/$(GITHUB_REPO)
	@echo "✅ GitHub secrets set successfully!"

bootstrap-all: init-bootstrap plan-bootstrap apply-bootstrap bootstrap-secrets
	@echo "🎉 Bootstrap complete!"

destroy-bootstrap:
	cd bootstrap && terraform destroy

# Init
init-dev:
	cd environments/dev && terraform init

init-pp:
	cd environments/pp && terraform init

init-prd:
	cd environments/prd && terraform init

init-all:
	@for env in $(ENVS); do \
		echo "⚙️  Initializing $$env..."; \
		cd environments/$$env && terraform init && cd ../..; \
		echo "✅ $$env initialized"; \
	done

# Plan
plan-dev:
	cd environments/dev && terraform plan -out=tfplan

plan-pp:
	cd environments/pp && terraform plan -out=tfplan

plan-prd:
	cd environments/prd && terraform plan -out=tfplan

# Apply
apply-dev:
	cd environments/dev && terraform apply tfplan

apply-pp:
	cd environments/pp && terraform apply tfplan

apply-prd:
	cd environments/prd && terraform apply tfplan

# Destroy
destroy-dev:
	cd environments/dev && terraform destroy

destroy-pp:
	cd environments/pp && terraform destroy

destroy-prd:
	cd environments/prd && terraform destroy

# Format & Validate
fmt:
	terraform fmt -recursive

validate-dev:
	cd environments/dev && terraform validate

validate-pp:
	cd environments/pp && terraform validate

validate-prd:
	cd environments/prd && terraform validate

# Help
help:
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  Bootstrap (Run Once):"
	@echo "    make init-bootstrap    Initialize bootstrap"
	@echo "    make plan-bootstrap    Plan bootstrap"
	@echo "    make apply-bootstrap   Apply bootstrap"
	@echo "    make bootstrap-secrets Store the necessary secrets in the github settings"
	@echo "    make bootstrap-all     init plan apply and secrets--all run at once"
	@echo ""
	@echo "  Init:"
	@echo "    make init-dev          Initialize dev environment"
	@echo "    make init-pp           Initialize pp environment"
	@echo "    make init-prd          Initialize prd environment"
	@echo "    make init-all          Initialize all environments"
	@echo ""
	@echo "  Plan:"
	@echo "    make plan-dev          Plan dev (saves to tfplan)"
	@echo "    make plan-pp           Plan pp  (saves to tfplan)"
	@echo "    make plan-prd          Plan prd (saves to tfplan)"
	@echo ""
	@echo "  Apply:"
	@echo "    make apply-dev         Apply saved tfplan for dev"
	@echo "    make apply-pp          Apply saved tfplan for pp"
	@echo "    make apply-prd         Apply saved tfplan for prd"
	@echo ""
	@echo "  Destroy:"
	@echo "    make destroy-dev       Destroy dev environment"
	@echo "    make destroy-pp        Destroy pp environment"
	@echo "    make destroy-prd       Destroy prd environment"
	@echo ""
	@echo "  Utils:"
	@echo "    make fmt               Format all Terraform files"
	@echo "    make validate-dev      Validate dev environment"
	@echo "    make validate-pp       Validate pp environment"
	@echo "    make validate-prd      Validate prd environment"
	@echo ""

.PHONY: init-bootstrap plan-bootstrap apply-bootstrap destroy-bootstrap \
		init-dev init-pp init-prd init-all \
		plan-dev plan-pp plan-prd \
		apply-dev apply-pp apply-prd \
		destroy-dev destroy-pp destroy-prd \
		fmt validate-dev validate-pp validate-prd help