import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'package:v2log/shared/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 시스템 UI 설정 (모바일용)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0F0F0F),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // 화면 방향 고정 (세로)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // .env 파일 로드 (존재하는 경우에만)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Error logged silently
  }

  // Supabase 초기화
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
    } catch (_) {
      // Error logged silently
    }
  }

  // Hive 초기화 (로컬 캐싱)
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('cache');
  await Hive.openBox('workout');

  // 알림 서비스 초기화 (앱 시작 전에 완료)
  try {
    await NotificationService().initialize();
  } catch (_) {
    // Error logged silently
  }

  runApp(
    const ProviderScope(
      child: V2logApp(),
    ),
  );
}
