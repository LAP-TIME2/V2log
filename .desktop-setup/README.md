# Desktop Setup

데스크탑에서 V2log 테스트 환경을 세팅하기 위한 파일들.

## 사용법

1. 데스크탑에서 PowerShell 열기
2. 아래 명령어 실행:

```powershell
cd C:\Users\mal03\Dev\In_desktop_V2log
git clone https://github.com/LAP-TIME2/V2log.git .
powershell -ExecutionPolicy Bypass -File .\.desktop-setup\setup_desktop.ps1
```

3. 설치 완료 후:
```
claude          # 클로드 코드 시작
flutter run -d R3CT90G9P0B   # 앱 실행
```

## 포함 파일
- `CLAUDE.local.md` — 개인 작업 규칙 (한국어, 세션로그, 커밋 규칙)
- `memory/MEMORY.md` — 클로드 코드 Memory (작업 규칙, 미반영 결정, 보고서 인덱스)
- `memory/debugging-patterns.md` — 디버깅 패턴 & 교훈
- `memory/decisions-archive.md` — 결정 아카이브
- `setup_desktop.ps1` — 자동 설치 스크립트
