# Gemini 3.1 Pro Preview — 피카(Fica) 레그프레스 3D 인터랙티브 데모 프롬프트

## 사용법

### 1단계: AI Studio 접속
1. 브라우저에서 `aistudio.google.com/prompts/new_chat` 열기
2. 모델: `gemini-3.1-pro-preview` 선택
3. 아래 프롬프트를 **통째로** 복사해서 붙여넣기
4. 전송

### 2단계: 결과물 실행
- Gemini가 HTML 파일 하나를 통째로 생성해줌
- 그 코드를 복사해서 `fica_demo.html` 파일로 저장
- 브라우저에서 열기 (더블클릭)
- 또는 AI Studio의 "Preview" 기능으로 바로 확인

### 3단계: 조작법
- 마우스 드래그: 3D 회전
- 스크롤: 줌 인/아웃
- 하단 버튼들로 단계별 시뮬레이션 진행

---

## 프롬프트 (아래 전체를 복사)

```
Create a single self-contained HTML file with an interactive 3D demo of the "Fica (피카)" smart fitness system applied to a Leg Press machine. Use Three.js (CDN import) with OrbitControls. No external assets - everything procedurally generated in code.

## CRITICAL REQUIREMENTS
- Single HTML file, no external dependencies except Three.js CDN
- Korean + English labels
- Responsive design
- Smooth animations
- Must run in any modern browser by just opening the HTML file

## WHAT TO BUILD

### 3D Scene: Leg Press Machine + Fica Smart System

**1. Leg Press Machine (simplified but recognizable)**
- Seat: angled backrest (~45°) with padding (dark gray)
- Foot plate: large rectangular plate where user pushes (silver/metal)
- Weight stack: vertical column of rectangular weight plates on the side (dark iron color)
- Guide rails: 2 parallel rails connecting foot plate to frame
- Frame: steel structure (medium gray)
- The foot plate should be ANIMATABLE - slides up and down along the rails to simulate leg press motion

**2. Fica IMU Sensor (피카 모션 센서) — HIGHLIGHT with glow**
- Small box: 40×30×10mm, rounded corners, matte white with "Fica" text
- Attached position: TOP of the weight stack (where it moves up/down with the weights)
- Neodymium magnet attachment indicator (small silver circle on bottom)
- Subtle pulsing GLOW effect (cyan/blue) to draw attention
- Label: "피카 모션 센서 (ICM-45686)" with line pointing to it

**3. NFC Tag (NFC 태그)**
- Small circular sticker: ~25mm diameter, thin
- Attached position: on the frame near where user sits, easily reachable
- Color: white with NFC symbol (📡 or wavy lines)
- Label: "NFC 태그 (NTAG213, 500원)"

**4. Fica Smart Controller (피카 스마트 컨트롤러)**
- Small device: 80×50×15mm, rounded rectangle, dark gray body
- Attached position: on the frame at eye level when seated (magnetic mount)
- Has a small OLED screen area (black rectangle on front face)
- The OLED content changes based on current demo step
- Label: "피카 컨트롤러 (BLE + OLED)"

**5. Smartphone (optional, floating nearby)**
- Simple phone shape showing app screen
- Shows "V2log" app interface mockup

### ANIMATION SEQUENCE — Step-by-step demo

Create a step indicator at the bottom of the screen with buttons: [Step 1] [Step 2] [Step 3] [Step 4] [Step 5] [Step 6]
Each step shows different animations and info panel text.

**Step 1: "NFC 탭 — 기구 자동 인식" (NFC Tap)**
- Animation: Phone model moves toward NFC tag, touch, ripple effect
- NFC tag glows green briefly
- Controller OLED shows: "레그프레스 인식됨 ✓"
- Info panel: "스마트폰으로 기구의 NFC 태그를 탭하면, 앱이 자동으로 기구를 인식합니다."
- Popup on phone: "레그프레스 | 지난번: 100kg × 10회 × 4세트"

**Step 2: "이전 기록 + AI 추천" (Previous Record + AI Recommendation)**
- Controller OLED shows: "지난번: 100kg × 10회\n추천: 105kg × 8회"
- Phone shows AI recommendation card
- Info panel: "AI가 지난 운동 데이터를 분석하여 점진적 과부하를 자동 추천합니다. (PT 비용 월 84만원 → 피카 AI 월 9,900원)"
- Highlight the controller with a soft glow

**Step 3: "무게 입력 — 1초" (Weight Input)**
- Animation: A finger icon taps the controller
- Controller OLED shows: "[105kg] ✓ 입력 완료"
- BLE signal animation: dotted line from controller to phone (blue particles)
- Info panel: "컨트롤러에서 프리셋 버튼 한 번으로 무게 입력 완료. 폰을 꺼낼 필요 없습니다."

**Step 4: "운동 시작 — 자동 카운팅" (Exercise — Auto Counting)**
- THE MAIN ANIMATION:
  - Foot plate moves up and down rhythmically (simulating leg press reps)
  - Weight stack moves up and down correspondingly
  - The Fica sensor on the weight stack moves WITH the weights
  - Each rep cycle: sensor PULSES cyan glow
  - Controller OLED counts: "1회... 2회... 3회..." updating each rep
  - Show accelerometer wave visualization near the sensor (sine wave)
- Repeat for 5 reps then auto-stop
- Info panel: "기구에 부착된 IMU 센서가 가속도를 감지하여 자동으로 횟수를 카운팅합니다. 정확도: 85~98%"

**Step 5: "세트 완료 — 휴식 타이머" (Set Complete — Rest Timer)**
- Animation stops, foot plate returns to rest position
- Controller OLED shows: "5회 완료! ✓\n휴식: 01:30"
- Timer counts down on controller: 01:30 → 01:29 → 01:28...
- Info panel: "세트 완료! 자동으로 휴식 타이머가 시작됩니다. 설정된 쉬는시간이 지나면 진동으로 알려줍니다."
- Also show: "총 기구 사용시간: 2:15 / 13:00 (기구 사용시간 컨트롤)"

**Step 6: "운동 완료 — AI 분석 결과" (Workout Complete — AI Analysis)**
- Phone shows summary screen:
  - "레그프레스: 105kg × 5회 × 4세트"
  - "총 볼륨: 2,100kg"
  - "1RM 추정: 142kg (↑5kg)"
  - "마일리지: +500P 적립"
- Info panel: "모든 데이터가 자동 저장됩니다. AI가 다음 세션 추천을 준비하고, 운동 마일리지가 적립됩니다."

### UI LAYOUT

```
┌─────────────────────────────────────────────────┐
│  [Fica 피카] Interactive Demo    [🔄 Reset] [📷] │  ← Header
├─────────────────────────────────────────────────┤
│                                                 │
│                                                 │
│              3D VIEWPORT                        │  ← Three.js Canvas
│           (Leg Press + Sensors)                  │
│                                                 │
│                                                 │
├─────────────────────────────────────────────────┤
│ ┌─ Info Panel ─────────────────────────────────┐│
│ │ Step 1: NFC 탭 — 기구 자동 인식              ││  ← Description
│ │ 스마트폰으로 NFC 태그를 탭하면...             ││
│ └──────────────────────────────────────────────┘│
│ [1.NFC탭] [2.AI추천] [3.무게입력] [4.운동] [5.휴식] [6.완료] │  ← Step buttons
└─────────────────────────────────────────────────┘
```

### STYLE
- Background: dark gradient (#0a0a1a to #1a1a2e)
- Accent color: cyan (#00d4ff) for Fica brand
- Secondary: warm orange (#ff6b35) for highlights
- Font: system sans-serif
- Glass-morphism style panels (semi-transparent, blur backdrop)
- Professional, clean, startup pitch deck quality

### LIGHTING
- Ambient light (soft, warm)
- One main directional light (top-right, casting shadows)
- Point light near the Fica sensor (cyan, subtle)
- Shadow map enabled

### CAMERA
- Initial position: slightly above and to the right, looking at the machine
- OrbitControls: rotate, zoom, pan enabled
- Auto-rotate slowly when idle
- Smooth camera transition when changing steps

### LABELS
Use CSS2DRenderer or HTML overlay for labels pointing to:
1. 피카 모션 센서 (IMU) — on weight stack
2. NFC 태그 — on frame
3. 피카 컨트롤러 — on frame at eye level
4. 가이드 레일 — the rails
5. 웨이트 스택 — the weights
6. 풋 플레이트 — the foot plate

Generate the COMPLETE HTML file. Make it production-quality, visually impressive, and clearly demonstrate the Fica smart fitness system workflow.
```

---

## 참고: 프롬프트가 너무 길어서 잘릴 경우

Gemini AI Studio에서 한 번에 안 되면 2단계로 나눠서:

**1차 프롬프트**: "레그프레스 3D 모델 + 피카 센서 부착 위치 시각화" (3D 모델링만)
**2차 프롬프트**: "Step별 애니메이션 시퀀스 추가해줘" (인터랙션 추가)

---

## 프롬프트 설계 근거

| 요소 | 실제 피카 스펙 | 3D 데모 반영 |
|------|-------------|------------|
| IMU 센서 | ICM-45686, 40×30×10mm | 웨이트 스택 상단에 자석 부착 |
| NFC 태그 | NTAG213, 500원/개 | 프레임에 스티커형 부착 |
| 컨트롤러 | 80×50×15mm, OLED SSD1306 | 프레임 눈높이에 자석 부착 |
| 무게 입력 | 프리셋 버튼 1초 | Step 3 애니메이션 |
| 자동 카운팅 | Peak Detection + Velocity Gate | Step 4 가속도 파형 시각화 |
| 휴식 타이머 | 사용자 설정 쉬는시간 | Step 5 카운트다운 |
| 기구 사용시간 | 총 사용시간 = 운동+휴식+여유 | Step 5 하단 표시 |
| AI 추천 | 점진적 과부하 자동 추천 | Step 2, 6 |
| 마일리지 | 보험사 마일리지 + 인앱 포인트 | Step 6 적립 표시 |
