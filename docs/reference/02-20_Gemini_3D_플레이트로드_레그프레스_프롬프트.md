# Gemini — 피카(Fica) 45° 플레이트 로드 레그프레스 3D 데모 프롬프트

## 사용법

### 1단계: AI Studio 접속
1. `aistudio.google.com/prompts/new_chat` 열기
2. 모델: `gemini-2.5-pro` 선택 (3D 코드 생성 능력 최고)
3. 아래 프롬프트를 **통째로** 복사해서 붙여넣기
4. 전송

### 2단계: 결과물 실행
- Gemini가 HTML 파일 하나를 생성해줌
- 그 코드를 복사해서 `fica_leg_press_demo.html` 파일로 저장
- 브라우저에서 열기 (더블클릭)

### 3단계: 조작법
- 마우스 드래그: 3D 회전
- 스크롤: 줌 인/아웃
- 하단 버튼으로 Step 1~6 전환

---

## 프롬프트 (아래 전체를 복사)

```
You are a Three.js expert. Create a SINGLE self-contained HTML file with a real-time interactive 3D simulation.

CRITICAL: This MUST be actual 3D using Three.js WebGL — NOT a 2D mockup, NOT CSS illustrations, NOT SVG. I need a real 3D scene with OrbitControls where I can rotate the camera around the machine with my mouse.

## WHAT TO BUILD

A 3D interactive demo showing how the "Fica (피카)" smart fitness IoT system works on a **45-degree plate-loaded leg press machine**. The demo has 6 steps the user clicks through.

## THREE.JS SETUP (MUST USE)

```javascript
import * as THREE from 'https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.js';
import { OrbitControls } from 'https://cdn.jsdelivr.net/npm/three@0.164.1/examples/jsm/controls/OrbitControls.js';
```

Use `<script type="importmap">` for the imports. Set up:
- Scene with dark background (0x0a0a1a)
- PerspectiveCamera
- WebGLRenderer with antialiasing and shadows
- OrbitControls with damping and auto-rotate
- Ambient light + directional light with shadows
- A subtle grid on the ground

## 3D MODEL: 45-Degree Plate-Loaded Leg Press

Build the machine using basic Three.js geometries (BoxGeometry, CylinderGeometry, etc). Make it recognizable as a real 45-degree leg press.

### Structure (all measurements in Three.js units):

**A-Frame Base (stationary):**
- Two floor beams (BoxGeometry 0.15 x 0.15 x 4) running front-to-back
- Two vertical pillars (height ~3) at the back
- Cross beams connecting them
- Material: dark steel gray (0x555566), metalness 0.7

**Two Guide Rails at 45 degrees:**
- CylinderGeometry, length ~5, radius 0.04
- Rotated 45 degrees from horizontal (rotation.z = -Math.PI/4)
- Chrome material (0xaaaaaa, metalness 0.9, roughness 0.2)
- Small safety catch notches along the rails (tiny orange cylinders)

**Seat and Backrest (stationary, at the bottom):**
- Angled backrest pad (~30 degrees)
- Seat cushion
- Dark padding material (0x2a2a2a)

**Sled/Carriage (THIS MOVES — the main animated part):**
Create a THREE.Group called `sledGroup` containing ALL of the following:
- Sled frame: rectangular plate (~1.2 x 0.8)
- Footplate: at the bottom of the sled, slightly angled, with orange grip edges
- Two plate-loading pegs: steel rods sticking out from each side (length 0.4)
- Weight plates on the pegs: each side has 2x large discs (20kg, diameter 0.45, thickness 0.03) + 1x smaller disc (10kg, diameter 0.35, thickness 0.025). Dark iron color.
- The Fica IMU sensor (see below) — attached to the sled side frame

The ENTIRE sledGroup slides up and down along the 45-degree rails. Movement formula:
```
sledGroup.position.x = restX + motion * distance * Math.cos(Math.PI/4);
sledGroup.position.y = restY + motion * distance * Math.sin(Math.PI/4);
```

## FICA SMART COMPONENTS (3 devices)

**1. IMU Motion Sensor (피카 모션 센서)**
- Small white box (0.25 x 0.06 x 0.18) with rounded edges
- ATTACHED TO THE SLED (child of sledGroup) — it moves WITH the sled
- Position: on the inner side of the sled frame, below the plate pegs
- Pulsing cyan glow effect (THREE.MeshBasicMaterial, transparent, opacity oscillating)
- A cyan point light near it

**2. NFC Tag (NFC 태그)**
- Small white disc (radius 0.08, height 0.01)
- FIXED on the A-frame pillar, near the seat, at hip height
- Concentric ring pattern (3 torus rings) representing NFC symbol
- Green glow when activated (Step 1)

**3. Smart Controller (피카 컨트롤러)**
- Dark box (0.4 x 0.25 x 0.08) with a black OLED screen rectangle on front
- FIXED on the A-frame pillar, at eye level when seated
- 3 small button circles below the screen
- Screen emissive color changes per step

## 6-STEP ANIMATION SEQUENCE

Create step buttons at the bottom: [1.NFC탭] [2.AI추천] [3.무게입력] [4.운동] [5.휴식] [6.완료]
Each step has: title, description text in an info panel, and specific animations.

**Step 1: "NFC 탭 — 기구 자동 인식"**
- A phone model (simple box) floats toward the NFC tag and touches it
- NFC tag glows green on contact
- Info: "스마트폰으로 기구의 NFC 태그를 탭하면 앱이 자동으로 기구를 인식합니다."

**Step 2: "AI 추천 — 점진적 과부하"**
- Controller screen pulses cyan
- Info: "AI가 지난 운동 데이터를 분석하여 점진적 과부하를 자동 추천합니다. PT 1회 5~7만원 → 피카 AI 월 9,900원"

**Step 3: "무게 입력 — 1초"**
- Controller screen flashes green briefly
- Blue particles fly from controller to phone (BLE signal visualization)
- Info: "컨트롤러 버튼 한 번으로 무게 입력 완료. 폰을 꺼낼 필요 없습니다."

**Step 4: "운동 — 자동 카운팅" (MAIN ANIMATION)**
- The sledGroup moves up and down along the 45-degree rails, 5 reps
- Each rep: ~2 seconds cycle, smooth sinusoidal motion
- The sled, plates, footplate, AND sensor all move together (they're in sledGroup)
- Weight plates jitter subtly during movement (plate rattle effect)
- IMU sensor pulses bright cyan on each rep completion
- A rep counter appears: large number "1", "2", "3"... updating each rep
- Show a small accelerometer waveform visualization (canvas element)
- Info: "IMU 센서(ICM-45686)가 슬레드의 가속도를 감지하여 자동으로 횟수를 카운팅합니다. 정확도: 93~96%"

**Step 5: "세트 완료 — 휴식 타이머"**
- Sled returns to rest position
- Controller glows orange
- Timer counts down: 01:30 → 01:29 → 01:28...
- Info: "세트 완료! 휴식 타이머가 자동 시작됩니다. 총 기구 사용시간: 2:15 / 13:00"

**Step 6: "운동 완료 — AI 분석"**
- Everything glows green (success)
- Summary panel appears with stats: "100kg × 5회 × 4세트, 총 볼륨: 2,000kg, 1RM 추정: 135kg, 마일리지: +500P"
- Info: "모든 데이터가 자동 저장됩니다. AI가 다음 세션을 준비하고 마일리지가 적립됩니다."

## UI STYLING

- Background: linear-gradient(135deg, #0a0a1a, #1a1a2e)
- Accent color: cyan #00d4ff
- Secondary: orange #ff6b35
- Info panel: semi-transparent dark with backdrop-filter blur (glass morphism)
- Step buttons: rounded, active one has cyan border and glow
- Font: system sans-serif, white text
- Rep counter: huge bold number, cyan with text-shadow glow

## LABELS

Use HTML div overlays positioned with JavaScript (project 3D coords to screen coords each frame):
1. "피카 모션 센서 (ICM-45686)" → pointing to sensor on sled
2. "NFC 태그" → pointing to NFC on frame
3. "피카 컨트롤러" → pointing to controller
4. "45° 가이드 레일" → pointing to a rail
5. "웨이트 원판" → pointing to plates
6. "슬레드" → pointing to sled frame

## CAMERA

- Initial: position(8, 5, 8) looking at (0, 2, 0)
- Auto-rotate slowly (speed 0.5)
- Smooth camera transitions when changing steps (lerp to target positions)
- Step 1: zoom to NFC tag area
- Step 4: wide view to see full machine movement

## IMPORTANT CONSTRAINTS

- SINGLE HTML file, absolutely NO external files except Three.js CDN
- MUST use WebGL 3D rendering — this is non-negotiable
- All geometry procedurally created with Three.js primitives
- Responsive (fills viewport)
- Works by just opening the HTML file in Chrome/Edge
- Korean text in the UI, English in code comments
```

---

## 프롬프트 설계 포인트

| 이전 실패 원인 | 이번 개선 |
|--------------|---------|
| "Create a single HTML file" → Gemini가 CSS 2D로 도망 | **"MUST be actual 3D using Three.js WebGL — NOT a 2D mockup"** 강조 |
| Three.js import 방법 미지정 | **import 코드 직접 제공** |
| 슬레드 움직임 공식 미지정 | **cos(45°)/sin(45°) 공식 직접 제공** |
| sledGroup 개념 없음 | **"Create a THREE.Group called sledGroup"** 명시 |
| 기구 구조 모호 | **각 파트별 geometry 타입 + 수치 명시** |

---

## 만약 잘 안 되면

Gemini가 또 2D로 나오면, 프롬프트를 2단계로 나눠서:

**1차**: "Three.js로 45도 레그프레스 3D 모델만 만들어줘. OrbitControls로 회전 가능하게. 슬레드가 45도 레일 위아래로 움직이는 애니메이션."

**2차**: "여기에 피카 센서 3종(IMU, NFC, 컨트롤러) 추가하고, 6단계 Step 버튼 + Info 패널 추가해줘."
