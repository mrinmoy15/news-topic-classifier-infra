# ── Variables ─────────────────────────────────────────
ENVS := dev pp prd
GITHUB_ORG  := mrinmoy15
GITHUB_REPO := news-topic-classifier-infra

# ── Bootstrap (Run Once Manually) ────────────────────
init-bootstrap:
	cd bootstrap && terraform init

plan-bootstrap:
	cd bootstrap && terraform plan -out=tfplan

apply-bootstrap:
	cd bootstrap && terraform apply tfplan

bootstrap-secrets:
	powershell -ExecutionPolicy Bypass -File set_secrets.ps1

bootstrap-all: init-bootstrap plan-bootstrap apply-bootstrap bootstrap-secrets
	@cmd /c echo 🎉 Bootstrap complete!

destroy-bootstrap:
	cd bootstrap && terraform destroy

# ── Init ──────────────────────────────────────────────
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

# ── Plan ──────────────────────────────────────────────
plan-dev:
	cd environments/dev && terraform plan -out=tfplan

plan-pp:
	cd environments/pp && terraform plan -out=tfplan

plan-prd:
	cd environments/prd && terraform plan -out=tfplan

# ── Apply ─────────────────────────────────────────────
apply-dev:
	cd environments/dev && terraform apply tfplan

apply-pp:
	cd environments/pp && terraform apply tfplan

apply-prd:
	cd environments/prd && terraform apply tfplan

# ── Destroy ───────────────────────────────────────────
destroy-dev:
	cd environments/dev && terraform destroy

destroy-pp:
	cd environments/pp && terraform destroy

destroy-prd:
	cd environments/prd && terraform destroy

# ── Format & Validate ─────────────────────────────────
fmt:
	terraform fmt -recursive

validate-dev:
	cd environments/dev && terraform validate

validate-pp:
	cd environments/pp && terraform validate

validate-prd:
	cd environments/prd && terraform validate

# ── Help ──────────────────────────────────────────────
help:
	@cmd /c echo.
	@cmd /c echo Available commands:
	@cmd /c echo.
	@cmd /c echo   Bootstrap:
	@cmd /c echo     make init-bootstrap      Initialize bootstrap
	@cmd /c echo     make plan-bootstrap      Plan bootstrap
	@cmd /c echo     make apply-bootstrap     Apply bootstrap
	@cmd /c echo     make bootstrap-secrets   Set GitHub secrets
	@cmd /c echo     make bootstrap-all       Run full bootstrap
	@cmd /c echo     make destroy-bootstrap   Destroy bootstrap
	@cmd /c echo.
	@cmd /c echo   Init:
	@cmd /c echo     make init-dev            Initialize dev
	@cmd /c echo     make init-pp             Initialize pp
	@cmd /c echo     make init-prd            Initialize prd
	@cmd /c echo     make init-all            Initialize all
	@cmd /c echo.
	@cmd /c echo   Plan:
	@cmd /c echo     make plan-dev            Plan dev
	@cmd /c echo     make plan-pp             Plan pp
	@cmd /c echo     make plan-prd            Plan prd
	@cmd /c echo.
	@cmd /c echo   Apply:
	@cmd /c echo     make apply-dev           Apply dev
	@cmd /c echo     make apply-pp            Apply pp
	@cmd /c echo     make apply-prd           Apply prd
	@cmd /c echo.
	@cmd /c echo   Destroy:
	@cmd /c echo     make destroy-dev         Destroy dev
	@cmd /c echo     make destroy-pp          Destroy pp
	@cmd /c echo     make destroy-prd         Destroy prd
	@cmd /c echo.
	@cmd /c echo   Utils:
	@cmd /c echo     make fmt                 Format Terraform files
	@cmd /c echo     make validate-dev        Validate dev
	@cmd /c echo     make validate-pp         Validate pp
	@cmd /c echo     make validate-prd        Validate prd
	@cmd /c echo.

# ── Phony Targets ─────────────────────────────────────
.PHONY: init-bootstrap plan-bootstrap apply-bootstrap \
		bootstrap-secrets bootstrap-all destroy-bootstrap \
		init-dev init-pp init-prd init-all \
		plan-dev plan-pp plan-prd \
		apply-dev apply-pp apply-prd \
		destroy-dev destroy-pp destroy-prd \
		fmt validate-dev validate-pp validate-prd help