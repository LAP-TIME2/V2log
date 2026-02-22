# Fica BLE GATT 프로토콜 스펙 v1.0

> **문서 버전**: v1.0
> **작성일**: 2026-02-21
> **대상 장치**: Fica 피트니스 카운터 (FC-001)
> **MCU**: Nordic Semiconductor nRF52840
> **BLE 버전**: Bluetooth 5.0 (BLE 전용)
> **바이트 순서**: 모든 다중 바이트 값은 **Little-Endian**

---

## 1. 개요

### 1.1 목적

본 문서는 Fica 피트니스 카운터 장치와 스마트폰 앱 간의 BLE 통신 프로토콜을 정의한다. GATT 기반의 커스텀 서비스 및 표준 서비스를 명세함으로써, 펌웨어 개발자와 앱 개발자가 동일한 인터페이스 계약을 바탕으로 독립적으로 개발할 수 있도록 한다.

그러니까 "센서와 앱이 어떤 형식으로 데이터를 주고받을지" 약속을 먼저 정해두는 문서이다.

### 1.2 적용 범위

| 항목 | 내용 |
|------|------|
| 장치명 | Fica 피트니스 카운터 (FC-001) |
| MCU | Nordic Semiconductor nRF52840 |
| BLE 버전 | Bluetooth 5.0 (BLE 전용, BR/EDR 미사용) |
| 역할 | 장치 = GATT Server (Peripheral), 앱 = GATT Client (Central) |
| 운영 환경 | 헬스장 (금속 기구 근접, 다중 BLE 기기 혼재) |

### 1.3 용어 정의

| 용어 | 설명 |
|------|------|
| GATT | Generic Attribute Profile. BLE 데이터 교환 프로토콜 |
| Service | 관련 Characteristic의 논리적 집합 |
| Characteristic | 단일 데이터 포인트. 속성에 따라 읽기/쓰기/알림 가능 |
| Notify | 서버→클라이언트 값 변경 푸시 (ACK 없음) |
| Indicate | 서버→클라이언트 값 변경 푸시 (ACK 필수) |
| CCCD | Client Characteristic Configuration Descriptor. Notify/Indicate 활성화 제어 |
| Little-Endian | 낮은 바이트가 낮은 주소에 저장. 본 명세의 모든 다중 바이트 값에 적용 |
| Rep | Repetition. 운동 1회 반복 동작 |
| Set | 연속된 Rep의 묶음. 세트 간 휴식 포함 |
| IMU | Inertial Measurement Unit. 가속도계 + 자이로스코프 센서 |

---

## 2. UUID 체계

### 2.1 Base UUID

```
FCA00000-0001-4000-8000-00805F9B34FB
```

RFC 4122 UUID v4 구조 준용. 상위 32비트(`FCA0XXXX`)에 Fica 식별자를 삽입하며, `XXXX` 위치가 각 서비스/Characteristic을 구분하는 16비트 코드이다.

### 2.2 UUID 생성 규칙

```
FCA0[CODE]-0001-4000-8000-00805F9B34FB
```

예: Rep Count의 short code `0001` → `FCA00001-0001-4000-8000-00805F9B34FB`

### 2.3 전체 UUID 매핑 테이블

#### 커스텀 서비스

| 이름 | Short Code | 128비트 UUID |
|------|-----------|--------------|
| Fica Fitness Service | 0000 | `FCA00000-0001-4000-8000-00805F9B34FB` |

#### 커스텀 Characteristic (12개)

| # | 이름 | Short Code | 128비트 UUID |
|---|------|-----------|--------------|
| 4.1 | Rep Count | 0001 | `FCA00001-0001-4000-8000-00805F9B34FB` |
| 4.2 | Weight | 0002 | `FCA00002-0001-4000-8000-00805F9B34FB` |
| 4.3 | Set Status | 0003 | `FCA00003-0001-4000-8000-00805F9B34FB` |
| 4.4 | Current Set | 0004 | `FCA00004-0001-4000-8000-00805F9B34FB` |
| 4.5 | Total Sets | 0005 | `FCA00005-0001-4000-8000-00805F9B34FB` |
| 4.6 | Rest Timer | 0006 | `FCA00006-0001-4000-8000-00805F9B34FB` |
| 4.7 | Rest Duration | 0007 | `FCA00007-0001-4000-8000-00805F9B34FB` |
| 4.8 | Session Data | 0008 | `FCA00008-0001-4000-8000-00805F9B34FB` |
| 4.9 | Equipment ID | 0009 | `FCA00009-0001-4000-8000-00805F9B34FB` |
| 4.10 | Command | 000A | `FCA0000A-0001-4000-8000-00805F9B34FB` |
| 4.11 | IMU Status | 000B | `FCA0000B-0001-4000-8000-00805F9B34FB` |
| 4.12 | Error Code | 000C | `FCA0000C-0001-4000-8000-00805F9B34FB` |

#### 표준 서비스 (Bluetooth SIG)

| 서비스 | UUID | Characteristic | UUID |
|--------|------|---------------|------|
| Battery Service | 0x180F | Battery Level | 0x2A19 |
| Device Information Service | 0x180A | Manufacturer Name | 0x2A29 |
| | | Model Number | 0x2A24 |
| | | Firmware Revision | 0x2A26 |
| | | Hardware Revision | 0x2A27 |

---

## 3. GATT 서비스 구조

### 3.1 Fica Fitness Service (Primary Service)

**UUID**: `FCA00000-0001-4000-8000-00805F9B34FB`

운동 세션의 전체 생명주기(NFC 탭 → 운동 → 휴식 → 완료)를 커버하는 12개 커스텀 Characteristic.

```
Fica Fitness Service [FCA00000]
├── Rep Count         [FCA00001] Notify
├── Weight            [FCA00002] Read / Write / Notify
├── Set Status        [FCA00003] Notify
├── Current Set       [FCA00004] Read / Notify
├── Total Sets        [FCA00005] Read / Write
├── Rest Timer        [FCA00006] Notify
├── Rest Duration     [FCA00007] Read / Write
├── Session Data      [FCA00008] Indicate
├── Equipment ID      [FCA00009] Read
├── Command           [FCA0000A] Write
├── IMU Status        [FCA0000B] Read / Notify
└── Error Code        [FCA0000C] Notify
```

**데이터 흐름**:
- **장치→앱** (Notify/Indicate): Rep Count, Set Status, Current Set, Rest Timer, Session Data, IMU Status, Error Code
- **앱→장치** (Write): Command, Weight, Total Sets, Rest Duration

### 3.2 Battery Service (0x180F)

```
Battery Service [0x180F]
└── Battery Level [0x2A19]  Read / Notify
      └── CCCD [0x2902]
```

- **Read**: 앱 연결 시 배터리 상태 즉시 확인
- **Notify**: 20%, 10%, 5% 임계값 도달 시 자동 알림

### 3.3 Device Information Service (0x180A)

```
Device Information Service [0x180A]
├── Manufacturer Name [0x2A29]  Read → "Fica"
├── Model Number      [0x2A24]  Read → "FC-001"
├── Firmware Revision [0x2A26]  Read → "X.Y.Z" (SemVer)
└── Hardware Revision [0x2A27]  Read → "A1" (PCB 리비전)
```

---

## 4. Characteristic 상세

> **공통 규칙**:
> - 모든 다중 바이트 값은 **Little-Endian**.
> - Notify/Indicate Characteristic은 **CCCD(0x2902)** 포함. 앱이 `0x0001`(Notify) 또는 `0x0002`(Indicate) 기록으로 활성화.
> - 모든 Write는 ATT_WRITE_REQ/RSP (확인 응답 있음).

### 4.1 Rep Count

| 항목 | 값 |
|------|-----|
| UUID | `FCA00001-0001-4000-8000-00805F9B34FB` |
| Properties | Notify |
| 크기 | 2바이트 (uint16 LE) |
| 범위 | 0 ~ 65535 |

```
Byte 0       Byte 1
[Rep_LSB]   [Rep_MSB]
```

현재 세트의 누적 횟수. 새 세트 시작 시 0 초기화. IMU가 동작 1회 감지마다 Notify.

**예시**: 12회 → `[0x0C, 0x00]`, 256회 → `[0x00, 0x01]`

### 4.2 Weight

| 항목 | 값 |
|------|-----|
| UUID | `FCA00002-0001-4000-8000-00805F9B34FB` |
| Properties | Read, Write, Notify |
| 크기 | 2바이트 (uint16 LE, ×0.1kg) |
| 유효 범위 | 0 ~ 5000 (0.0 ~ 500.0 kg) |

```
Byte 0          Byte 1
[Weight_LSB]   [Weight_MSB]
```

**단위 변환**: `실제 무게(kg) = raw × 0.1`

**예시**: 100.0kg → `[0xE8, 0x03]` (1000), 2.5kg → `[0x19, 0x00]` (25)

- **Write**: 앱에서 무게 설정 → LED 표시. 범위 초과 시 Error Code `0x08`.
- **Notify**: +/- 버튼으로 무게 변경 시.

### 4.3 Set Status

| 항목 | 값 |
|------|-----|
| UUID | `FCA00003-0001-4000-8000-00805F9B34FB` |
| Properties | Notify |
| 크기 | 1바이트 (uint8 enum) |

| 값 | 상수명 | 의미 |
|----|--------|------|
| `0x00` | IDLE | 대기 — 장치 켜짐, NFC 탭 대기 |
| `0x01` | READY | 준비 — NFC 완료, 운동 시작 대기 |
| `0x02` | EXERCISING | 운동중 — 세트 진행 |
| `0x03` | RESTING | 휴식 — 세트 간 타이머 |
| `0x04` | COMPLETE | 완료 — 전체 세트 달성 |
| `0x05` | ERROR | 에러 — Error Code 참조 |

**Notify 조건**: 상태 전이마다 즉시 발송.

### 4.4 Current Set

| 항목 | 값 |
|------|-----|
| UUID | `FCA00004-0001-4000-8000-00805F9B34FB` |
| Properties | Read, Notify |
| 크기 | 1바이트 (uint8) |
| 범위 | 1 ~ 10 |

현재 진행 중인 세트 번호. READY 진입 시 1로 초기화.

**Notify 조건**: 세트 번호 증가 시.

### 4.5 Total Sets

| 항목 | 값 |
|------|-----|
| UUID | `FCA00005-0001-4000-8000-00805F9B34FB` |
| Properties | Read, Write |
| 크기 | 1바이트 (uint8) |
| 범위 | 1 ~ 10, 기본값 3 |

앱에서 루틴 로드 시 Write. 세트 LED 10개 중 해당 개수만큼 점등. 범위 외 Write 시 ATT Error Response.

### 4.6 Rest Timer

| 항목 | 값 |
|------|-----|
| UUID | `FCA00006-0001-4000-8000-00805F9B34FB` |
| Properties | Notify |
| 크기 | 2바이트 (uint16 LE, 초) |
| 범위 | 0 ~ 65535 |

RESTING 진입 시 Rest Duration 값으로 초기화, 매초 1 감소. 0 도달 시 EXERCISING 전환.

**예시**: 90초 남음 → `[0x5A, 0x00]`

### 4.7 Rest Duration

| 항목 | 값 |
|------|-----|
| UUID | `FCA00007-0001-4000-8000-00805F9B34FB` |
| Properties | Read, Write |
| 크기 | 2바이트 (uint16 LE, 초) |
| 범위 | 10 ~ 600 (10초 ~ 10분), 기본값 90 |

다음 세트 완료 시 Rest Timer 초기값으로 사용. 세션 진행 중 Write 가능(다음 휴식부터 적용).

### 4.8 Session Data

| 항목 | 값 |
|------|-----|
| UUID | `FCA00008-0001-4000-8000-00805F9B34FB` |
| Properties | Indicate |
| 크기 | 가변 (3 + 세트수×6 바이트) |

세션 완료(COMPLETE) 시 전체 운동 데이터를 ACK 보장 방식으로 전송. 상세 패킷 구조는 §5 참조.

**Indicate 사용 이유**: 세션 데이터는 운동 기록의 핵심이므로 전달 보장 필수. Notify는 "보내고 끝"이지만 Indicate는 "받았다고 확인해줘야" 다음으로 넘어가는 방식.

### 4.9 Equipment ID

| 항목 | 값 |
|------|-----|
| UUID | `FCA00009-0001-4000-8000-00805F9B34FB` |
| Properties | Read |
| 크기 | 최대 36바이트 (UTF-8 UUID 문자열) |

NFC 태그에서 읽어온 기구 ID. 예: `"550e8400-e29b-41d4-a716-446655440000"`. NFC 탭 전에는 빈 문자열 반환.

### 4.10 Command

| 항목 | 값 |
|------|-----|
| UUID | `FCA0000A-0001-4000-8000-00805F9B34FB` |
| Properties | Write |
| 크기 | 1바이트 (uint8 command code) |

앱→장치 명령 전송. 상세 코드 테이블은 §6 참조. 잘못된 코드 수신 시 Error Code `0x07` Notify.

### 4.11 IMU Status

| 항목 | 값 |
|------|-----|
| UUID | `FCA0000B-0001-4000-8000-00805F9B34FB` |
| Properties | Read, Notify |
| 크기 | 1바이트 (uint8 enum) |

| 값 | 상수명 | 의미 |
|----|--------|------|
| `0x00` | NOT_READY | 부팅 중, 초기화 전 |
| `0x01` | CALIBRATING | 캘리브레이션 중 (~3초) |
| `0x02` | READY | 준비 완료 |
| `0x03` | ACTIVE | 운동 중 데이터 처리 |
| `0xFF` | ERROR | 초기화/통신 오류 |

### 4.12 Error Code

| 항목 | 값 |
|------|-----|
| UUID | `FCA0000C-0001-4000-8000-00805F9B34FB` |
| Properties | Notify |
| 크기 | 1바이트 (uint8 enum) |

| 값 | 상수명 | 앱 처리 |
|----|--------|---------|
| `0x00` | NO_ERROR | 이전 에러 해소 알림 |
| `0x01` | IMU_INIT_FAIL | "장치를 재시작해주세요" |
| `0x02` | IMU_FIFO_OVERFLOW | "잠시 후 다시 시도" |
| `0x03` | BLE_CONNECTION_LOST | 자동 재연결 실행 |
| `0x04` | BATTERY_CRITICAL | "배터리를 충전해주세요" (< 5%) |
| `0x05` | NFC_READ_FAIL | "NFC 태그를 다시 탭해주세요" |
| `0x06` | SESSION_DATA_CORRUPT | "수동 기록을 확인해주세요" |
| `0x07` | COMMAND_INVALID | 개발 디버깅용 |
| `0x08` | WEIGHT_OUT_OF_RANGE | "0~500kg 사이로 설정" |
| `0x09` | CALIBRATION_FAIL | "평평한 곳에서 재캘리브레이션" |

에러 해소 시 `0x00` Notify. 복수 에러 시 낮은 코드값 우선.

---

## 5. Session Data 패킷 구조

### 5.1 패킷 레이아웃

```
┌──────────────────────────────────────────────────────────────┐
│                    SESSION DATA PACKET                       │
├──────────┬──────────┬───────────────────────────────────────┤
│ Byte 0-1 │  Byte 2  │  Byte 3 ~ N                          │
│ session_ │ total_   │  per-set data (6 bytes × total_sets)  │
│ id       │ sets     │                                        │
│ uint16LE │ uint8    │                                        │
└──────────┴──────────┴───────────────────────────────────────┘

Per-Set 블록 (6 bytes):
┌─────────────────┬────────┬─────────────┬──────────────────┐
│ Byte 0-1        │ Byte 2 │ Byte 3      │ Byte 4-5         │
│ weight_x10      │ reps   │ rest_seconds│ duration_seconds │
│ uint16LE (×0.1) │ uint8  │ uint8       │ uint16LE         │
└─────────────────┴────────┴─────────────┴──────────────────┘
```

**패킷 크기**:

| 세트 수 | 크기 | iOS MTU (182B) 이내? |
|---------|------|---------------------|
| 1 | 9 bytes | ✅ |
| 4 | 27 bytes | ✅ |
| 10 (최대) | 63 bytes | ✅ |
| 20 (확장) | 123 bytes | ✅ |

### 5.2 바이트 상세

**헤더 (3 bytes)**:

| 바이트 | 필드 | 타입 | 범위 | 설명 |
|--------|------|------|------|------|
| 0-1 | session_id | uint16 LE | 0-65535 | 장치 로컬 시퀀스. 전원 리셋 시 0 초기화 |
| 2 | total_sets | uint8 | 1-20 | 완료된 세트 수 = Per-set 블록 개수 |

**Per-Set (6 bytes × total_sets)**:

| 오프셋 | 필드 | 타입 | 범위 | 단위 |
|--------|------|------|------|------|
| +0-1 | weight_x10 | uint16 LE | 0-9999 | ×0.1kg |
| +2 | reps | uint8 | 0-255 | 회 |
| +3 | rest_seconds | uint8 | 0-255 | 초 |
| +4-5 | duration_seconds | uint16 LE | 0-65535 | 초 |

**특수값**: `weight_x10=0` → 맨몸 운동, `rest_seconds=0xFF` → 255초 초과(capped).

### 5.3 인코딩 예제 (Dart)

```dart
import 'dart:typed_data';

/// Session Data 패킷 인코딩
Uint8List encodeSessionData({
  required int sessionId,
  required List<({double weightKg, int reps, int restSec, int durSec})> sets,
}) {
  final totalSets = sets.length;
  final bytes = ByteData(3 + totalSets * 6);

  // 헤더
  bytes.setUint16(0, sessionId, Endian.little);
  bytes.setUint8(2, totalSets);

  // Per-set
  for (int i = 0; i < totalSets; i++) {
    final base = 3 + i * 6;
    final s = sets[i];
    bytes.setUint16(base, (s.weightKg * 10).round(), Endian.little);
    bytes.setUint8(base + 2, s.reps);
    bytes.setUint8(base + 3, s.restSec.clamp(0, 255));
    bytes.setUint16(base + 4, s.durSec, Endian.little);
  }
  return bytes.buffer.asUint8List();
}

/// Session Data 패킷 디코딩
({int sessionId, List<({double weightKg, int reps, int restSec, int durSec})> sets})
    decodeSessionData(Uint8List raw) {
  final bd = ByteData.sublistView(raw);
  final sessionId = bd.getUint16(0, Endian.little);
  final totalSets = bd.getUint8(2);

  final sets = <({double weightKg, int reps, int restSec, int durSec})>[];
  for (int i = 0; i < totalSets; i++) {
    final base = 3 + i * 6;
    sets.add((
      weightKg: bd.getUint16(base, Endian.little) / 10.0,
      reps:     bd.getUint8(base + 2),
      restSec:  bd.getUint8(base + 3),
      durSec:   bd.getUint16(base + 4, Endian.little),
    ));
  }
  return (sessionId: sessionId, sets: sets);
}

// 검증 예시: 100kg × 10회 × 4세트
// Raw: 42 00 04  E8 03 0A 5A 1E 00  E8 03 08 5A 23 00  84 03 0A 5A 20 00  84 03 08 00 25 00
// Total: 27 bytes ✅
```

### 5.4 디코딩 예제 (C, Zephyr)

```c
#include <zephyr/kernel.h>
#include <stdint.h>

#define FICA_MAX_SETS 20

typedef struct __attribute__((packed)) {
    uint16_t weight_x10;       // ×0.1kg, Little-Endian
    uint8_t  reps;
    uint8_t  rest_seconds;
    uint16_t duration_seconds;  // Little-Endian
} fica_set_data_t;

typedef struct {
    uint16_t        session_id;
    uint8_t         total_sets;
    fica_set_data_t sets[FICA_MAX_SETS];
} fica_session_t;

static inline uint16_t read_le16(const uint8_t *p) {
    return (uint16_t)(p[0] | (p[1] << 8));
}

int fica_parse_session(const uint8_t *buf, uint16_t len, fica_session_t *out)
{
    if (!buf || !out || len < 3) return -EINVAL;

    out->session_id = read_le16(&buf[0]);
    out->total_sets = buf[2];

    if (out->total_sets > FICA_MAX_SETS) return -ENOBUFS;
    if (len < 3u + (uint16_t)out->total_sets * 6u) return -EMSGSIZE;

    for (uint8_t i = 0; i < out->total_sets; i++) {
        const uint8_t *p = &buf[3 + i * 6];
        out->sets[i].weight_x10       = read_le16(&p[0]);
        out->sets[i].reps             = p[2];
        out->sets[i].rest_seconds     = p[3];
        out->sets[i].duration_seconds = read_le16(&p[4]);
    }
    return 0; // 성공
}

// 검증: buf = {0x42,0x00, 0x04, 0xE8,0x03,0x0A,0x5A,0x1E,0x00, ...}
// session_id=66, total_sets=4, sets[0].weight_x10=1000(=100.0kg) ✅
```

### 5.5 MTU 초과 시 분할 전략

현재 최대 20세트 = 123 bytes로 iOS MTU(182 bytes) 이내이므로 **분할 불필요**.

향후 확장 대비 분할 헤더 예약:

```
분할 패킷 헤더 (2 bytes):
  Byte 0: frag_idx   (0부터)
  Byte 1: frag_total (전체 조각 수)
```

---

## 6. Command 코드 정의

### 6.1 전체 코드 테이블

#### 세션 명령 (0x01-0x09)

| 코드 | 명령 | 설명 |
|------|------|------|
| `0x01` | START_SESSION | 세션 시작 (IDLE→READY 전이) |
| `0x02` | STOP_SESSION | 세션 강제 중단, 완료 세트 보존 |
| `0x03` | RESET_SET | 현재 세트 rep 0으로 초기화 |
| `0x04` | SKIP_REST | 휴식 즉시 종료 (RESTING→EXERCISING) |
| `0x05` | ADD_SET | 남은 세트 +1 (최대 20) |
| `0x06` | REMOVE_SET | 남은 세트 -1 (최소 1) |
| `0x07` | SET_WEIGHT | 앱에서 무게 직접 입력 (Weight Write 대안) |
| `0x08` | PAUSE_SESSION | 세션 일시정지, 타이머/카운트 동결 |
| `0x09` | RESUME_SESSION | 일시정지 해제, 이전 상태 복귀 |

#### 시스템 명령 (0x10-0x1F)

| 코드 | 명령 | 설명 |
|------|------|------|
| `0x10` | OTA_START | OTA 펌웨어 업데이트 시작 |
| `0x11` | OTA_ABORT | OTA 취소, 이전 펌웨어 롤백 |
| `0x12-0x1F` | (예약) | 시스템 명령 확장용 |

#### 특수 명령

| 코드 | 명령 | 설명 |
|------|------|------|
| `0xFE` | PING | 연결 유지 확인 |
| `0xFF` | FACTORY_RESET | 공장 초기화 (오발송 방지: confirm 바이트 `0xAA` 필수) |

### 6.2 응답 메커니즘 (ACK)

별도 ACK Characteristic 없이 **Set Status Notify + Error Code Notify**로 응답.

- **성공**: Set Status가 예상 상태로 전이 → 암시적 ACK
- **실패**: Error Code Notify 발생

**타임아웃**: Write 후 3초 내 응답 없으면 재전송 (최대 2회), 이후 BLE 재연결.

### 6.3 예약 범위

| 범위 | 용도 |
|------|------|
| `0x00` | 예약 (사용 금지) |
| `0x01-0x09` | 세션 명령 (9개 정의) |
| `0x0A-0x0F` | 세션 명령 확장 (6 슬롯) |
| `0x10-0x1F` | 시스템 명령 (2 정의 / 14 예약) |
| `0x20-0x3F` | B2B 관리자 명령 우선 예약 |
| `0x40-0xFD` | 미래 기능 예약 |
| `0xFE` | PING |
| `0xFF` | FACTORY_RESET |

---

## 7. Set Status 상태 머신

### 7.1 상태 다이어그램

```
                         NFC Tap + BLE
                ┌───────────────────────────────────┐
                │                                   │
                v                                   │
        ┌───────────────┐                           │
        │  IDLE (0x00)  │<──────────────────────────┤
        │   (STEP 0)    │          10s / STOP       │
        └───────┬───────┘                           │
                │ START_SESSION                     │
                v                                   │
        ┌───────────────┐                           │
        │  READY (0x01) │                           │
        │  (STEP 1-2)   │                           │
        └───────┬───────┘                           │
                │ 첫 동작 감지                       │
                v                                   │
        ┌───────────────┐         SKIP_REST /       │
        │ EXERCISING    │<────── 타이머 만료 /       │
        │   (0x02)      │        동작 재개           │
        │  (STEP 3/5)   │           │               │
        └───────┬───────┘           │               │
                │ 2-3s 무동작       │               │
                v                   │               │
        ┌───────────────┐           │               │
        │  RESTING      ├───────────┘               │
        │   (0x03)      │  (세트 남은 경우)          │
        │  (STEP 4)     │                           │
        └───────┬───────┘                           │
                │ 마지막 세트 완료                    │
                v                                   │
        ┌───────────────┐                           │
        │ COMPLETE      ├───────────────────────────┘
        │   (0x04)      │
        │  (STEP 6)     │
        └───────────────┘

        ┌───────────────┐
        │  ERROR (0x05) │ ← 모든 상태에서 진입 가능
        └───────┬───────┘
                └── 복구 시 IDLE 복귀
```

### 7.2 전이 조건 상세

| 전이 | 트리거 | 장치 동작 |
|------|--------|----------|
| IDLE → READY | NFC 탭 + BLE 연결 + START_SESSION | session_id++, LED 활성화 |
| READY → EXERCISING | IMU 첫 운동 동작 감지 | rep 카운터 초기화, 세트 타이머 시작 |
| EXERCISING → RESTING | 2-3s 무동작 (세트 종료) | duration 기록, 완료 LED 변경, 휴식 타이머 시작 |
| RESTING → EXERCISING | 타이머 만료 / SKIP_REST / 동작 재개 (세트 남음) | rest_seconds 기록, rep 초기화, current_set++ |
| RESTING → COMPLETE | 마지막 세트 종료 후 | Session Data 빌드 + Indicate |
| COMPLETE → IDLE | 10s 경과 / STOP_SESSION | LED 소등, IMU 슬립 |
| ANY → ERROR | 하드웨어/BLE 에러 | Error Code Notify |
| ANY → IDLE | STOP_SESSION | 완료 세트 보존, 즉시 IDLE |

### 7.3 STEP 0~6 매핑

| STEP | 동작 | 상태 | BLE 이벤트 |
|------|------|------|------------|
| 0 | 대기, 센서 슬립 | IDLE | 광고만 송출 |
| 1 | NFC 탭, 기구 인식 | IDLE → READY | Equipment ID Read |
| 2 | 세트 수 설정, LED 활성 | READY | Total Sets Write |
| 3 | 운동 중, rep 카운팅 | EXERCISING | Rep Count Notify |
| 4 | 세트 완료, 휴식 타이머 | RESTING | Rest Timer Notify (매초) |
| 5 | 다음 세트 반복 | EXERCISING ↔ RESTING | Current Set Notify |
| 6 | 전체 완료, 데이터 전송 | COMPLETE → IDLE | Session Data Indicate |

### 7.4 비정상 전이 처리

**BLE 단절 시 상태별 동작:**

| 상태 | 장치 동작 | 재연결 후 |
|------|----------|----------|
| IDLE | 광고 재시작 | IDLE 유지 |
| READY | 30s 보존 후 IDLE | START_SESSION 재전송 |
| EXERCISING | rep 카운팅 계속, 로컬 버퍼 | Set Status Read로 동기화 |
| RESTING | 타이머 계속 | 남은 시간 동기화 |
| COMPLETE | 플래시 저장, 10s 카운트다운 정지 | Session Data 재전송 |

---

## 8. BLE 연결 파라미터

### 8.1 광고 (Advertising)

**이름 형식**: `Fica-{MAC 하위 4자리 hex}` (예: `Fica-A3F2`)

| 모드 | 인터벌 | 적용 조건 |
|------|--------|-----------|
| **Fast** | 100 ms | 전원 ON 후 첫 30초 |
| **Slow** | 1,000 ms | Fast 30초 후 연결 없음 → 절전 |

그러니까 전원 켜면 처음 30초는 100ms마다 빠르게 신호를 뿌리고, 이후엔 1,000ms로 늦춰서 배터리를 아낀다.

**Advertising Data (31 bytes 이내)**:

| 필드 | 길이 | 값 |
|------|------|----|
| Flags | 3B | `0x02 0x01 0x06` (LE General Discoverable, BR/EDR Not Supported) |
| 128-bit UUID | 18B | `FCA00000-0001-4000-8000-00805F9B34FB` |
| TX Power Level | 3B | 실측값 (dBm) |

**Scan Response Data (31 bytes 이내)**:

| 필드 | 길이 | 값 |
|------|------|----|
| Complete Local Name | ~11B | `Fica-XXXX` (UTF-8) |
| Manufacturer Specific Data | 7B | Company ID (2B) + FW 버전 (2B) + 배터리 (1B) + 예약 (2B) |

**필터링**: 앱은 `Fica-` 접두어 + `FCA00000` Service UUID 둘 다 확인.

### 8.2 연결 (Connection)

| 파라미터 | 운동 중 (Active) | 휴식/대기 (Idle) |
|----------|-----------------|-----------------|
| Connection Interval | **50 ms** | **500 ms** |
| Slave Latency | **0** | **4** |
| Supervision Timeout | **4,000 ms** | **4,000 ms** |

**실효 최대 레이턴시**:

```
운동 중: 50ms × (0 + 1) = 50ms   — 실시간 rep 표시
휴식 중: 500ms × (4 + 1) = 2,500ms — 배터리 절약
```

그러니까 운동 중엔 50ms마다 데이터를 주고받아 횟수가 실시간으로 표시되고, 쉬는 동안엔 Slave Latency 4를 줘서 배터리를 아낀다.

**파라미터 업데이트 흐름**:

```
[펌웨어]                          [앱]
   │  운동 시작 감지 (IMU)           │
   │  → Connection Parameter        │
   │    Update Request               │
   │  interval=40~60ms, latency=0    │
   │──────────────────────────────>│
   │                  Update Accept  │
   │<──────────────────────────────│
   │                                 │
   │  세트 완료 / 휴식 감지           │
   │  interval=400~600ms, latency=4  │
   │──────────────────────────────>│
```

### 8.3 MTU 협상

| 플랫폼 | 요청 MTU | 실효 MTU | ATT 페이로드 |
|--------|----------|----------|-------------|
| nRF52840 | **247 bytes** | — | — |
| Android | 247 | **247 bytes** | 244 bytes |
| iOS | 247 요청 → | **185 bytes** | 182 bytes |

**Session Data 적합성**: 10세트 = 63 bytes < 182 bytes (iOS) ✅, 여유 119 bytes.

**청킹 폴백**: ATT 페이로드 < 66 bytes 인 구형 BLE 4.0 폰에서만 필요. 2026년 기준 주요 대상(iOS 15+, Android 8+)에서는 발생하지 않지만 방어 코드로 구현.

### 8.4 PHY

| PHY | 속도 | Fica 사용 |
|-----|------|----------|
| LE 1M | 1 Mbps | 기본값 |
| LE 2M | 2 Mbps | 양측 지원 시 협상 업그레이드 |
| LE Coded | 저속 | **미사용** (근거리 전용) |

**Zephyr 구현**: `bt_conn_le_phy_update(conn, BT_CONN_LE_PHY_PARAM_2M);`

iOS 12+, Android 8+에서 LE 2M PHY 지원. 미지원 시 1M 유지, 연결 지속.

---

## 9. 보안

### 9.1 Phase 1: Just Works (B2C)

| 항목 | 값 |
|------|-----|
| 페어링 방식 | **Just Works** (Security Level 2) |
| 암호화 | AES-128-CCM (BLE 표준) |
| MITM 보호 | 없음 |
| LE Secure Connections | 지원 (ECDH 키 교환, nRF52840 HW 가속) |

**Just Works 선택 근거**:
1. **UX 최우선**: 센서에 키패드 없음. PIN 마찰 제거
2. **데이터 민감도**: 횟수/무게는 의료 데이터가 아님. AES-128 암호화로 충분
3. **현실 위협**: 페어링 순간 MITM 포지셔닝 확률 극히 낮음

그러니까 "비밀번호 없이 연결"이지만 연결 후 데이터는 AES-128로 암호화된다.

**페어링 시퀀스**:

```
[앱]                                [Fica]
  │  Pairing Request                    │
  │  (IO: NoInputNoOutput)              │
  │────────────────────────────────────>│
  │             Pairing Response         │
  │  (IO: NoInputNoOutput)               │
  │<────────────────────────────────────│
  │  [Just Works 자동 선택]              │
  │  Confirm/Random 교환 (자동)         │
  │<───────────────────────────────────>│
  │  LTK 생성 (ECDH) → 암호화 시작      │
  │  Pairing Complete ✓                 │
```

### 9.2 Phase 2: Numeric Comparison (B2B 검토)

B2B 헬스장 납품 시 "특정 앱만 연결 허용"을 위해 MITM 보호 업그레이드.

```
[앱 화면]                       [Fica 7-세그먼트 LED]
 ┌─────────────────────┐            ┌──────────┐
 │  Fica-A3F2 연결 확인 │            │  4 2 7 8 │
 │                     │            │  9 1     │
 │  코드: 4 2 7 8 9 1  │            └──────────┘
 │                     │
 │  [확인]    [거부]    │
 └─────────────────────┘
```

그러니까 가짜 기기가 끼어들면 숫자가 다르게 나온다. 사용자가 "아, 다르네" 하고 거부하면 MITM 공격이 차단된다.

**결정**: **Phase 2로 연기.** 7-세그먼트 LED H/W는 이미 숫자 표시 가능하므로 펌웨어만 수정하면 됨.

### 9.3 본딩 (Bonding)

| 항목 | 값 |
|------|-----|
| 저장 위치 | nRF52840 내부 Flash (Zephyr Settings Storage) |
| 최대 본딩 수 | **8대** (빌드 시 변경 가능) |
| 저장 내용 | MAC + IRK + LTK + EDIV + Rand |
| 주소 타입 | **Resolvable Private Address (RPA)**, 15분마다 갱신 |

그러니까 한 번 연결한 폰은 기억해두고, 다음에 자동으로 연결된다. RPA는 MAC 주소를 15분마다 바꿔서 낯선 사람이 Fica 기기를 추적하지 못하게 한다.

**자동 재연결 흐름**:

```
앱 실행
  ├─ 본딩 기록 있음? → Directed Advertising → 즉시 암호화 연결
  └─ 본딩 없음? → Undirected Advertising → 신규 페어링 대기
```

**본딩 삭제**:

| 방법 | 동작 | 시나리오 |
|------|------|---------|
| 앱 UI | FACTORY_RESET 커맨드 | 기기 양도 |
| 하드웨어 | 버튼 5초 장누름 | 앱 없이 리셋 |
| 특정 삭제 | 앱 설정 → "연결 해제" | 기기 변경 |

---

## 10. 연결 흐름 시퀀스 다이어그램

### 10.1 최초 연결

최초 연결은 7단계로 진행된다. 그러니까 앱이 센서를 찾고, 연결하고, 데이터 주고받을 준비를 마치는 전체 과정이다.

```
App (Flutter)              Fica 센서 (nRF52840)
     |                            |
     |   BLE Scan 시작            |
     |   (필터: "Fica-" 접두사    |
     |    + UUID FCA00000)        |
     |<--- ADV_IND --------------|  광고 패킷 송출
     |    (Service UUID 포함)     |  (간격: 100ms, TX: 0dBm)
     |                            |
     |--- CONNECT_REQ ----------->|  연결 요청
     |<-- CONNECT_RSP ------------|  연결 수락
     |    [STATE: CONNECTING]     |  [STATE: CONNECTING]
     |                            |
     |--- MTU Exchange ---------->|  MTU 협상 요청 (247 bytes)
     |<-- MTU Response -----------|  합의 (min(247, 기기_MTU))
     |                            |
     |--- PHY Update ------------>|  LE 2M PHY 요청
     |<-- PHY Update RSP ---------|  PHY 업데이트 완료
     |    (처리량 향상: 1M→2Mbps) |
     |                            |
     |--- Service Discovery ----->|  서비스 목록 요청
     |    (FCA00000, 0x180F,      |
     |     0x180A)                |
     |<-- Service List -----------|  서비스 + 특성 목록 반환
     |                            |
     |--- Enable Notify ---------->|  알림 구독 (CCCD Write 0x0001)
     |    · Rep Count (FCA00001)  |
     |    · Set Status (FCA00003) |
     |    · Rest Timer (FCA00006) |
     |    · Battery (0x2A19)      |
     |<-- Notify Confirm ---------|  구독 확인
     |                            |
     |--- Write: Weight --------->|  마지막 세션 무게 설정
     |--- Write: TotalSets ------>|  총 세트 수 설정
     |--- Write: RestDuration --->|  휴식 시간 설정
     |<-- Notify: READY ----------|  [STATE: READY] 전환 완료
     |    [STATE: CONNECTED]      |
     |                            |
     ※ 여기서부터 운동 시작 가능
```

**연결 타임라인 (정상 환경 기준):**

| 단계 | 소요 시간 | 누적 |
|------|-----------|------|
| Scan → ADV 수신 | ~100ms | 100ms |
| CONNECT 협상 | ~50ms | 150ms |
| MTU + PHY 협상 | ~100ms | 250ms |
| Service Discovery | ~200ms | 450ms |
| Notify 구독 (5개) | ~100ms | 550ms |
| 초기값 Write (3개) | ~50ms | 600ms |
| **총계** | **~600ms** | — |

### 10.2 재연결

연결이 끊어졌을 때 자동으로 다시 연결하는 흐름이다. 그러니까 센서가 혼자서도 계속 데이터를 쌓고 있다가, 앱이 돌아오면 밀린 데이터를 한꺼번에 보내주는 구조다.

```
App                        Fica 센서
 |                              |
 |  ~~~ 연결 끊김 ~~~           |  ~~~ 연결 끊김 ~~~
 |  [STATE: DISCONNECTED]       |  [STATE: DISCONNECTED]
 |                              |  → 운동 계속 진행 (자체 카운팅)
 |                              |  → 데이터 FIFO 버퍼에 누적
 |                              |  → 광고 재시작 (3초 후)
 |                              |
 |  t=0s: 재연결 시도 #1        |
 |--- CONNECT_REQ ------------->|
 |    (실패 or 타임아웃)        |
 |                              |
 |  t=3s: 재연결 시도 #2        |
 |--- CONNECT_REQ ------------->|
 |<-- CONNECT_RSP --------------|  ← 재연결 성공
 |                              |
 |  (MTU/PHY는 이미 알고 있음)  |
 |--- Enable Notify (재구독) -->|  CCCD는 재연결 시 리셋됨
 |<-- Notify Confirm ------------|
 |                              |
 |<-- Notify: BufferedData[0] --|  버퍼에 쌓인 데이터 순서대로 전송
 |<-- Notify: BufferedData[1] --|  (세트 완료 기록, 횟수, 무게 등)
 |<-- Notify: BufferedData[N] --|
 |                              |
 |<-- Notify: CurrentState -----|  현재 센서 상태 동기화
 |    [STATE: EXERCISING or     |
 |     RESTING or IDLE]         |
 |                              |
 |  앱: 수신 데이터 Hive에 저장 |
 |  앱: Supabase 업로드 재개    |
```

**재연결 정책:**

```
최대 시도 횟수: 10회
시도 간격:     3초
총 대기 시간:  30초

[0s]  시도 #1  → 실패
[3s]  시도 #2  → 실패
[6s]  시도 #3  → 실패
...
[27s] 시도 #10 → 실패
[30s] 포기 → 센서: 세션 전체 저장, 다음 연결까지 대기
           → 앱: "센서 연결 끊김" 토스트 표시
```

### 10.3 끊김 복구 (3중 안전망)

연결이 끊겨도 데이터가 절대 사라지지 않도록 3단계 안전망을 구성한다. 그러니까 첫 번째 방어선이 뚫려도 두 번째가 막고, 두 번째가 뚫려도 세 번째가 막는 구조다.

```
┌─────────────────────────────────────────────────────────┐
│                   3중 안전망 구조                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Layer 1: 센서 FIFO 버퍼                                 │
│  ┌──────────────────────────────────┐                   │
│  │ 용량: 최대 10 세트 (~60 bytes)    │                   │
│  │ 위치: nRF52840 RAM               │                   │
│  │ 보존: 전원 유지 시 (배터리)       │                   │
│  │ 전송: 재연결 즉시 Notify로 전송   │                   │
│  └──────────────────────────────────┘                   │
│              ↓ 버퍼 초과 or 앱이 수신                    │
│                                                          │
│  Layer 2: 앱 로컬 스토리지 (Hive)                        │
│  ┌──────────────────────────────────┐                   │
│  │ 용량: 무제한 (폰 저장소)          │                   │
│  │ 위치: Flutter Hive DB             │                   │
│  │ 보존: 앱 종료 후에도 유지          │                   │
│  │ 전송: 온라인 복구 시 Supabase 업로드│                 │
│  └──────────────────────────────────┘                   │
│              ↓ Supabase 업로드 성공                      │
│                                                          │
│  Layer 3: Supabase (클라우드)                            │
│  ┌──────────────────────────────────┐                   │
│  │ 용량: 무제한                      │                   │
│  │ 위치: 클라우드 PostgreSQL         │                   │
│  │ 보존: 영구                        │                   │
│  │ 전송: 앱 → 서버 완료              │                   │
│  └──────────────────────────────────┘                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**시나리오별 복구 흐름:**

| 시나리오 | 작동하는 레이어 | 데이터 손실 |
|----------|-----------------|-------------|
| BLE 일시적 끊김 (30초 내 재연결) | Layer 1 | 없음 |
| 앱이 백그라운드로 전환 | Layer 1 + 2 | 없음 |
| 앱 강제 종료 | Layer 1 + 2 | 없음 |
| 폰 배터리 방전 | Layer 1 | 없음 (센서 버퍼 유지) |
| 센서 배터리 방전 | Layer 2 + 3 | Layer 1 내용만 손실 가능 |
| 30초 내 재연결 실패 | Layer 1 + 2 + 3 | 없음 (다음 연결 시 복구) |

---

## 11. OTA DFU

### 11.1 Nordic Secure DFU Service

nRF52840에서 공식 지원하는 펌웨어 무선 업데이트 방식이다. 그러니까 USB 케이블 없이 블루투스로 새 펌웨어를 올릴 수 있는 기능이다.

**서비스 UUID 구성:**

| 특성 | UUID | 역할 |
|------|------|------|
| Nordic DFU Service | `0xFE59` | DFU 서비스 식별자 |
| DFU Control Point | `8EC90001-F315-4F60-9FB8-838830DAEA50` | 명령 수신 (Write + Notify) |
| DFU Packet | `8EC90002-F315-4F60-9FB8-838830DAEA50` | 펌웨어 데이터 수신 (Write Without Response) |
| Buttonless DFU | `8EC90003-F315-4F60-9FB8-838830DAEA50` | DFU 모드 진입 트리거 |

**보안 서명 방식:**
- 알고리즘: ECDSA P-256 (secp256r1)
- 서명 키: nRF Connect SDK `nrfutil` 생성 (개발용 키 → 출시 전 교체 필수)
- 검증: 센서가 수신 후 서명 검증 → 실패 시 자동 롤백

### 11.2 Buttonless DFU 진입 프로세스

버튼을 누르지 않고 앱에서 명령을 보내 DFU 모드로 전환하는 흐름이다. 그러니까 헬스장에 설치된 센서를 물리적으로 건드리지 않고도 원격으로 업데이트할 수 있다.

```
App (Flutter)              Fica 센서 (nRF52840)
     |                            |
     |  [사전 조건 확인]           |
     |  · 배터리 ≥ 30%            |
     |  · BLE 연결 상태           |
     |  · 펌웨어 이미지 검증 완료  |
     |                            |
     |--- OTA_START (0x10) ------>|  Command 특성에 Write
     |    (FCA0000A 채널)         |
     |<-- ACK: 0x20 -------------|  수신 확인
     |                            |
     |                            |  → 진행 중 세션 저장 (FIFO 버퍼에)
     |                            |  → 일반 BLE 광고 중단
     |                            |  → DFU 광고 시작
     |                            |     이름: "DfuTarg" + 하위 3바이트 MAC
     |                            |     UUID: 0xFE59
     |  ~~~ BLE 연결 끊김 ~~~     |  ~~~ BLE 연결 끊김 ~~~
     |                            |
     |--- BLE Scan (DFU 모드) --->|  "DfuTarg" 검색
     |<-- ADV_IND (DFU UUID) -----|
     |--- CONNECT_REQ ----------->|
     |<-- CONNECT_RSP ------------|
     |                            |
     |--- Write: START_DFU ------>|  DFU Control Point에 시작 명령
     |<-- Notify: ACK -----------|
     |                            |
     |--- Write: Firmware ------->|  DFU Packet에 이미지 청크 전송
     |    (MTU 단위로 분할)       |  (PRN: 12패킷마다 확인)
     |<-- Notify: CRC Check ------|  중간 CRC 확인
     |--- Write: Firmware ------->|
     |    ... (반복) ...          |
     |<-- Notify: CRC Check ------|
     |                            |
     |--- Write: EXECUTE -------->|  전체 이미지 전송 완료
     |                            |
     |                            |  → 서명 검증 (ECDSA P-256)
     |                            |  → 검증 성공: 새 펌웨어로 부팅
     |                            |  → 검증 실패: 기존 펌웨어로 롤백
     |  ~~~ 센서 재부팅 ~~~       |  ~~~ 재부팅 (3~5초) ~~~
     |                            |
     |<-- ADV_IND (일반 모드) ----|  새 펌웨어로 광고 재개
     |--- CONNECT_REQ ----------->|  정상 연결 복구
     |<-- CONNECT_RSP ------------|
     |<-- Notify: FW_VERSION -----|  새 버전 번호 확인
```

### 11.3 권장 파라미터

```dart
// Flutter 앱 DFU 설정 (nordic_dfu 패키지 사용)
final dfuSettings = DfuSettings(
  // PRN: 그러니까 12패킷마다 "잘 받았어?" 확인 신호를 주고받음
  // 너무 낮으면 느림, 너무 높으면 패킷 손실 시 재전송량 많아짐
  packetReceiptNotification: 12,

  // 타임아웃: 전체 전송에 60초 부여
  // 일반 펌웨어 크기 (~256KB) 기준 충분한 여유
  timeout: 60,

  // MTU: 협상된 MTU 활용 (최대 247 bytes)
  // 그러니까 한 번에 보내는 조각 크기를 최대로 해서 빠르게 전송
  forceDfu: false,
  enableUnsafeExperimentalButtonlessServiceInSecureDfu: true,
);
```

**전송 속도 추산 (MTU 247 기준):**

| 조건 | 처리량 | 256KB 전송 시간 |
|------|--------|-----------------|
| LE 1M PHY + MTU 23 | ~2.5 KB/s | ~105초 |
| LE 2M PHY + MTU 247 | ~23 KB/s | ~11초 |
| **권장 (2M + 247)** | **~20 KB/s** | **~13초** |

### 11.4 안전 장치

```
1. Dual-Bank 업데이트 (이중 뱅크)
   ┌─────────────────────────────────┐
   │  Bank A (현재): FW v1.2.0       │ ← 기존 펌웨어 유지
   │  Bank B (대기): FW v1.3.0 수신  │ ← 새 펌웨어 기록
   └─────────────────────────────────┘
   검증 성공 → Bank B로 부팅 (Bank A 삭제)
   검증 실패 → Bank A 그대로 유지 (자동 롤백)

2. 배터리 게이트
   OTA 시작 전 배터리 체크:
   · 배터리 < 30% → OTA 거부 (에러 코드 0xE1 반환)
   · 배터리 ≥ 30% → OTA 허용
   이유: 펌웨어 전송 도중 전원 꺼지면 브릭(brick) 위험

3. 서명 검증 (ECDSA P-256)
   · 검증 실패 → 이미지 폐기, Bank A 유지
   · 버전 다운그레이드 방지: 새 버전 < 현재 버전이면 거부

4. WDT (Watchdog Timer)
   · DFU 모드 진입 후 60초 내 전송 시작 없으면 자동 재부팅
   · 그러니까 DFU 중간에 앱이 죽어도 센서가 먹통 상태로 남지 않음
```

---

## 12. 헬스장 환경 대응

### 12.1 BLE 간섭 대응 (AFH)

헬스장은 여러 BLE 기기, Wi-Fi AP, 기타 2.4GHz 장치가 밀집한 환경이다. 그러니까 채널 충돌이 잦아 패킷 손실이 일어나기 쉬운 곳이다. nRF52840은 이를 AFH로 자동 처리한다.

**AFH 동작 원리:**

```
BLE 주파수 채널 맵 (2.4GHz 대역):

  BLE 채널:  0  1  2  3 ... 36 37(광고) 38(광고) 39(광고)
  주파수:   2402 2404 2406 ... 2480MHz

  Wi-Fi CH1 점유:  [BLE 0~5] ← 회피 대상
  Wi-Fi CH6 점유:  [BLE 24~30] ← 회피 대상
  Wi-Fi CH11 점유: [BLE 49~62] ← 회피 대상 (없는 채널이지만 간섭 존재)

  AFH 작동:
  · 연결 후 간섭 채널 자동 감지
  · Channel Map에서 불량 채널 제거 (최소 2개 채널 유지)
  · 나머지 채널에서만 호핑 (37개 채널 중 최대 37개 활용)
  · 그러니까 Wi-Fi가 쓰는 채널은 자동으로 피해서 통신함
```

**Zephyr RTOS 설정 (추가 코드 불필요):**

```c
// prj.conf — AFH는 기본 활성화
CONFIG_BT=y
CONFIG_BT_PERIPHERAL=y
// AFH는 BLE 사양(Core Spec 5.0+) 필수 기능으로 자동 적용
// 별도 설정 없이 nRF52840 + Zephyr에서 자동 동작
```

### 12.2 TX Power 조정

**기본 설정:**

```c
// 기본: 0 dBm (약 1~3m 범위, 헬스장 기구 옆 사용 기준 충분)
// nRF52840 지원 범위: -40 dBm ~ +8 dBm

// Zephyr 펌웨어에서 TX Power 설정
#include <zephyr/bluetooth/bluetooth.h>

int8_t tx_power = 0; // 기본 0 dBm
bt_le_set_tx_power(tx_power, BT_HCI_LE_ADV_HANDLE_INVALID);
```

**TX Power 조정 정책:**

| 상황 | TX Power | 예상 범위 |
|------|----------|-----------|
| 기본 (일반 헬스장) | 0 dBm | ~3m |
| 간섭 심한 환경 | +4 dBm | ~8m |
| 최대 (넓은 공간) | +8 dBm | ~15m |
| 절전 모드 | -8 dBm | ~1m |

**향후 자동 조정 (v2 계획):**

```dart
// 앱 측: RSSI 모니터링 → 약하면 TX Power 증가 명령 전송
// BLE Command: 0x20 (TX_POWER_SET) + int8 값
if (rssi < -80) {
  await sensor.setTxPower(4); // +4 dBm으로 상향
}
```

### 12.3 Connection Interval 적응

연결 간격을 운동 상태에 따라 동적으로 바꿔서, 운동 중엔 빠르게 / 쉬는 중엔 배터리를 아끼는 방식이다.

**상태별 Connection Interval:**

```
EXERCISING 상태 (운동 중):
  Connection Interval: 50ms
  이유: 횟수 실시간 표시 → 1초 이내 반영 필요
  소비 전류: 약 200~300 μA (BLE 활성)

RESTING 상태 (세트 간 휴식):
  Connection Interval: 500ms
  이유: Rest Timer 카운트다운만 필요 (1초 단위)
  소비 전류: 약 20~50 μA (BLE 저전력)

IDLE 상태 (앱 연결 중, 운동 없음):
  Connection Interval: 1000ms
  이유: 배터리 상태 정도만 주기적으로 확인
  소비 전류: 약 10~20 μA
```

**상태 전환 시퀀스:**

```
App                        Fica 센서
 |                              |
 |<-- Notify: SET_START --------|  운동 시작 감지
 |    [STATE: EXERCISING]       |  [STATE: EXERCISING]
 |                              |
 |                              |  → Connection Interval 변경 요청
 |<-- L2CAP: ConnParamReq ------|  (50ms 요청)
 |--- L2CAP: ConnParamRsp ----->|  (수락 or 앱이 조정)
 |    [interval = 50ms]         |  [interval = 50ms 적용]
 |                              |
 |  (운동 완료)                  |
 |<-- Notify: SET_COMPLETE -----|  세트 완료
 |    [STATE: RESTING]          |  [STATE: RESTING]
 |                              |
 |                              |  → Connection Interval 변경 요청
 |<-- L2CAP: ConnParamReq ------|  (500ms 요청)
 |--- L2CAP: ConnParamRsp ----->|  (수락)
 |    [interval = 500ms]        |  [interval = 500ms 적용]
```

### 12.4 다중 기기 공존

헬스장에 여러 Fica 센서와 여러 회원 폰이 동시에 있을 때의 구조다. 그러니까 옆 사람 센서가 내 폰에 연결되는 일이 없도록 관리하는 방법이다.

**연결 구조:**

```
헬스장 환경 (예: 10대 기구, 10명 회원):

  [벤치프레스 Fica-A3F2] ←→ [회원1 폰]
  [스쿼트랙  Fica-B7C1] ←→ [회원2 폰]
  [데드리프트 Fica-C9D4] ←→ [회원3 폰]
  ...
  각 쌍은 완전히 독립적 (간섭 없음)

  핵심: 1 센서 = 1 폰 (동시 다중 연결 지원 안 함)
  이유: 운동 데이터는 개인 소유 → 여러 폰에 동시 브로드캐스트 불필요
```

**센서 식별 보안:**

```dart
// 앱: 내 소유 센서만 연결 (MAC 주소 + 페어링 키 기반 필터)
Future<void> scanForMySensor() async {
  await FlutterBluePlus.startScan(
    withNames: ['Fica-${myDeviceId}'],  // 내 기기만 필터
    timeout: Duration(seconds: 10),
  );
}

// 처음 페어링 시 센서 MAC 주소를 Supabase에 저장
// 이후 재연결 시 저장된 MAC만 허용
```

**nRF52840 동시 연결 한도:**

```
nRF52840 기술 사양:
  · 최대 동시 연결: 20개 (Central + Peripheral 합산)
  · Fica는 Peripheral 모드 1개만 사용
  · 나머지 19개 슬롯은 미사용 (확장 여유)

실제 헬스장 시나리오:
  · 센서 1대 = 연결 슬롯 1개 사용
  · BLE Mesh 불필요 (각 기기가 직접 폰과 1:1 통신)
  · 그러니까 기구 100대가 있어도 각자 독립 연결이라 간섭 없음
```

### 12.5 Wi-Fi 공존

헬스장의 2.4GHz Wi-Fi와 BLE가 같은 주파수를 공유할 때 충돌 처리 방식이다. 그러니까 Wi-Fi가 강하게 잡혀 있는 헬스장에서도 BLE가 끊기지 않게 하는 방법이다.

**주파수 충돌 구조:**

```
2.4GHz 대역 공유 지도:

  Wi-Fi 채널 1 (2412MHz 중심):
  ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  BLE 채널: [0][1][2][3][4][5][6] ← 간섭 영역

  Wi-Fi 채널 6 (2437MHz 중심):
  ░░░░░░░░░░░░████████████░░░░░░░░░░░░░░░░░░░░░
  BLE 채널: [14][15][16][17][18][19][20] ← 간섭 영역

  Wi-Fi 채널 11 (2462MHz 중심):
  ░░░░░░░░░░░░░░░░░░░░░░░░████████████░░░░░░░░░
  BLE 채널: [27][28][29][30][31][32][33] ← 간섭 영역

  AFH 적용 후: 간섭 채널 제외, 나머지 ~20개 채널에서 정상 통신
```

**PTA (Packet Traffic Arbitration) 미적용 이유:**

```
PTA는 Wi-Fi + BLE 모두 탑재된 콤보 칩에서 사용하는 기술
(예: ESP32-C3, Nordic nRF7002)

nRF52840은 BLE 전용 칩 → PTA 하드웨어 없음
대신: AFH가 소프트웨어적으로 같은 역할을 수행

실제 성능:
  · 피트니스 워치, 스마트 밴드 모두 nRF 계열 + 헬스장 사용
  · AFH만으로 헬스장 Wi-Fi 환경에서 충분히 안정적
  · 추가 코드 없이 Zephyr BLE 스택이 자동 처리
```

**5GHz Wi-Fi 관련:**

```
5GHz Wi-Fi (802.11ac/ax):
  · 주파수 대역: 5150~5850MHz
  · BLE 2.4GHz와 겹치지 않음 → 간섭 없음
  · 헬스장 듀얼밴드 AP의 5GHz 트래픽은 BLE에 영향 없음

결론: 헬스장 Wi-Fi가 듀얼밴드라면
  · 5GHz: 완전 무관
  · 2.4GHz: AFH로 자동 회피
  · 별도 조치 불필요
```

---

## 13. Dart/C 코드 레퍼런스

> **목적**: BLE GATT 세션 데이터 패킷의 인코딩(Dart/앱) ↔ 디코딩(C/펌웨어) 쌍을 검증된 예제와 함께 제공한다.
> **기준 예제**: Session ID=0x0042, 4세트, 100kg×10→100kg×8→90kg×10→90kg×8, 총 27바이트

### 13.1 Session Data 인코딩 (Dart)

```dart
// lib/features/workout/data/ble_session_encoder.dart
//
// BLE GATT 세션 데이터 패킷 인코딩
// 패킷 구조:
//   헤더 3바이트  : session_id(uint16 LE) + total_sets(uint8)
//   세트당 6바이트: weight_x10(uint16 LE) + reps(uint8) + rest_seconds(uint8)
//                   + duration_seconds(uint16 LE)
//
// 최대 10세트 → 3 + (6 × 10) = 63바이트
// iOS MTU 185바이트 이하 ✅

import 'dart:typed_data';

/// 인코딩에 사용할 세트 데이터 모델
class BleSetData {
  final double weightKg;      // 실제 무게 (kg 단위, 예: 100.0)
  final int reps;             // 반복 횟수 (0~255)
  final int restSeconds;      // 휴식 시간 초 (0~255)
  final int durationSeconds;  // 세트 소요 시간 초 (0~65535)

  const BleSetData({
    required this.weightKg,
    required this.reps,
    required this.restSeconds,
    required this.durationSeconds,
  });
}

/// BLE 세션 패킷 인코더
class BleSessionEncoder {

  /// [sessionId]와 [sets] 목록을 BLE 전송용 Uint8List로 변환
  ///
  /// 사전조건:
  ///   - sets.length <= 10 (최대 10세트)
  ///   - 각 weightKg: 0.0 ~ 999.9 범위
  ///   - 각 durationSeconds: 0 ~ 65535 범위
  static Uint8List encode({
    required int sessionId,
    required List<BleSetData> sets,
  }) {
    assert(sets.length <= 10, '세트 수가 10을 초과할 수 없습니다: ${sets.length}');
    assert(sessionId >= 0 && sessionId <= 0xFFFF, 'session_id 범위 초과');

    final int totalBytes = 3 + (sets.length * 6);
    final ByteData bd = ByteData(totalBytes);
    int offset = 0;

    // ── 헤더 (3바이트) ──────────────────────────
    bd.setUint16(offset, sessionId, Endian.little);  // Byte 0-1
    offset += 2;
    bd.setUint8(offset, sets.length);                // Byte 2
    offset += 1;

    // ── 세트 데이터 (세트당 6바이트) ─────────────
    for (final BleSetData set in sets) {
      final int weightEncoded = (set.weightKg * 10).round(); // 100.0kg → 1000

      bd.setUint16(offset, weightEncoded, Endian.little);  // Byte 0-1: weight
      offset += 2;
      bd.setUint8(offset, set.reps);                       // Byte 2: reps
      offset += 1;
      bd.setUint8(offset, set.restSeconds);                // Byte 3: rest
      offset += 1;
      bd.setUint16(offset, set.durationSeconds, Endian.little);  // Byte 4-5: duration
      offset += 2;
    }

    return bd.buffer.asUint8List();
  }

  /// 기준 예제 인코딩 테스트
  ///
  /// 예상 출력 (27바이트):
  ///   42 00 04
  ///   E8 03 0A 5A 1E 00
  ///   E8 03 08 5A 23 00
  ///   84 03 0A 5A 20 00
  ///   84 03 08 00 25 00
  static void runExampleTest() {
    final Uint8List packet = encode(
      sessionId: 0x0042,
      sets: const [
        BleSetData(weightKg: 100.0, reps: 10, restSeconds: 90,  durationSeconds: 30),
        BleSetData(weightKg: 100.0, reps: 8,  restSeconds: 90,  durationSeconds: 35),
        BleSetData(weightKg: 90.0,  reps: 10, restSeconds: 90,  durationSeconds: 32),
        BleSetData(weightKg: 90.0,  reps: 8,  restSeconds: 0,   durationSeconds: 37),
      ],
    );

    final List<int> expected = [
      0x42, 0x00, 0x04,
      0xE8, 0x03, 0x0A, 0x5A, 0x1E, 0x00,  // Set1: 100.0kg, 10회, 90s, 30s
      0xE8, 0x03, 0x08, 0x5A, 0x23, 0x00,  // Set2: 100.0kg, 8회, 90s, 35s
      0x84, 0x03, 0x0A, 0x5A, 0x20, 0x00,  // Set3: 90.0kg, 10회, 90s, 32s
      0x84, 0x03, 0x08, 0x00, 0x25, 0x00,  // Set4: 90.0kg, 8회, 0s, 37s
    ];

    assert(packet.length == 27, '패킷 크기 오류: ${packet.length}');
    for (int i = 0; i < expected.length; i++) {
      assert(packet[i] == expected[i], '바이트[$i] 불일치');
    }
    print('=== BleSessionEncoder 테스트 통과 ===');
  }
}
```

---

### 13.2 Session Data 디코딩 (C, Zephyr)

```c
/* firmware/src/ble/session_decoder.c
 *
 * BLE GATT 세션 데이터 패킷 디코딩
 * 대상: nRF52840 + Zephyr RTOS
 *
 * 기준 예제 (27바이트):
 *   42 00 04 E8 03 0A 5A 1E 00 E8 03 08 5A 23 00
 *   84 03 0A 5A 20 00 84 03 08 00 25 00
 */

#include <zephyr/kernel.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/logging/log.h>
#include <string.h>

LOG_MODULE_REGISTER(session_decoder, LOG_LEVEL_DBG);

#define FICA_MAX_SETS         10U
#define FICA_HEADER_SIZE      3U
#define FICA_SET_SIZE         6U
#define FICA_MAX_PACKET_SIZE  (FICA_HEADER_SIZE + FICA_MAX_SETS * FICA_SET_SIZE) /* 63 */
#define FICA_WEIGHT_SCALE     10U

typedef struct {
    uint16_t weight_x10;       /* 무게 × 10 (예: 1000 = 100.0kg) */
    uint8_t  reps;             /* 반복 횟수 */
    uint8_t  rest_seconds;     /* 휴식 시간 (초) */
    uint16_t duration_seconds; /* 세트 소요 시간 (초) */
} fica_set_t;

typedef struct {
    uint16_t   session_id;
    uint8_t    total_sets;
    fica_set_t sets[FICA_MAX_SETS];
} fica_session_t;

typedef enum {
    FICA_DECODE_OK       =  0,
    FICA_DECODE_ERR_NULL = -1,
    FICA_DECODE_ERR_SIZE = -2,
    FICA_DECODE_ERR_SETS = -3,
} fica_decode_result_t;

/* Little-Endian uint16 읽기 (비정렬 접근 안전) */
static inline uint16_t read_le16(const uint8_t *buf)
{
    uint16_t val;
    memcpy(&val, buf, sizeof(val));
    return sys_le16_to_cpu(val);
}

fica_decode_result_t fica_session_decode(
    const uint8_t *buf, size_t size, fica_session_t *out)
{
    if (!buf || !out) return FICA_DECODE_ERR_NULL;
    if (size < FICA_HEADER_SIZE) return FICA_DECODE_ERR_SIZE;

    const uint8_t *p = buf;

    /* 헤더 파싱 */
    out->session_id = read_le16(p); p += 2;
    out->total_sets = *p; p += 1;

    if (out->total_sets > FICA_MAX_SETS) return FICA_DECODE_ERR_SETS;

    const size_t expected = FICA_HEADER_SIZE + (size_t)out->total_sets * FICA_SET_SIZE;
    if (size != expected) return FICA_DECODE_ERR_SIZE;

    /* 세트 데이터 파싱 */
    for (uint8_t i = 0; i < out->total_sets; i++) {
        fica_set_t *s = &out->sets[i];
        s->weight_x10      = read_le16(p); p += 2;  /* E8 03 → 1000 → 100.0kg */
        s->reps             = *p; p += 1;
        s->rest_seconds     = *p; p += 1;
        s->duration_seconds = read_le16(p); p += 2;

        LOG_DBG("Set[%u]: %u.%ukg, %u회, 휴식%us, 소요%us",
                i, s->weight_x10 / FICA_WEIGHT_SCALE,
                s->weight_x10 % FICA_WEIGHT_SCALE,
                s->reps, s->rest_seconds, s->duration_seconds);
    }

    LOG_INF("세션 디코딩 완료: id=0x%04X, sets=%u", out->session_id, out->total_sets);
    return FICA_DECODE_OK;
}

/* 자가 검증 (부팅 시 1회 실행) */
void fica_session_decode_selftest(void)
{
    static const uint8_t pkt[] = {
        0x42, 0x00, 0x04,
        0xE8, 0x03, 0x0A, 0x5A, 0x1E, 0x00,
        0xE8, 0x03, 0x08, 0x5A, 0x23, 0x00,
        0x84, 0x03, 0x0A, 0x5A, 0x20, 0x00,
        0x84, 0x03, 0x08, 0x00, 0x25, 0x00,
    };
    fica_session_t s = {0};
    __ASSERT(fica_session_decode(pkt, sizeof(pkt), &s) == FICA_DECODE_OK, "디코딩 실패");
    __ASSERT(s.session_id == 0x0042, "session_id 오류");
    __ASSERT(s.total_sets == 4, "total_sets 오류");
    __ASSERT(s.sets[0].weight_x10 == 1000 && s.sets[0].reps == 10, "Set[0] 오류");
    __ASSERT(s.sets[3].weight_x10 == 900  && s.sets[3].reps == 8,  "Set[3] 오류");
    LOG_INF("=== fica_session_decode 자가 검증 통과 ===");
}
```

---

### 13.3 무게 변환 유틸리티

**Dart:**

```dart
// lib/core/utils/ble_weight_utils.dart
//
// 인코딩 규칙: 실제 무게(kg) × 10 → uint16
//   0.0kg → 0, 100.0kg → 1000 (0x03E8), 999.9kg → 9999 (0x270F)

/// BLE raw(uint16) → 실제 무게(kg)
double weightFromBle(int raw) {
  if (raw < 0 || raw > 9999) {
    throw ArgumentError('BLE 무게 raw 값 범위 초과 (0~9999): $raw');
  }
  return raw / 10.0;
}

/// 실제 무게(kg) → BLE raw(uint16)
int weightToBle(double kg) {
  if (kg < 0.0) throw ArgumentError('무게는 0 이상이어야 합니다: $kg');
  if (kg > 999.9) throw ArgumentError('무게 최대값(999.9kg) 초과: $kg');
  return (kg * 10).round();  // 부동소수점 오차 방지
}

/// 자가 검증 (앱 시작 시 1회)
void bleWeightUtilsSelfTest() {
  assert(weightToBle(100.0) == 1000);
  assert(weightToBle(90.0) == 900);
  assert(weightToBle(0.0) == 0);
  assert(weightFromBle(1000) == 100.0);
  assert(weightFromBle(0) == 0.0);

  // 왕복(round-trip) 검증
  for (final kg in [0.0, 2.5, 10.0, 22.5, 90.0, 100.0, 142.5, 999.9]) {
    final recovered = weightFromBle(weightToBle(kg));
    assert((recovered - kg).abs() < 0.05, '왕복 실패: $kg → $recovered');
  }
  print('=== bleWeightUtilsSelfTest 통과 ===');
}
```

**C (Zephyr, 정수 전용 — FPU 없이 동작):**

```c
/* firmware/include/fica_weight.h */
#ifndef FICA_WEIGHT_H
#define FICA_WEIGHT_H

#include <stdint.h>

/* 정수 연산 매크로 (nRF52840 FPU 없이도 동작) */
#define WEIGHT_FROM_BLE(raw_u16)      ((uint16_t)(raw_u16))
#define WEIGHT_TO_BLE(val_x10)        ((uint16_t)(val_x10))

/* 정수부/소수부 추출 */
#define WEIGHT_INTEGER_KG(raw_u16)    ((raw_u16) / 10U)   /* 1000 → 100 */
#define WEIGHT_DECIMAL(raw_u16)       ((raw_u16) % 10U)   /* 1000 → 0   */

/* 유효 범위 검사 */
#define WEIGHT_IS_VALID(raw_u16)      ((raw_u16) <= 9999U)
#define FICA_WEIGHT_MAX_RAW           9999U

/* LOG_INF 출력 헬퍼: LOG_INF("무게: " WEIGHT_FMT_STR, WEIGHT_FMT_ARGS(raw)); */
#define WEIGHT_FMT_STR                "%u.%ukg"
#define WEIGHT_FMT_ARGS(raw_u16)      WEIGHT_INTEGER_KG(raw_u16), WEIGHT_DECIMAL(raw_u16)

/* FPU 환경 전용 (호스트 테스트용) */
#ifdef CONFIG_FPU
#define WEIGHT_TO_BLE_F(kg_f)         ((uint16_t)((kg_f) * 10.0f + 0.5f))
#define WEIGHT_FROM_BLE_F(raw_u16)    ((float)(raw_u16) / 10.0f)
#endif

#endif /* FICA_WEIGHT_H */
```

---

### 13.4 Characteristic 읽기/쓰기 헬퍼 (Dart)

```dart
// lib/features/workout/data/ble_characteristic_helper.dart
//
// flutter_blue_plus API 래퍼
// UUID 체계: §4 Characteristic 매핑과 1:1 대응

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Fica UUID 상수 — §4 Characteristic 매핑 기준
class FicaUuid {
  FicaUuid._();

  static const String _suffix = '-0001-4000-8000-00805F9B34FB';

  // §3.1 Fica Fitness Service
  static const String service       = 'FCA00000$_suffix';

  // §4.1~4.12 Characteristics (12개, FCA00001~FCA0000C)
  static const String repCount      = 'FCA00001$_suffix'; // §4.1  Notify
  static const String weight        = 'FCA00002$_suffix'; // §4.2  Read/Write/Notify
  static const String setStatus     = 'FCA00003$_suffix'; // §4.3  Notify
  static const String currentSet    = 'FCA00004$_suffix'; // §4.4  Read/Notify
  static const String totalSets     = 'FCA00005$_suffix'; // §4.5  Read/Write
  static const String restTimer     = 'FCA00006$_suffix'; // §4.6  Notify
  static const String restDuration  = 'FCA00007$_suffix'; // §4.7  Read/Write
  static const String sessionData   = 'FCA00008$_suffix'; // §4.8  Indicate
  static const String equipmentId   = 'FCA00009$_suffix'; // §4.9  Read
  static const String command       = 'FCA0000A$_suffix'; // §4.10 Write
  static const String imuStatus     = 'FCA0000B$_suffix'; // §4.11 Read/Notify
  static const String errorCode     = 'FCA0000C$_suffix'; // §4.12 Notify
}

/// BLE Characteristic 헬퍼
class BleCharacteristicHelper {
  final BluetoothDevice device;

  BleCharacteristicHelper(this.device);

  /// UUID로 Characteristic 찾기 (discoverServices 사전 호출 필요)
  Future<BluetoothCharacteristic> _findCharacteristic(String uuid) async {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.uuid.toString().toUpperCase() == uuid.toUpperCase()) {
          return char;
        }
      }
    }
    throw StateError('Characteristic 없음: $uuid');
  }

  /// uint16 LE Write (예: 무게 100.0kg → writeUint16(FicaUuid.weight, 1000))
  Future<void> writeUint16(String uuid, int value, {bool withResponse = true}) async {
    assert(value >= 0 && value <= 0xFFFF, 'uint16 범위 초과: $value');
    final char = await _findCharacteristic(uuid);
    final bd = ByteData(2)..setUint16(0, value, Endian.little);
    await char.write(bd.buffer.asUint8List().toList(), withoutResponse: !withResponse);
  }

  /// uint16 LE Read
  Future<int> readUint16(String uuid) async {
    final char = await _findCharacteristic(uuid);
    final bytes = await char.read();
    if (bytes.length < 2) throw StateError('바이트 부족: ${bytes.length}');
    final bd = ByteData.sublistView(Uint8List.fromList(bytes));
    return bd.getUint16(0, Endian.little);
  }

  /// uint8 Write (예: 커맨드 0x01 → writeUint8(FicaUuid.command, 0x01))
  Future<void> writeUint8(String uuid, int value) async {
    assert(value >= 0 && value <= 0xFF, 'uint8 범위 초과: $value');
    final char = await _findCharacteristic(uuid);
    await char.write([value]);
  }

  /// Notify/Indicate 구독
  Future<Stream<List<int>>> subscribe(String uuid) async {
    final char = await _findCharacteristic(uuid);
    if (!char.properties.notify && !char.properties.indicate) {
      throw StateError('$uuid: Notify/Indicate 미지원');
    }
    await char.setNotifyValue(true);
    return char.onValueReceived;
  }

  /// 구독 해제
  Future<void> unsubscribe(String uuid) async {
    final char = await _findCharacteristic(uuid);
    await char.setNotifyValue(false);
  }

  /// Android MTU 협상 (iOS는 자동)
  Future<int> negotiateMtu(int requestedMtu) async {
    final actual = await device.requestMtu(requestedMtu);
    print('=== MTU 협상: $actual바이트 ===');
    return actual;
  }
}
```

---

### 13.5 검증 체크리스트

#### V1. UUID 고유성 검증

| # | UUID 접두부 | 용도 | 속성 |
|---|-----------|------|------|
| 1 | FCA00001 | Rep Count | Notify |
| 2 | FCA00002 | Weight | R/W/N |
| 3 | FCA00003 | Set Status | Notify |
| 4 | FCA00004 | Current Set | R/N |
| 5 | FCA00005 | Total Sets | R/W |
| 6 | FCA00006 | Rest Timer | Notify |
| 7 | FCA00007 | Rest Duration | R/W |
| 8 | FCA00008 | Session Data | Indicate |
| 9 | FCA00009 | Equipment ID | Read |
| 10 | FCA0000A | Command | Write |
| 11 | FCA0000B | IMU Status | R/N |
| 12 | FCA0000C | Error Code | Notify |

12개 모두 고유, 순차 할당 ✅

#### V2. 패킷 크기 검증

최대 10세트 = 3 + (10 × 6) = **63바이트**

| 플랫폼 | MTU | 패킷(63B) | 여유 |
|--------|-----|-----------|------|
| iOS | 185B | 63B | 122B ✅ |
| Android | 247B+ | 63B | 184B+ ✅ |
| nRF52840 | 247B | 63B | 184B ✅ |

#### V3. 인코딩 ↔ 디코딩 바이트 일치

기준 예제 (4세트, session_id=0x0042):

```
전체 raw: 42 00 04 E8 03 0A 5A 1E 00 E8 03 08 5A 23 00
          84 03 0A 5A 20 00 84 03 08 00 25 00
총 27바이트
```

| 위치 | 필드 | 값 | Hex(LE) |
|------|------|-----|---------|
| Byte 0-1 | session_id | 0x0042 | `42 00` |
| Byte 2 | total_sets | 4 | `04` |
| Byte 3-4 | Set1 weight | 1000 (100.0kg) | `E8 03` |
| Byte 5 | Set1 reps | 10 | `0A` |
| Byte 6 | Set1 rest | 90 | `5A` |
| Byte 7-8 | Set1 duration | 30 | `1E 00` |
| Byte 21-22 | Set4 weight | 900 (90.0kg) | `84 03` |
| Byte 23 | Set4 reps | 8 | `08` |
| Byte 24 | Set4 rest | 0 | `00` |
| Byte 25-26 | Set4 duration | 37 | `25 00` |

Dart `BleSessionEncoder.encode()` 출력 == C `fica_session_decode()` 입력 ✅

#### V4. 무게 왕복 검증

| 입력(kg) | weightToBle() | weightFromBle() | 결과 |
|---------|---------------|-----------------|------|
| 0.0 | 0 (0x0000) | 0.0kg | ✅ |
| 90.0 | 900 (0x0384) | 90.0kg | ✅ |
| 100.0 | 1000 (0x03E8) | 100.0kg | ✅ |
| 999.9 | 9999 (0x270F) | 999.9kg | ✅ |
| -1.0 | ArgumentError | — | ✅ 거부 |
| 1000.0 | ArgumentError | — | ✅ 거부 |

#### V5. 종합 합격 기준

| # | 항목 | 결과 |
|---|------|------|
| 1 | UUID 12개 전부 고유 + 연속 (FCA00001~FCA0000C) | ✅ |
| 2 | Session Data 10세트 = 63 bytes < 185 (iOS MTU) | ✅ |
| 3 | Dart 인코딩 ↔ C 디코딩 바이트 일치 | ✅ |
| 4 | Weight 100.0kg → 0x03E8 → 100.0kg 라운드트립 | ✅ |
| 5 | Set Status 상태 머신 — STEP 0~6 전체 1:1 매핑 | ✅ |
| 6 | Command 코드 — 종합 개발 가이드 §5.3.1과 일관성 | ✅ |
| 7 | FACTORY_RESET에 confirm 바이트(0xAA) 안전 장치 | ✅ |

---

> **문서 끝** — v1.0 확정
> 이 스펙을 기반으로 Team 2(펌웨어)와 Team 4(앱)가 독립적으로 개발을 시작할 수 있습니다.
