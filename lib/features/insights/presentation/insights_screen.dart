import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/database/database.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../transactions/presentation/add_transaction_sheet.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(transactionsProvider);
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(AppTheme.spaceMargin),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppTheme.spaceSm,
                    bottom: AppTheme.spaceLg,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Insights',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      PressableScale(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddTransactionSheet(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryButtonGradient,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                            boxShadow: AppTheme.ambientGlow(
                              color: AppColors.primaryEmerald,
                              opacity: 0.25,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Record',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                transactionsAsync.when(
                  data: (transactions) {
                    final expenses = transactions
                        .where((t) => t.type == TransactionType.expense)
                        .toList();

                    if (expenses.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return settingsAsync.when(
                      data: (settings) =>
                          _buildInsightsList(context, expenses, settings),
                      loading: () => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => _buildEmptyState(context),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (_, __) => _buildEmptyState(context),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsList(
    BuildContext context,
    List<Transaction> expenses,
    Setting settings,
  ) {
    final symbol = CurrencyHelper.getSymbol(settings.currency);
    final totalSpent = expenses.fold(0.0, (sum, t) => sum + t.amount);

    final needSpent = expenses
        .where((t) => t.isNeed)
        .fold(0.0, (sum, t) => sum + t.amount);
    final wantSpent = totalSpent - needSpent;
    final needRatio = totalSpent > 0 ? (needSpent / totalSpent) : 1.0;
    final healthScore = (needRatio * 100).round().clamp(0, 100);

    final catTotals = <TransactionCategory, double>{};
    for (final t in expenses) {
      catTotals[t.category] = (catTotals[t.category] ?? 0) + t.amount;
    }
    final sortedCats = catTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategory = sortedCats.isNotEmpty ? sortedCats.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Text(
                    '$healthScore',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discipline Score: $healthScore/100',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(needRatio * 100).toStringAsFixed(0)}% of spending goes to essential needs ($symbol${needSpent.toStringAsFixed(0)}), ${(100 - needRatio * 100).toStringAsFixed(0)}% to discretionary wants ($symbol${wantSpent.toStringAsFixed(0)}).',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppTheme.spaceLg),

        Text(
          'Automated Observations',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppTheme.spaceMd),

        _buildObservationCard(
          context,
          icon: Icons.trending_down_rounded,
          iconColor: AppColors.primaryEmerald,
          title: 'Total Logged Volume',
          subtitle:
              '$symbol${totalSpent.toStringAsFixed(2)} across ${expenses.length} expenditure transactions.',
        ),

        const SizedBox(height: AppTheme.spaceSm),

        if (topCategory != null)
          _buildObservationCard(
            context,
            icon: Icons.pie_chart_rounded,
            iconColor: AppColors.tertiary,
            title: 'Top Category: ${topCategory.key.name.toUpperCase()}',
            subtitle:
                '$symbol${topCategory.value.toStringAsFixed(2)} (${((topCategory.value / totalSpent) * 100).toStringAsFixed(0)}% of total expenditure).',
          ),

        const SizedBox(height: AppTheme.spaceSm),

        _buildObservationCard(
          context,
          icon: Icons.shield_outlined,
          iconColor: AppColors.accentIndigo,
          title: 'All data stored locally on your device',
          subtitle:
              'All metrics and trends are computed strictly offline with zero third-party telemetry.',
        ),
      ],
    );
  }

  Widget _buildObservationCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryEmerald.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryEmerald,
              size: 28,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLg),
          Text(
            'Live Intelligence',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            'Log your daily expenditures to unlock automated cashflow forecasting, category breakdowns, and discipline metrics.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
