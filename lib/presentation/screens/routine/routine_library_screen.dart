import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/preset_routine_model.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/providers/preset_routine_provider.dart';
import '../../widgets/molecules/preset_routine_card.dart';
import 'preset_routine_detail_sheet.dart';

/// 프리셋 루틴 라이브러리 화면
class RoutineLibraryScreen extends ConsumerStatefulWidget {
  const RoutineLibraryScreen({super.key});

  @override
  ConsumerState<RoutineLibraryScreen> createState() => _RoutineLibraryScreenState();
}

class _RoutineLibraryScreenState extends ConsumerState<RoutineLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_FilterTab> _tabs = [
    const _FilterTab(label: '전체', difficulty: null),
    const _FilterTab(label: '초급', difficulty: ExperienceLevel.beginner),
    const _FilterTab(label: '중급', difficulty: ExperienceLevel.intermediate),
    const _FilterTab(label: '고급', difficulty: ExperienceLevel.advanced),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final selectedTab = _tabs[_tabController.index];
      ref.read(presetRoutineFilterStateProvider.notifier).setDifficulty(
            selectedTab.difficulty,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
        title: Text(
          '전문가 루틴',
          style: AppTypography.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => _RoutineList(difficulty: tab.difficulty)).toList(),
      ),
    );
  }

  Widget _buildTabBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary500,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: AppTypography.labelMedium,
        unselectedLabelStyle: AppTypography.labelMedium,
        dividerColor: Colors.transparent,
        tabs: _tabs.map((tab) => Tab(text: tab.label)).toList(),
      ),
    );
  }
}

class _FilterTab {
  final String label;
  final ExperienceLevel? difficulty;

  const _FilterTab({
    required this.label,
    required this.difficulty,
  });
}

/// 루틴 리스트 (탭별 콘텐츠)
class _RoutineList extends ConsumerWidget {
  final ExperienceLevel? difficulty;

  const _RoutineList({this.difficulty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = difficulty == null
        ? ref.watch(presetRoutinesProvider)
        : ref.watch(presetRoutinesByDifficultyProvider(difficulty!));

    return routinesAsync.when(
      data: (routines) {
        if (routines.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildRoutineList(context, routines);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary500,
        ),
      ),
      error: (error, stack) => _buildErrorState(context, error.toString()),
    );
  }

  Widget _buildRoutineList(BuildContext context, List<PresetRoutineModel> routines) {
    // 추천 루틴을 먼저 표시
    final sortedRoutines = [...routines];
    sortedRoutines.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      return b.popularityScore.compareTo(a.popularityScore);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: sortedRoutines.length,
      itemBuilder: (context, index) {
        final routine = sortedRoutines[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: PresetRoutineCard(
            routine: routine,
            onTap: () => _showRoutineDetail(context, routine),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '아직 루틴이 없어요',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '곧 새로운 루틴이 추가됩니다',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '루틴을 불러오는데 실패했어요',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showRoutineDetail(BuildContext context, PresetRoutineModel routine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => PresetRoutineDetailSheet(routineId: routine.id),
    );
  }
}
