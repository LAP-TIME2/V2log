---
name: cv-test
description: CV 기능 빌드 후 실기기(R3CN90HVMKL) 테스트 실행
---

# /cv-test 스킬

CV 관련 코드를 수정한 후 빌드+실기기 테스트를 한 번에 실행합니다.

## 실행 순서

1. `dart run build_runner build --delete-conflicting-outputs` 실행하여 코드 생성 (.g.dart 파일)
2. 빌드 성공 시 `flutter run -d R3CN90HVMKL` 실행하여 실기기에서 앱 실행
3. 빌드 실패 시 에러 내용을 분석하고 수정 방안 제시

## 주의사항

- build_runner가 실패하면 flutter run을 실행하지 말 것
- flutter run 실패 시 에러 로그를 읽고 원인 분석 후 보고
