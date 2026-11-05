import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/quick_action_sheet.dart';
import 'widgets/greeting_header.dart';
import 'widgets/next_reminder_card.dart';
import 'widgets/quick_action_grid.dart';
import 'widgets/today_summary_card.dart';
import 'widgets/upcoming_reminders_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              const SliverToBoxAdapter(child: GreetingHeader()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              const SliverToBoxAdapter(child: NextReminderCard()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              SliverToBoxAdapter(
                child: QuickActionGrid(
                  onNewReminder: () => QuickActionSheet.show(context),
                  onNewTask: () => context.go('/tasks'),
                  onCalendar: () => context.go('/calendar'),
                  onFocus: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Focus timer coming in Phase 5'),
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              const SliverToBoxAdapter(child: TodaySummaryCard()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              const SliverToBoxAdapter(child: UpcomingRemindersList()),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                ), // Bottom padding for FAB and navigation bar
              ),
            ],
          ),
        ),
      ),
    );
  }
}
