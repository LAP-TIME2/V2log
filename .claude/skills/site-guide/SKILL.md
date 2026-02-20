# /site-guide — 외부 사이트 단계별 가이드 자동 생성 (v2: Playwright MCP)

## 개요
사용자가 외부 웹사이트 사용법을 모를 때, Claude가 **Playwright MCP**로 직접 사이트에 접속하여
**단계별 스크린샷 → 어노테이션(번호, 강조, 화살표) → PDF 가이드**를 자동 생성한다.

## 사용법
```
/site-guide <URL> "<가이드 제목>"
/site-guide https://roboflow.com "프로젝트 생성하는 법"
```

## 인자
- `$ARGUMENTS`를 파싱하여 URL과 제목을 추출한다.
- 형식: `<URL> "<제목>"` 또는 `<URL> <제목>`
- URL이 없으면 사용자에게 요청한다.

---

## Phase 0: 환경 준비

1. **fpdf2 확인**: `python -c "import fpdf"` 실패 시 `pip install fpdf2` 실행
2. **Pillow 확인**: `python -c "from PIL import Image"` 실패 시 `pip install Pillow` 실행
3. **임시 디렉토리 생성**: Bash로 고정 경로 `C:\Dev\V2log\temp_guide` 사용 (이전 파일이 있으면 정리)
4. **steps 배열 초기화**: 메모리에 빈 배열 준비 (나중에 steps.json으로 저장)

---

## Phase 1: 브라우저 열기

1. **URL로 이동**:
   ```
   browser_navigate(url="<URL>")
   ```

2. **브라우저 크기 설정** (1280x720 CSS 픽셀):
   ```
   browser_resize(width=1280, height=720)
   ```

이것만으로 끝. App/Shell/MoveWindow/Wait 불필요.

---

## Phase 2: 단계별 캡처 루프

**최대 20단계**까지 반복. 각 단계에서:

### 2-1. 화면 분석 (접근성 스냅샷)
```
browser_snapshot()
```
- 접근성 트리(DOM 구조)를 텍스트로 반환 — 비전 분석보다 **훨씬 빠름**
- 각 요소에 `ref` 번호가 붙어 있음 → 이 ref로 클릭/입력 가능
- 가이드 완성 조건에 도달했으면 루프 종료

### 2-2. 스크린샷 저장
```
browser_take_screenshot(raw=true)
```
- 브라우저 내부에서 직접 캡처 (PowerShell 불필요!)
- `raw=true`를 사용하면 base64 PNG 데이터가 반환됨
- 이미지가 반환되면, **Python으로 파일 저장**:
  ```bash
  python -c "import base64,sys;open(sys.argv[1],'wb').write(base64.b64decode(sys.argv[2]))" "<temp_dir>/step_<N>_raw.png" "<base64_data>"
  ```
- base64가 너무 길면 임시 파일로 우회:
  ```bash
  # base64 데이터를 파일로 저장 후 디코딩
  python -c "
import base64, sys
with open(sys.argv[1], 'r') as f:
    data = f.read()
with open(sys.argv[2], 'wb') as f:
    f.write(base64.b64decode(data))
" "<temp_dir>/step_<N>_b64.txt" "<temp_dir>/step_<N>_raw.png"
  ```

**또는** `browser_take_screenshot()`을 raw 없이 호출하면 Claude가 이미지를 직접 볼 수 있음 (화면 분석용).
저장이 필요하면 `browser_evaluate`로 JS를 실행하여 캡처하는 방법도 있음.

**가장 간단한 방법**: Playwright의 `browser_take_screenshot`이 파일 경로를 지원하는 경우 그것을 사용.
지원하지 않으면, `browser_evaluate`로 페이지를 캡처하고 `browser_take_screenshot(raw=true)`의 결과를 Python으로 저장.

### 2-3. 어노테이션 메타데이터 결정

Playwright는 **CSS 픽셀 좌표**를 사용한다. 스크린샷도 CSS 픽셀 기준이므로
**좌표 변환이 필요 없다** (DPI 스케일링 무관).

`browser_snapshot`에서 얻은 접근성 트리의 요소 위치를 기반으로 어노테이션 좌표를 결정한다.
요소의 위치가 필요하면 `browser_evaluate`로 `getBoundingClientRect()`를 호출:
```
browser_evaluate(expression="document.querySelector('<selector>').getBoundingClientRect()")
```

각 단계의 메타데이터 구조:
```json
{
  "image": "step_1_raw.png",
  "title": "단계 제목 (한국어)",
  "description": "이 단계에서 무엇을 하는지 설명 (한국어)",
  "warning": "비용/위험 관련 경고 (없으면 빈 문자열)",
  "annotations": [
    {
      "type": "highlight_rect",
      "x": 100, "y": 200, "w": 150, "h": 40,
      "color": "click"
    },
    {
      "type": "circle_number",
      "x": 90, "y": 220,
      "number": 1,
      "color": "red"
    },
    {
      "type": "arrow",
      "x1": 200, "y1": 100, "x2": 150, "y2": 190,
      "color": "orange"
    },
    {
      "type": "label",
      "x": 260, "y": 200,
      "text": "여기를 클릭하세요",
      "color": "red"
    },
    {
      "type": "warning",
      "x": 50, "y": 650,
      "w": 400,
      "text": "이 작업은 요금이 발생할 수 있습니다"
    }
  ],
  "blur_regions": [
    {"x": 300, "y": 100, "w": 200, "h": 30}
  ]
}
```

### 2-4. steps 배열에 추가
메타데이터를 steps 배열에 push.

### 2-5. 다음 동작 실행

Playwright MCP는 **접근성 텍스트/ref 기반**으로 요소를 찾는다 (좌표 불필요!):

- **클릭**: `browser_click(element="버튼 텍스트")` 또는 `browser_click(ref="<ref번호>")`
  - 접근성 스냅샷의 ref 번호 또는 표시 텍스트 사용
  - 좌표 계산이 **완전히 불필요**

- **텍스트 입력**: `browser_type(element="입력 필드 이름", text="입력값")`
  또는 `browser_type(ref="<ref번호>", text="입력값")`

- **파일 업로드**: `browser_file_upload(paths=["C:/path/to/file.png"])`
  - 파일 다이얼로그 없이 직접 업로드 가능!

- **스크롤**: `browser_evaluate(expression="window.scrollBy(0, 500)")`

- **조건 대기**: `browser_wait_for(text="로딩 완료")`
  - 시간 기반이 아닌 **조건 기반** 대기

- **셀렉트/드롭다운**: `browser_select_option(element="선택", values=["옵션값"])`

- **키보드**: `browser_press_key(key="Enter")`

### 2-6. 종료 조건 확인
- 가이드 목표 달성
- 20단계 초과 → 경고와 함께 종료
- 로그인 필요 감지 → 사용자에게 안내 후 중단
- 에러/404 → 1회 재시도 후 중단

---

## Phase 3: PDF 생성

1. **steps.json 저장**:
   steps 배열을 JSON으로 직렬화하여 `<temp_dir>/steps.json`에 저장한다.
   Write 도구를 사용하여 파일을 생성한다:
   ```json
   {
     "url": "<URL>",
     "title": "<가이드 제목>",
     "steps": [ ... ]
   }
   ```

2. **Python 스크립트 실행**:
   ```bash
   python C:/Dev/V2log/scripts/site-guide/annotate_and_pdf.py "<temp_dir>" "C:/Dev/V2log/docs/reference/<YYYY-MM-DD>_사이트가이드_<제목>.pdf" --title "<가이드 제목>"
   ```
   - `<YYYY-MM-DD>`: 오늘 날짜
   - `<제목>`: URL에서 추출한 짧은 이름 또는 사용자 지정 제목 (공백/특수문자 제거)

3. **결과 확인**: 스크립트 출력에서 성공/실패 확인

---

## Phase 4: 정리 + 보고

1. **브라우저 탭 닫기** (선택적):
   ```
   browser_close()
   ```

2. **임시 파일 정리**:
   ```bash
   rm -rf <temp_dir>
   ```

3. **결과 보고** (사용자에게):
   ```
   PDF 가이드가 생성되었습니다!
   - 파일: docs/reference/YYYY-MM-DD_사이트가이드_<제목>.pdf
   - 총 N단계
   - 내용 요약: ...
   ```

---

## 어노테이션 가이드라인

Claude가 어노테이션을 결정할 때 따를 규칙:

### 좌표 기준
- **Playwright 스크린샷 = CSS 픽셀 좌표** (1280x720 기준)
- 좌표 변환/오프셋 계산 불필요 (Windows MCP와 다름!)
- 요소 위치가 필요하면 `browser_evaluate`로 `getBoundingClientRect()` 사용

### 색상 규칙
| 동작 | 색상 | 용도 |
|------|------|------|
| 클릭할 곳 | `click` (빨강) | 버튼, 링크, 메뉴 |
| 입력할 곳 | `input` (파랑) | 텍스트 필드, 드롭다운 |
| 결과/확인 | `result` (초록) | 성공 메시지, 완료 상태 |
| 시선 유도 | `orange` | 화살표로 주목 포인트 |

### 필수 어노테이션
- 매 단계마다 **최소 1개의 highlight_rect** (사용자가 봐야 할 곳)
- **circle_number**는 자동으로 좌상단에 추가됨 (스크립트가 처리)
- 추가로 클릭 위치 근처에 circle_number를 넣으면 더 명확

### 경고 (warning) 기준
- 결제/요금 발생 가능성 → 반드시 warning
- 되돌리기 어려운 작업 (삭제, 배포 등) → 반드시 warning
- API 키 노출 → blur_regions + warning

### 민감 정보 보호
- API 키, 비밀번호, 개인정보 → `blur_regions`에 좌표 추가
- Snapshot에서 민감 정보가 보이면 즉시 블러 처리

---

## 로그인이 필요한 사이트 (CDP 연결)

로그인 세션을 유지하려면 사용자에게 **Edge/Chrome을 디버깅 모드로 실행**하도록 안내:
```bash
# Edge
msedge.exe --remote-debugging-port=9222

# Chrome
chrome.exe --remote-debugging-port=9222
```

그런 다음 Playwright MCP를 CDP 엔드포인트에 연결:
```bash
claude mcp add playwright -- npx @playwright/mcp@latest --cdp-endpoint http://localhost:9222
```

→ 이미 로그인된 브라우저 세션에 그대로 붙어서 작업 가능.

---

## 에러 처리

| 상황 | 대응 |
|------|------|
| 로그인 필요 감지 | "CDP로 로그인된 브라우저에 연결하거나, 먼저 로그인 후 다시 실행해주세요" + 중단 |
| 사이트 로딩 실패 | `browser_wait_for` → 재시도 1회 → URL 확인 요청 |
| 20단계 초과 | 현재까지 결과로 PDF 생성 + "20단계를 초과하여 여기까지 생성했습니다" |
| 민감정보 감지 | blur_regions 자동 추가 |
| fpdf2 미설치 | `pip install fpdf2` 자동 실행 |
| Python 스크립트 실패 | 에러 로그 출력 + steps.json은 보존 (수동 재시도 가능) |
| Playwright MCP 연결 실패 | "Playwright MCP 서버가 실행 중인지 확인" + `claude mcp list` 안내 |
| 스크린샷 저장 실패 | `browser_evaluate`로 대체 캡처 시도 |

---

## 주의사항

- **CLAUDE.local.md 외부 사이트 작업 가이드 규칙** 준수: 매 클릭마다 화면 설명 + 클릭 위치 + 옵션 선택 설명
- **비용/위험 경고 필수**: 유료 기능, 삭제 작업 등에 항상 warning 추가
- **한국어 우선**: 모든 title, description, label, warning은 한국어로 작성
- 브라우저 크기는 **1280x720 CSS 픽셀** 고정 — 어노테이션 좌표도 이 기준
- 스크린샷 해상도 = CSS 픽셀 (DPI 스케일링 무관)
- Windows MCP는 삭제하지 않음 (데스크탑 앱 조작 등 다른 용도로 계속 사용)
