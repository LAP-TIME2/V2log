# ===========================================
# V2log 데스크탑 테스트 환경 자동 설치 스크립트
# ===========================================
# 사용법: 데스크탑에서 PowerShell 열고
#   cd C:\Users\mal03\Dev\In_desktop_V2log
#   .\setup_desktop.ps1
# ===========================================

# --- UTF-8 한글 깨짐 방지 ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

$ErrorActionPreference = "Stop"
$projectDir = "C:\Users\mal03\Dev\In_desktop_V2log"
$memoryDir = "C:\Users\mal03\.claude\projects\C--Users-mal03-Dev-In_desktop_V2log\memory"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " V2log Desktop Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# --- Step 1: CLAUDE.local.md 복사 ---
Write-Host "[1/4] CLAUDE.local.md 설치 중..." -ForegroundColor Yellow
if (Test-Path "$projectDir\.desktop-setup\CLAUDE.local.md") {
    Copy-Item "$projectDir\.desktop-setup\CLAUDE.local.md" "$projectDir\CLAUDE.local.md" -Force
    Write-Host "  OK: CLAUDE.local.md" -ForegroundColor Green
} else {
    Write-Host "  SKIP: .desktop-setup/CLAUDE.local.md 없음" -ForegroundColor Red
}

# --- Step 2: Memory 폴더 생성 + 파일 복사 ---
Write-Host "[2/4] Memory 파일 설치 중..." -ForegroundColor Yellow
if (-not (Test-Path $memoryDir)) {
    New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null
    Write-Host "  Created: $memoryDir" -ForegroundColor Gray
}

$memoryFiles = @("MEMORY.md", "debugging-patterns.md", "decisions-archive.md")
foreach ($file in $memoryFiles) {
    $src = "$projectDir\.desktop-setup\memory\$file"
    $dst = "$memoryDir\$file"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Host "  OK: $file" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: $file 없음" -ForegroundColor Red
    }
}

# --- Step 3: Flutter pub get ---
Write-Host "[3/4] Flutter 패키지 설치 중..." -ForegroundColor Yellow
Set-Location $projectDir
flutter pub get
Write-Host "  OK: flutter pub get" -ForegroundColor Green

# --- Step 4: Build Runner ---
Write-Host "[4/4] 코드 생성 중 (1~2분 소요)..." -ForegroundColor Yellow
dart run build_runner build --delete-conflicting-outputs
Write-Host "  OK: build_runner" -ForegroundColor Green

# --- 완료 ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " 설치 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor Cyan
Write-Host "  1. claude  (클로드 코드 시작)" -ForegroundColor White
Write-Host "  2. flutter run -d R3CT90G9P0B  (앱 실행)" -ForegroundColor White
Write-Host ""
