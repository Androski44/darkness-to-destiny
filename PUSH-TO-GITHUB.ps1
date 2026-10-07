# PUSH-TO-GITHUB.ps1 -- re-run this after editing the site to push updates.
$ErrorActionPreference = 'Stop'
$RepoUrl = 'SET-ME'
$SiteDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $SiteDir
$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) { Write-Host 'Install git from https://git-scm.com/download/win then run again.' -ForegroundColor Red; exit 1 }
if ($RepoUrl -eq 'SET-ME') { Write-Host 'Set $RepoUrl at the top of this script first.' -ForegroundColor Red; exit 1 }
if (-not (Test-Path (Join-Path $SiteDir '.git'))) { git init | Out-Null }
git add -A
if (-not (git status --porcelain)) { Write-Host 'Nothing new to push.' -ForegroundColor Yellow; exit 0 }
git commit -m "book site update $(Get-Date -Format 'yyyy-MM-dd HH:mm')" | Out-Null
if ((git remote) -notcontains 'origin') { git remote add origin $RepoUrl }
git branch -M main
git push -u origin main
Write-Host 'Pushed. Cloudflare Pages redeploys automatically.' -ForegroundColor Green

