# /video-analyzer — MP4 동영상 분석 스킬

## 트리거

사용자가 다음 키워드를 사용할 때 이 스킬을 실행한다:
- "영상 분석", "MP4 분석", "동영상 봐줘", "비디오 분석"
- "이 영상 뭔지 봐줘", "영상 요약해줘"
- `/video-analyzer <파일경로>` 직접 호출

## 사전 조건

- ffmpeg, ffprobe가 PATH에 있어야 함
- 없으면: `winget install --id Gyan.FFmpeg -e`

## 실행 흐름

### Phase 0: 입력 파싱

사용자 입력에서 추출:
- `FILE_PATH`: MP4 파일 경로 (필수)
- `MODE`: 분석 모드 A/B/C (선택, 미지정 시 자동 추천)
- `INTERVAL`: 모드 B 캡처 간격 초 (선택)
- `START`/`END`: 모드 C 시작/종료 시간 (선택)

파일이 존재하는지 확인. 없으면 즉시 에러 출력하고 중단.

### Phase 1: 영상 정보 수집

```bash
ffprobe -v quiet -print_format json -show_format -show_streams "<FILE_PATH>"
```

추출할 정보:
- **길이** (duration) → 초 단위, "MM:SS" 형식으로도 표시
- **해상도** (width × height)
- **FPS** (r_frame_rate)
- **코덱** (codec_name)
- **파일 크기** (size) → MB 단위로 변환

### Phase 2: 분석 모드 결정

사용자가 모드를 지정하지 않았으면, 영상 길이에 따라 자동 선택:

| 영상 길이 | 추천 모드 | 설정 |
|-----------|----------|------|
| ~30초 | **모드 B** | 2초 간격 캡처 |
| 30초~5분 | **모드 A** | 장면 감지, threshold 0.3 |
| 5분~30분 | **모드 A** | 장면 감지, threshold 0.4 |
| 30분 이상 | **모드 C** | 사용자에게 구간 질문 |

30분 이상일 때는 AskUserQuestion으로 분석할 구간을 물어본다.

### Phase 3: 프레임 추출

임시 디렉토리 생성:
```bash
mkdir -p "/tmp/video-analyzer-$(date +%s)"
```
> Windows에서는 `$TEMP/video-analyzer-TIMESTAMP` 사용

#### 모드 A: 장면 변화 감지 (추천)

화면이 바뀌는 순간만 캡처한다. 그러니까 컷이 바뀌거나 화면 전환이 일어날 때만 이미지를 뽑는 것.

```bash
ffmpeg -i "<FILE_PATH>" -vf "select='gt(scene,THRESHOLD)',showinfo" -vsync vfr "<OUT_DIR>/scene_%04d.png" 2>&1
```

- 기본 threshold: 0.3
- 추출된 프레임이 3개 미만이면 → threshold를 0.2로 낮춰서 재시도
- 추출된 프레임이 30개 초과이면 → threshold를 0.5로 높여서 재시도
- showinfo 출력에서 `pts_time:` 값을 파싱하여 각 프레임의 타임스탬프 기록

#### 모드 B: 일정 간격 캡처

N초마다 1프레임 캡처. 짧은 영상에 적합.

```bash
ffmpeg -i "<FILE_PATH>" -vf "fps=1/INTERVAL" "<OUT_DIR>/frame_%04d.png"
```

- 기본 간격: 영상 길이에 따라 자동 계산 (목표 10~20프레임)
- 타임스탬프: `프레임번호 × 간격`으로 계산

#### 모드 C: 구간 지정

특정 시간대만 캡처. 긴 영상의 일부만 볼 때 유용.

```bash
ffmpeg -i "<FILE_PATH>" -ss START -to END -vf "fps=1/INTERVAL" "<OUT_DIR>/clip_%04d.png"
```

- START/END: `HH:MM:SS` 또는 초 단위
- 간격: 구간 길이에 따라 자동 계산

### Phase 4: 이미지 분석

1. 추출된 PNG 파일 목록을 Glob으로 확인
2. **각 이미지를 Read 도구로 읽기** (Claude는 이미지를 시각적으로 인식 가능)
3. 각 프레임에 대해 분석:
   - 화면에 무엇이 보이는지
   - 텍스트가 있으면 읽기
   - 이전 프레임과의 차이점
   - 핵심 정보/행동/변화

**중요**: 프레임이 20개 이상이면, 앞 5개 + 중간 5개 + 끝 5개 = 15개만 분석하고 나머지는 건너뛴다. 이유: 컨텍스트 절약.

### Phase 5: 결과 출력

아래 형식으로 출력:

```markdown
## 영상 분석 결과

### 기본 정보
- **파일**: 파일명
- **길이**: MM:SS (X초)
- **해상도**: WxH
- **FPS**: N
- **분석 모드**: A/B/C (설정값)
- **추출 프레임**: N개 (분석: M개)

### 장면별 분석

| # | 시간 | 설명 |
|---|------|------|
| 1 | 0:00 | 첫 장면 설명 |
| 2 | 0:15 | 두 번째 장면 설명 |
| ... | ... | ... |

### 전체 요약
영상의 전체 내용을 2~3문장으로 요약.
- 핵심 주제/내용
- 주요 장면 전환
- 특이사항 (텍스트, 로고, 사람 등)
```

### Phase 6: 정리

분석 완료 후 AskUserQuestion으로 물어본다:

> "추출된 이미지 N개를 삭제할까요?"
> - 삭제 (추천)
> - 유지 (나중에 직접 확인)

삭제 선택 시:
```bash
rm -rf "<OUT_DIR>"
```

## 에러 처리

| 상황 | 대응 |
|------|------|
| 파일 없음 | "파일을 찾을 수 없습니다: <경로>" 출력 후 중단 |
| ffmpeg 없음 | `winget install --id Gyan.FFmpeg -e` 안내 |
| 지원 안 되는 형식 | ffprobe 에러 메시지 전달 + "MP4/MKV/AVI/MOV 형식을 지원합니다" |
| 장면 감지 0개 | threshold 0.1까지 낮추고, 그래도 0이면 모드 B(5초 간격)로 폴백 |
| 프레임 추출 실패 | ffmpeg 에러 로그 출력 + 다른 모드 시도 권유 |

## 참고

- ffmpeg showinfo 필터의 `pts_time` 파싱으로 정확한 타임스탬프 획득
- Windows 경로: 백슬래시(`\`)를 슬래시(`/`)로 변환하거나 큰따옴표로 감싸기
- 대용량 영상(1GB+): 모드 C로 구간 분할 권장
- 한글 파일명: ffmpeg에서 UTF-8 처리되므로 큰따옴표로 감싸면 정상 동작
