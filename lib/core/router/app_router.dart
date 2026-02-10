import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/history/history_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/routine/routine_library_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/stats/stats_screen.dart';
import '../../presentation/screens/exercise/exercise_detail_screen.dart';
import '../../presentation/screens/workout/workout_screen.dart';

/// V2log 앱 라우터
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth
      GoRoute(
        path: '/auth',
        name: 'auth',
        redirect: (context, state) {
          if (state.fullPath == '/auth') {
            return '/auth/login';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      ),

      // Main (Bottom Navigation Shell)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // History
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryScreen(),
            routes: [
              GoRoute(
                path: ':sessionId',
                name: 'history-detail',
                builder: (context, state) {
                  final sessionId = state.pathParameters['sessionId']!;
                  return HistoryDetailScreen(sessionId: sessionId);
                },
              ),
            ],
          ),

          // Stats
          GoRoute(
            path: '/stats',
            name: 'stats',
            builder: (context, state) => const StatsScreen(),
          ),

          // Profile
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Workout (운동 진행 - Shell 외부)
      GoRoute(
        path: '/workout',
        name: 'workout',
        redirect: (context, state) {
          if (state.fullPath == '/workout') {
            return '/workout/session/active';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'ai',
            name: 'workout-ai',
            builder: (context, state) => const WorkoutScreen(),
          ),
          GoRoute(
            path: 'free',
            name: 'workout-free',
            builder: (context, state) => const WorkoutScreen(),
          ),
          GoRoute(
            path: 'session/:sessionId',
            name: 'workout-session',
            builder: (context, state) {
              final sessionId = state.pathParameters['sessionId'];
              return WorkoutScreen(sessionId: sessionId);
            },
          ),
        ],
      ),

      // Routine
      GoRoute(
        path: '/routine',
        name: 'routine',
        redirect: (context, state) {
          if (state.fullPath == '/routine') {
            return '/routine/library';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'library',
            name: 'routine-library',
            builder: (context, state) => const RoutineLibraryScreen(),
          ),
          GoRoute(
            path: 'create',
            name: 'routine-create',
            builder: (context, state) =>
                const _PlaceholderScreen(title: '루틴 생성'),
          ),
          GoRoute(
            path: ':routineId',
            name: 'routine-detail',
            builder: (context, state) {
              final routineId = state.pathParameters['routineId']!;
              return _PlaceholderScreen(title: '루틴: $routineId');
            },
          ),
        ],
      ),

      // Exercise Detail
      GoRoute(
        path: '/exercise/:exerciseId',
        name: 'exercise-detail',
        builder: (context, state) {
          final exerciseId = state.pathParameters['exerciseId']!;
          return ExerciseDetailScreen(exerciseId: exerciseId);
        },
      ),
    ],
  );
}

/// 메인 셸 (하단 네비게이션)
class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);
    final indicatorColor = AppColors.primary500.withValues(alpha: 0.2);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        backgroundColor: navBgColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: indicatorColor,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary500),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
            selectedIcon: const Icon(Icons.calendar_today, color: AppColors.primary500),
            label: '기록',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
            selectedIcon: const Icon(Icons.bar_chart, color: AppColors.primary500),
            label: '통계',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
            selectedIcon: const Icon(Icons.person, color: AppColors.primary500),
            label: '프로필',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/stats')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/stats');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}

/// 플레이스홀더 화면 (개발 중)
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '개발 중입니다',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
