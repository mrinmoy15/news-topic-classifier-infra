Write-Host "📦 Setting GitHub Actions secrets..." -ForegroundColor Cyan

# ── Get values from Terraform outputs ─────────────────
Set-Location bootstrap
$WIF_PROVIDER = terraform output -raw workload_identity_provider
$SA_EMAIL = terraform output -raw service_account_email
Set-Location ..

# ── Validate outputs are not empty ────────────────────
if ([string]::IsNullOrEmpty($WIF_PROVIDER)) {
    Write-Host "❌ WIF_PROVIDER is empty. Did you run make apply-bootstrap?" -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrEmpty($SA_EMAIL)) {
    Write-Host "❌ SA_EMAIL is empty. Did you run make apply-bootstrap?" -ForegroundColor Red
    exit 1
}

# ── Set GitHub Secrets ─────────────────────────────────
Write-Host "Setting WIF_PROVIDER..." -ForegroundColor Yellow
gh secret set WIF_PROVIDER `
    --body $WIF_PROVIDER `
    --repo mrinmoy15/news-topic-classifier-infra

Write-Host "Setting SA_EMAIL..." -ForegroundColor Yellow
gh secret set SA_EMAIL `
    --body $SA_EMAIL `
    --repo mrinmoy15/news-topic-classifier-infra

# ── Confirm ───────────────────────────────────────────
Write-Host ""
Write-Host "✅ GitHub secrets set successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Values set:" -ForegroundColor Cyan
Write-Host "  WIF_PROVIDER: $WIF_PROVIDER" -ForegroundColor Yellow
Write-Host "  SA_EMAIL:     $SA_EMAIL" -ForegroundColor Yellow