# 경제뉴스 YouTube 자동화 시스템 — 전체 레퍼런스

> 작성일: 2026-02-19
> 프로젝트 위치: `C:\Dev\EconNews-Auto\`
> 상태: **Phase 1 코드 작성 완료, 환경 셋업 미진행**

---

## 1. 프로젝트 개요

@우리의경제학(구독자 3.73만) 스타일의 경제 뉴스 YouTube 채널을 n8n으로 자동화.

| 포맷 | 빈도 | 자동화율 | 핵심 |
|------|------|---------|------|
| **Shorts 60초** | 매일 1~2개 | 95% 완전자동 | 뉴스→스크립트→TTS→영상→업로드 전부 무인 |
| **롱폼 15~20분** | 주 1회 | 60% 반자동 | 스크립트+TTS 자동, 영상 편집은 수동 |

**월 비용: ~$67 (약 9.5만원)**

---

## 2. 생성된 파일 전체 목록 (16개)

```
C:\Dev\EconNews-Auto\
├── .env.example                      # API 키 템플릿 (복사해서 .env로)
├── .gitignore
├── README.md                         # 프로젝트 개요 + 빠른 시작
├── docker-compose.yml                # n8n 로컬 실행용 Docker
│
├── n8n-workflows/
│   ├── shorts-pipeline.json          # ⭐ Shorts 완전자동화 (17노드)
│   └── longform-pipeline.json        # ⭐ 롱폼 반자동화 (9노드)
│
├── prompts/
│   ├── shorts-script.md              # Shorts 스크립트 프롬프트
│   ├── longform-script.md            # 롱폼 4막 스크립트 프롬프트
│   └── metadata.md                   # 메타데이터 SEO 프롬프트
│
├── templates/
│   └── creatomate-shorts.json        # Creatomate 템플릿 설정 가이드
│
├── setup/
│   ├── 01-n8n-docker-setup.md        # n8n 설치 (Docker/VPS/Cloud)
│   ├── 02-api-keys-guide.md          # API 키 4개 발급 초상세 가이드
│   ├── 03-youtube-oauth-guide.md     # YouTube OAuth2 설정
│   ├── 04-creatomate-guide.md        # Creatomate 템플릿 제작
│   └── 05-google-tts-guide.md        # Google TTS 음성 테스트
│
└── scripts/
    └── test-shorts.sh                # 4개 API 연결 테스트
```

Git: 초기 커밋 완료 (`ce0a8dc`)

---

## 3. Shorts 파이프라인 상세 (17노드)

```
[Cron 매일 06:00] → [NewsAPI 수집] → [유효 기사 필터]
    ↓ (기사 없으면 → Slack 알림)
[기사 1개 선택 (Code)] → [Claude Haiku 스크립트] → [스크립트 파싱 (Code)]
    ↓
[Google TTS Neural2] → [오디오 준비 (Code)] → [Creatomate 영상 생성]
    ↓
[30초 대기] → [렌더링 상태 확인] → [렌더링 성공?]
    ↓ 성공                              ↓ 실패
[Claude Haiku 메타데이터] →          [Slack 실패 알림]
[업로드 데이터 준비 (Code)] →
[영상 다운로드] → [YouTube 업로드] → [Slack 성공 알림]
```

### 각 노드에 필요한 Credential

| 노드 | Credential 타입 | 이름 |
|------|----------------|------|
| NewsAPI 뉴스 수집 | Header Auth | `NewsAPI Key` |
| Claude 스크립트 생성 | Header Auth | `Anthropic API Key` |
| Google TTS 나레이션 | URL 파라미터 | Google TTS API Key |
| Creatomate 영상 생성 | Header Auth | `Creatomate API Key` |
| Claude 메타데이터 생성 | Header Auth | `Anthropic API Key` (동일) |
| YouTube 업로드 | YouTube OAuth2 | `YouTube OAuth2` |
| Slack 알림 (3곳) | Slack API | `Slack Bot` |

### n8n 가져오기 후 해야 할 것
1. 각 노드 클릭 → Credentials 드롭다운에서 등록한 키 선택
2. Creatomate 노드: `YOUR_SHORTS_TEMPLATE_ID` → 실제 템플릿 ID로 교체
3. YouTube 노드: `privacyStatus`를 `private`로 변경 (테스트용)
4. Slack 노드: 채널명 `#youtube-automation` 확인/변경

---

## 4. 롱폼 파이프라인 상세 (9노드)

```
[Webhook POST] → [입력 검증] → [Claude Sonnet 4막 스크립트]
    ↓
[스크립트 파싱] → [Google TTS 나레이션] → [나레이션 파일 준비]
    ↓
[Claude Haiku 메타데이터] → [최종 결과 정리] → [Webhook 응답]
```

### 호출 방법
```bash
curl -X POST http://localhost:5678/webhook/longform-script \
  -H "Content-Type: application/json" \
  -d '{"topic": "삼성전자 반도체 위기", "angle": "산업 분석", "target_minutes": 15}'
```

### 응답에 포함되는 것
- 4막 스크립트 (intro, act1~3, outro)
- 타임스탬프
- 차트 삽입 포인트
- 나레이션 MP3 (base64)
- YouTube 메타데이터 (제목/설명/태그)
- 다음 단계 안내 (수동 편집 절차)

---

## 5. 사용 서비스 + 비용

| 서비스 | 용도 | 플랜 | 월 비용 |
|--------|------|------|--------|
| **NewsAPI** | 뉴스 수집 | Free | $0 |
| **Claude Haiku 4.5** | Shorts 스크립트+메타 | 종량제 | ~$1 |
| **Claude Sonnet 4.5** | 롱폼 스크립트 | 종량제 | ~$2 |
| **Google Cloud TTS Neural2** | 나레이션 | 무료 1M자/월 | $0 |
| **Creatomate** | Shorts 영상 합성 | Essential | $54 |
| **n8n** | 자동화 | Self-hosted Docker | ~$10 (VPS) |
| **YouTube Data API** | 업로드 | 무료 | $0 |
| **DaVinci Resolve** | 롱폼 편집 | 무료 | $0 |
| **합계** | | | **~$67/월** |

---

## 6. 프롬프트 핵심 요약

### Shorts 스크립트
- 모델: Claude Haiku 4.5
- 구조: Hook(5초) → 본문(45초) → 마무리(10초)
- 분량: 150~200자
- 출력: JSON (hook, body, closing, full_script, scene_descriptions)

### 롱폼 스크립트
- 모델: Claude Sonnet 4.5
- 구조: 인트로 → 1막(현상) → 2막(원인) → 3막(전망) → 아웃트로
- 분량: 250자/분 × 목표분 = 3,750~5,000자
- 출력: JSON (각 막 + timestamps + chart_points)

### 메타데이터
- Shorts: 제목 30자 이내 + 이모지 + 태그 10개
- 롱폼: 제목 50자 + 타임스탬프 포함 설명 + 태그 15~20개

---

## 7. TTS 설정

| 항목 | Shorts | 롱폼 |
|------|--------|------|
| 음성 | ko-KR-Neural2-A (여성) | ko-KR-Neural2-A (여성) |
| 속도 | 1.05 (약간 빠르게) | 1.0 (기본) |
| 피치 | 0 | 0 |
| 월 사용량 | ~9,000자 (45개) | ~15,000자 (4개) |
| 무료 한도 | 1,000,000자의 2.4% | 여유 충분 |

---

## 8. 다음 세션에서 해야 할 것 (순서대로)

### Phase 1: 환경 구축
- [ ] Docker Desktop 설치 확인
- [ ] `cd C:\Dev\EconNews-Auto && docker compose up -d` → n8n 실행
- [ ] `http://localhost:5678` 접속 → 계정 생성
- [ ] API 키 발급 (setup/02 가이드 따라):
  - [ ] NewsAPI (무료, 5분)
  - [ ] Anthropic Claude (이미 있을 수 있음)
  - [ ] Google Cloud TTS (프로젝트 생성 + API 활성화 + 키 생성)
  - [ ] Creatomate (가입 + 14일 무료체험)
- [ ] YouTube Data API 활성화 + OAuth2 설정 (setup/03 가이드)
- [ ] `.env.example` → `.env` 복사 후 키 입력
- [ ] `bash scripts/test-shorts.sh` 실행 → 4개 API 확인

### Phase 2: Shorts 파이프라인 가동
- [ ] Creatomate에서 Shorts 템플릿 제작 (setup/04 가이드)
- [ ] n8n에 `shorts-pipeline.json` 가져오기
- [ ] 각 노드에 Credentials 연결
- [ ] Creatomate 노드의 Template ID 교체
- [ ] 수동 실행 테스트 (YouTube private 모드)
- [ ] 테스트 영상 확인 → 문제 없으면 Cron 활성화

### Phase 3: 롱폼 파이프라인 가동
- [ ] n8n에 `longform-pipeline.json` 가져오기
- [ ] Credentials 연결
- [ ] curl로 테스트 호출 → 스크립트+나레이션 확인
- [ ] DaVinci Resolve 설치 (무료)
- [ ] 첫 롱폼 영상 편집 + 업로드

### Phase 4: 최적화
- [ ] Shorts 영상 품질 확인 + 프롬프트 튜닝
- [ ] 업로드 시간대 최적화 (한국 저녁 6~8시 추천)
- [ ] 중복 기사 방지 (n8n에 간단한 DB 추가)
- [ ] Slack 알림 채널 설정

---

## 9. 알려진 한계/주의사항

- **NewsAPI Free**: 상업적 사용 불가 → 수익화 시 Developer $449/월 필요
- **YouTube AI 표시**: AI 생성 콘텐츠 표시 의무 (2024년~)
- **YouTube 업로드 한도**: 일 6회 (10,000 units ÷ 1,600)
- **Creatomate 한글 폰트**: Noto Sans KR 사용 (Pretendard는 직접 업로드 필요)
- **저작권**: 뉴스 원문 인용 시 출처 명시 필수
- **가짜뉴스**: 롱폼은 반드시 팩트체크 단계 거칠 것

---

## 10. 참고 링크

| 서비스 | URL |
|--------|-----|
| n8n 공식 | https://n8n.io |
| NewsAPI | https://newsapi.org |
| Anthropic Console | https://console.anthropic.com |
| Google Cloud TTS | https://cloud.google.com/text-to-speech |
| Creatomate | https://creatomate.com |
| YouTube Studio | https://studio.youtube.com |
| DaVinci Resolve | https://www.blackmagicdesign.com/products/davinciresolve |

### n8n 참고 워크플로우
- [YouTube Shorts Automation](https://n8n.io/workflows/2941)
- [Automated News Video Generation](https://n8n.io/workflows/10158)
- [One-Click YouTube Shorts Generator](https://n8n.io/workflows/5683)
- [Creatomate + n8n 가이드](https://creatomate.com/blog/how-to-automatically-create-youtube-shorts-with-n8n)
