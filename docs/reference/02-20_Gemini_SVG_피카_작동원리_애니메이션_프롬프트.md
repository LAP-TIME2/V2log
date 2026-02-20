# Gemini 3.1 Pro — 피카(Fica) 피트니스 카운터 작동 원리 SVG 애니메이션 프롬프트

## 사용법

1. `aistudio.google.com` → 모델: **gemini-3.1-pro** 선택
2. 아래 프롬프트를 통째로 복사 → 붙여넣기 → 전송
3. 결과 HTML 코드를 `fica_how_it_works.html`로 저장 → 브라우저에서 열기

---

## 프롬프트 (아래 전체를 복사)

```
Create a single HTML file with an animated infographic explaining how the "Fica (피카)" smart fitness counter system works on a gym leg press machine. Use HTML5 Canvas for all drawing and animation. No external dependencies. Korean text.

## IMPORTANT
- Draw everything on a single HTML5 Canvas element (full viewport)
- All illustrations drawn with Canvas 2D API (ctx.fillRect, ctx.arc, ctx.bezierCurveTo, etc.)
- Smooth animations using requestAnimationFrame
- DO NOT use images, SVG files, or external assets — draw everything procedurally
- Clean, modern flat design style like Apple product presentations
- Make it feel like an animated keynote slide

## LAYOUT

The canvas shows a SIDE VIEW illustration of a 45-degree plate-loaded leg press machine in the center. Around it, animated callouts and data flows explain the system.

At the bottom: 6 step buttons. Clicking each shows that step's animation.
At the top: "피카(Fica) — 이렇게 작동합니다" title.

```
┌────────────────────────────────────────────────────────┐
│  피카(Fica) — 이렇게 작동합니다          [Auto Play ▶]  │
├────────────────────────────────────────────────────────┤
│                                                        │
│     ┌─ Callout ─┐       MACHINE          ┌─ Data ──┐  │
│     │ 설명 박스  │      ILLUSTRATION      │ 데이터  │  │
│     └───────────┘       (side view)       │ 시각화  │  │
│                                           └─────────┘  │
│                                                        │
│  ┌─ Info Panel ──────────────────────────────────────┐  │
│  │  현재 Step 설명 텍스트                            │  │
│  └───────────────────────────────────────────────────┘  │
│  [ 1.NFC탭 ] [ 2.AI추천 ] [ 3.입력 ] [ 4.운동 ] [ 5.휴식 ] [ 6.완료 ] │
└────────────────────────────────────────────────────────┘
```

## MACHINE ILLUSTRATION (Canvas 2D side view)

Draw a simplified but recognizable 45-degree plate-loaded leg press from the side:

```
Reference shape (draw this with Canvas paths):

         ╱ ← 45° rail (두꺼운 회색 선)
        ╱
       ╱ [슬레드] ← 원판이 실린 이동부 (진한 회색 사각형)
      ╱   ├─ [●●●] 원판 3장 (어두운 원형 디스크)
     ╱    └─ [★] IMU 센서 (시안색 작은 사각형, 글로우)
    ╱
   ╱─── [발판] (사용자가 발로 밂)
  ╱
 ╱
╱_________
│ [좌석]  │ ← 사용자 앉는 곳 (어두운 쿠션)
│_________|
═══════════ (바닥 프레임)
    │
    [📱NFC] ← NFC 태그 (프레임에 부착)
    [🖥️컨트롤러] ← 스마트 컨트롤러 (프레임에 부착)
```

Colors:
- Frame: #555566
- Rails: #888899
- Sled/plates: #3a3a3a
- Seat padding: #2a2a2a
- IMU sensor: #00d4ff (cyan, with glow)
- NFC tag: white circle with green accent
- Controller: dark gray with cyan screen
- Background: #0a0a1a (dark)
- Accent: #00d4ff (cyan)
- Secondary accent: #ff6b35 (orange)

## STEP ANIMATIONS

### Step 1: "NFC 탭 — 기구 자동 인식" (NFC Tap)

Animation:
1. A phone icon slides in from the left toward the NFC tag on the frame
2. On contact: green ripple rings expand outward from NFC tag (3 expanding circles, fading)
3. A popup bubble appears near the phone: "레그프레스 인식됨 ✓"
4. Below the popup: "지난번: 100kg × 10회 × 4세트"
5. Dotted line connects phone to the app icon

Callout box (left side):
"스마트폰으로 기구 옆 NFC 태그를 탭하면
앱이 자동으로 기구를 인식하고
이전 운동 기록을 불러옵니다."

Draw animated arrow: Phone → NFC tag → App data

### Step 2: "AI 추천 — 점진적 과부하" (AI Recommendation)

Animation:
1. The controller screen lights up cyan
2. On the controller screen, text appears: "추천: 105kg × 8회"
3. AI brain icon pulses near the controller
4. Data flow particles (small cyan dots) stream from a "cloud/AI" icon down to the controller
5. A comparison box appears:
   Left: "PT 트레이너 월 84만원" (crossed out, red)
   Right: "피카 AI 월 9,900원" (highlighted, cyan)

Callout box:
"AI가 과거 운동 데이터를 분석하여
점진적 과부하 원칙에 따라
오늘의 무게와 횟수를 자동 추천합니다."

### Step 3: "무게 입력 — 1초" (Weight Input)

Animation:
1. A finger icon appears and taps the controller
2. Controller screen flashes: "[105kg] ✓"
3. Blue dotted line with moving particles flows from controller to phone (BLE signal)
4. Phone screen updates: "105kg 입력 완료"
5. Timer icon shows "1초" emphasizing speed

Callout box:
"컨트롤러의 프리셋 버튼을 한 번 누르면
무게가 즉시 입력됩니다.
폰을 꺼낼 필요가 없습니다."

Key visual: Big "1초" text with emphasis animation (scale up then settle)

### Step 4: "운동 — 자동 카운팅" (THE MAIN ANIMATION)

This is the most important step. Show the counting mechanism clearly:

Animation sequence (loops 5 times):
1. The sled on the machine illustration MOVES up along the 45° rail (user pushing)
2. The IMU sensor (cyan box on sled) moves WITH the sled
3. As the sled moves, show a SINE WAVE graph building in real-time on the right side
   - X-axis: time, Y-axis: acceleration
   - The wave peaks when sled changes direction (top and bottom)
4. When sled reaches the top and comes back down = 1 rep completed
5. The IMU sensor FLASHES bright cyan at each rep completion
6. A large counter in the top-right increments: "1회" → "2회" → "3회" → "4회" → "5회"
7. Small text near the sensor: "가속도 감지중..."

After 5 reps, animation stops.

Callout box:
"슬레드에 부착된 IMU 센서(ICM-45686)가
움직임의 가속도를 실시간 감지합니다.
올라갔다 → 내려왔다 = 1회 자동 카운팅
정확도: 93~96%"

Visual elements:
- Sine wave graph labeled "레일축 가속도 (m/s²)"
- Arrow showing "올라감 ↗" and "내려옴 ↘" on the machine
- Sensor glow intensifies during movement

### Step 5: "세트 완료 — 휴식 타이머" (Rest Timer)

Animation:
1. Sled returns to rest position (bottom)
2. Checkmark animation: "✓ 5회 완료!"
3. Controller screen changes to orange, shows timer: "01:30"
4. Timer counts down each second: 01:30 → 01:29 → 01:28 → ...
5. Progress bar below the timer shrinks as time passes
6. At bottom of screen: "총 기구 사용시간: 2:15 / 13:00" with a progress bar

Callout box:
"세트가 끝나면 자동으로 휴식 타이머가 시작됩니다.
설정한 쉬는시간이 지나면 진동으로 알려줍니다.
NFC 기반 기구 사용시간 관리로
불필요한 기구 점유를 방지합니다."

### Step 6: "운동 완료 — 자동 저장 + 마일리지" (Complete)

Animation:
1. All components glow green briefly (success)
2. A summary card slides in from the right:
   ```
   ┌─ 오늘의 기록 ──────────┐
   │ 레그프레스              │
   │ 105kg × 5회 × 4세트    │
   │ 총 볼륨: 2,100kg       │
   │ 1RM 추정: 142kg (↑5kg) │
   │ ───────────────────     │
   │ 🏆 마일리지 +500P 적립  │
   │ 보험료 할인 누적 중...  │
   └─────────────────────────┘
   ```
3. Confetti particles (small colorful dots) fall briefly
4. Data flow animation: phone → cloud (data saved)

Callout box:
"모든 데이터는 자동으로 저장됩니다.
AI가 다음 세션의 추천을 준비하고
운동 마일리지가 적립되어
보험료 할인 등 실질적 혜택을 받습니다."

## DESIGN STYLE

- Dark background: linear gradient from #0a0a1a to #12122a
- All text: white (#ffffff) or light gray (#aaaaaa)
- Primary accent: cyan #00d4ff (Fica brand color) — used for sensor, highlights, active elements
- Secondary accent: orange #ff6b35 — used for timer, warnings, CTA
- Success color: green #00ff88
- Font: system sans-serif, clean and modern
- Info panel: semi-transparent dark background with rounded corners and subtle border
- Step buttons: rounded rectangles, active one has cyan background
- All animations should be smooth (ease-in-out transitions)
- Callout boxes: appear with fade-in + slight slide-up animation
- Use subtle shadows and glows (ctx.shadowBlur) for depth

## ADDITIONAL FEATURES

1. **Auto-play button**: Top right corner. When clicked, automatically advances through all 6 steps with 5-second intervals.

2. **Animated data flow**: When showing BLE/WiFi connections, use small moving dots along dotted lines (particle effect on path).

3. **Machine part labels**: In idle state (before any step is clicked), show labeled arrows pointing to each part of the machine: "가이드 레일 (45°)", "슬레드", "웨이트 원판", "풋 플레이트", "좌석", "IMU 센서", "NFC 태그", "컨트롤러"

4. **Responsive**: Canvas should fill the viewport and scale content proportionally.

5. **Smooth transitions**: When switching between steps, current animations fade out and new ones fade in (300ms transition).

Generate the COMPLETE HTML file. Make it visually polished and clearly explain the Fica system to someone who has never seen it before.
```

---

## 참고

### 프롬프트 설계 근거 (사업계획서 기반)

| 요소 | 실제 사양 | 애니메이션 반영 |
|------|----------|--------------|
| IMU 센서 | ICM-45686, 40×30×10mm, 자석 부착 | 슬레드 측면에 시안색 센서 표시 |
| NFC 태그 | NTAG213, 500원/개 | 프레임에 흰색 원형, 탭 시 녹색 리플 |
| 컨트롤러 | 80×50×15mm, OLED SSD1306, BLE | 프레임에 어두운 박스, 화면 텍스트 변경 |
| 무게 입력 | 프리셋 버튼 1초 | Step 3 "1초" 강조 애니메이션 |
| 자동 카운팅 | Peak Detection + Velocity Gate, 93~96% | Step 4 사인파 + 카운터 |
| 휴식 타이머 | 사용자 설정 쉬는시간 | Step 5 카운트다운 |
| 기구 사용시간 | 총 사용시간 = 운동+휴식+여유 | Step 5 하단 표시 |
| AI 추천 | 점진적 과부하 자동 추천 | Step 2 비용 비교 |
| 마일리지 | 보험사 마일리지 + 인앱 포인트 | Step 6 적립 표시 |

### 만약 결과가 부족하면

**2단계 나눠서:**
1차: "45도 레그프레스 기구 측면도 + 센서 3종 위치를 Canvas로 그려줘. 라벨 화살표 포함."
2차: "여기에 6단계 Step별 애니메이션 추가해줘. Step 4에서 슬레드가 실제로 움직이고 카운터가 올라가게."
