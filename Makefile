# ── Variables ─────────────────────────────────────────
ENVS := dev pp prd
GITHUB_ORG  := mrinmoy15
GITHUB_REPO := news-topic-classifier-infra

REGION          := us-central1
REGISTRY        := $(REGION)-docker.pkg.dev
REPO            := news-topic-classifier
MLFLOW_TAG      := latest

DEV_PROJECT  := cs-cdwp-data-dev2188
PP_PROJECT   := cs-cdwp-data-pp2188
PRD_PROJECT  := cs-cdwp-data-prd2188

DEV_IMAGE    := $(REGISTRY)/$(DEV_PROJECT)/$(REPO)/mlflow:$(MLFLOW_TAG)
PP_IMAGE     := $(REGISTRY)/$(PP_PROJECT)/$(REPO)/mlflow:$(MLFLOW_TAG)
PRD_IMAGE    := $(REGISTRY)/$(PRD_PROJECT)/$(REPO)/mlflow:$(MLFLOW_TAG)

# ── MLflow Docker Image ───────────────────────────────
mlflow-auth:
	gcloud auth configure-docker $(REGISTRY)

mlflow-build:
	docker build -t $(DEV_IMAGE) docker/mlflow/

mlflow-push-dev: mlflow-build
	docker push $(DEV_IMAGE)

mlflow-push-pp: mlflow-build
	docker tag $(DEV_IMAGE) $(PP_IMAGE)
	docker push $(PP_IMAGE)

mlflow-push-prd: mlflow-build
	docker tag $(DEV_IMAGE) $(PRD_IMAGE)
	docker push $(PRD_IMAGE)

mlflow-push-all: mlflow-push-dev mlflow-push-pp mlflow-push-prd

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
	make init-dev
	make init-pp
	make init-prd

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
	@cmd /c echo   MLflow Image:
	@cmd /c echo     make mlflow-auth          Auth Docker to Artifact Registry
	@cmd /c echo     make mlflow-build         Build MLflow image
	@cmd /c echo     make mlflow-push-dev      Build and push to dev registry
	@cmd /c echo     make mlflow-push-pp       Tag and push to pp registry
	@cmd /c echo     make mlflow-push-prd      Tag and push to prd registry
	@cmd /c echo     make mlflow-push-all      Push to all three registries
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
		fmt validate-dev validate-pp validate-prd help \
		mlflow-auth mlflow-build \
		mlflow-push-dev mlflow-push-pp mlflow-push-prd mlflow-push-all