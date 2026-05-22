Write-Host "Setting up news-topic-classifier-infra repo structure..." -ForegroundColor Cyan

# ── Directories ───────────────────────────────────────
$dirs = @(
    "bootstrap",
    "modules/bigquery",
    "modules/cloud_storage",
    "modules/artifact_registry",
    "modules/vertex_ai",
    "modules/secret_manager",     
    "modules/cloud_run",         
    "modules/cloud_scheduler",
    "environments/dev",
    "environments/pp",
    "environments/prd",
    ".github/workflows"
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Write-Host "📁 Created directory: $dir" -ForegroundColor Yellow
}

# ── Bootstrap files ───────────────────────────────────
$bootstrapFiles = @(
    "bootstrap/main.tf",
    "bootstrap/variables.tf",
    "bootstrap/outputs.tf",
    "bootstrap/versions.tf",
    "bootstrap/terraform.tfvars.example"
)

# ── Module files ──────────────────────────────────────
$modules = @(
    "bigquery", 
    "cloud_storage", 
    "artifact_registry", 
    "secret_manager",
    "cloud_run",
    "cloud_scheduler",
    "vertex_ai"
)
$moduleFiles = @()
foreach ($module in $modules) {
    $moduleFiles += "modules/$module/main.tf"
    $moduleFiles += "modules/$module/variables.tf"
    $moduleFiles += "modules/$module/outputs.tf"
}

# ── Environment files ─────────────────────────────────
$envFiles = @()
foreach ($env in @("dev", "pp", "prd")) {
    $envFiles += "environments/$env/main.tf"
    $envFiles += "environments/$env/variables.tf"
    $envFiles += "environments/$env/outputs.tf"
}

# ── GitHub Actions workflows ──────────────────────────
$workflowFiles = @(
    ".github/workflows/terraform-dev.yml",
    ".github/workflows/terraform-pp.yml",
    ".github/workflows/terraform-prd.yml"
)

# ── Root level files ──────────────────────────────────
$rootFiles = @(
    "versions.tf",
    "variables.tf",
    "outputs.tf",
    "Makefile",
    "set_secrets.ps1",
    ".gitignore",
    "README.md"
)

# ── Create all files ──────────────────────────────────
$allFiles = $bootstrapFiles + $moduleFiles + $envFiles + $workflowFiles + $rootFiles

foreach ($file in $allFiles) {
    New-Item -ItemType File -Path $file -Force | Out-Null
    Write-Host "📄 Created file: $file" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Structure created successfully!" -ForegroundColor Cyan
Write-Host ""

# ── Print tree ────────────────────────────────────────
Write-Host "📂 Repo Structure:" -ForegroundColor Magenta
Get-ChildItem -Recurse |
    Where-Object { $_.FullName -notlike "*\.git*" } |
    Sort-Object FullName |
    ForEach-Object {
        $depth = ($_.FullName.Split([System.IO.Path]::DirectorySeparatorChar).Count -
                  $PWD.Path.Split([System.IO.Path]::DirectorySeparatorChar).Count)
        $indent = "  " * $depth
        if ($_.PSIsContainer) {
            Write-Host "$indent📁 $($_.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "$indent📄 $($_.Name)" -ForegroundColor White
        }
    }