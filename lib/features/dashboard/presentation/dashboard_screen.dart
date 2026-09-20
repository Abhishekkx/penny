import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/database/database.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../transactions/presentation/add_transaction_sheet.dart';
import '../../ai_chat/presentation/talk_to_pocket_screen.dart';

enum SpendingPeriod { day, week, month, year }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _balanceController;
  late Animation<double> _balanceAnimation;
  SpendingPeriod _selectedPeriod = SpendingPeriod.day;
  int _selectedDayOffset = 0; // 0 = Today, 1 = Yesterday, 2 = 2 days ago, etc.
  String _selectedSourceId = 'all';

  @override
  void initState() {
    super.initState();
    _balanceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _balanceAnimation = CurvedAnimation(
      parent: _balanceController,
      curve: Curves.easeOutCubic,
    );
    _balanceController.forward();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  void _openRecordExpenditure([
    TransactionType type = TransactionType.expense,
  ]) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionSheet(initialType: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spaceMargin,
                    AppTheme.spaceMd,
                    AppTheme.spaceMargin,
                    AppTheme.spaceSm,
                  ),
                  child: settingsAsync.when(
                    data: (settings) {
                      final greeting = _getGreeting();
                      final name = settings.userName.isNotEmpty
                          ? settings.userName
                          : 'there';

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Hi, $name',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                          PressableScale(
                            onTap: () =>
                                _openRecordExpenditure(TransactionType.expense),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryButtonGradient,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusFull,
                                ),
                                boxShadow: AppTheme.ambientGlow(
                                  color: AppColors.primaryEmerald,
                                  opacity: 0.35,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Record Expenditure',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(height: 52),
                    error: (_, __) => const SizedBox(height: 52),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMargin,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppTheme.spaceSm),

                    settingsAsync.when(
                      data: (settings) {
                        return transactionsAsync.when(
                          data: (transactions) {
                            final totalBalance = _calculateBalance(
                              transactions,
                              settings,
                            );
                            final totalSpent = _calculateTotalSpent(
                              transactions,
                              settings,
                            );
                            final totalIncome = _calculateTotalIncome(
                              transactions,
                              settings,
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildIncomeSourceFilterBar(settings, isDark),
                                _buildHeroCard(
                                  context,
                                  totalBalance,
                                  totalSpent,
                                  totalIncome,
                                  settings.currency,
                                ),
                              ],
                            );
                          },
                          loading: () => _buildHeroCard(
                            context,
                            settings.monthlyIncome,
                            0,
                            settings.monthlyIncome,
                            settings.currency,
                          ),
                          error: (_, __) => _buildHeroCard(
                            context,
                            settings.monthlyIncome,
                            0,
                            settings.monthlyIncome,
                            settings.currency,
                          ),
                        );
                      },
                      loading: () => _buildHeroCard(context, 0, 0, 0, 'INR'),
                      error: (_, __) => _buildHeroCard(context, 0, 0, 0, 'INR'),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),

                    PressableScale(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TalkToPocketScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0F766E),
                              Color(0xFF059669),
                              Color(0xFF10B981),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLg,
                          ),
                          boxShadow: AppTheme.ambientGlow(
                            color: AppColors.primaryEmerald,
                            opacity: 0.3,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Talk to your Pocket',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusFull,
                                          ),
                                        ),
                                        child: Text(
                                          'AI Coach',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Ask questions about your budget, savings & trends',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spaceLg),

                    _buildPeriodSelector(isDark),

                    const SizedBox(height: AppTheme.spaceMd),

                    transactionsAsync.when(
                      data: (transactions) {
                        return settingsAsync.when(
                          data: (settings) => _buildPeriodContent(
                            context,
                            transactions,
                            settings,
                            isDark,
                          ),
                          loading: () => const SizedBox(height: 100),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    const SizedBox(height: AppTheme.spaceLg),

                    settingsAsync.when(
                      data: (settings) {
                        return transactionsAsync.when(
                          data: (transactions) {
                            final budget = ref.watch(budgetProvider).value;
                            return _SavingsTargetCard(
                              settings: settings,
                              budget: budget,
                              transactions: transactions,
                              isDark: isDark,
                              selectedSourceId: _selectedSourceId,
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    const SizedBox(height: AppTheme.spaceLg),

                    _buildDynamicTrendChart(context, ref, isDark),

                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeSourceFilterBar(Setting settings, bool isDark) {
    final sources = parseIncomeSources(settings.incomeSources);
    if (sources.isEmpty) return const SizedBox.shrink();

    final symbol = CurrencyHelper.getSymbol(settings.currency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'INCOME STREAM FILTER',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
            if (_selectedSourceId != 'all')
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedSourceId = 'all');
                },
                child: Text(
                  'Reset to All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryEmerald,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSourceChip(
                id: 'all',
                label: 'All Sources',
                amount: settings.monthlyIncome,
                symbol: symbol,
                isDark: isDark,
                icon: Icons.account_balance_wallet_rounded,
              ),
              ...sources.map((s) => _buildSourceChip(
                    id: s.id,
                    label: s.name,
                    amount: s.amount,
                    symbol: symbol,
                    isDark: isDark,
                    icon: _getIconForCategoryName(s.category),
                  )),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spaceMd),
      ],
    );
  }

  Widget _buildSourceChip({
    required String id,
    required String label,
    required double amount,
    required String symbol,
    required bool isDark,
    required IconData icon,
  }) {
    final isSelected = _selectedSourceId == id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedSourceId = id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryEmerald
              : (isDark ? AppColors.darkSurface : AppColors.gray100),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryEmerald
                : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.cardBorder),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? AppTheme.ambientGlow(
                  color: AppColors.primaryEmerald,
                  opacity: 0.3,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : AppColors.onSurface),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.primaryEmerald.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                '$symbol${amount.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.primaryEmerald,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategoryName(String cat) {
    switch (cat.toLowerCase()) {
      case 'salary':
        return Icons.work_outline_rounded;
      case 'freelance':
        return Icons.laptop_mac_rounded;
      case 'business':
        return Icons.storefront_rounded;
      case 'investment':
        return Icons.trending_up_rounded;
      case 'rental':
        return Icons.home_work_outlined;
      default:
        return Icons.attach_money_rounded;
    }
  }

  double _getActiveMonthlyIncome(Setting settings) {
    if (_selectedSourceId == 'all') return settings.monthlyIncome;
    final sources = parseIncomeSources(settings.incomeSources);
    final selectedSource = sources.firstWhere(
      (s) => s.id == _selectedSourceId,
      orElse: () => IncomeSourceItem(
        id: 'all',
        name: 'All',
        amount: settings.monthlyIncome,
      ),
    );
    return selectedSource.amount;
  }

  List<Transaction> _getFilteredTransactions(
    List<Transaction> transactions,
    Setting settings,
  ) {
    if (_selectedSourceId == 'all') return transactions;

    final sources = parseIncomeSources(settings.incomeSources);
    final selectedSource = sources.firstWhere(
      (s) => s.id == _selectedSourceId,
      orElse: () => IncomeSourceItem(id: 'all', name: 'All', amount: 0),
    );

    return transactions.where((t) {
      if (t.type == TransactionType.expense) return true;
      final noteLower = t.note.toLowerCase();
      final sourceNameLower = selectedSource.name.toLowerCase();
      final catLower = selectedSource.category.toLowerCase();
      return noteLower.contains(sourceNameLower) ||
          t.category.name.toLowerCase().contains(catLower);
    }).toList();
  }

  double _calculateBalance(
    List<Transaction> transactions,
    Setting settings,
  ) {
    final activeIncome = _getActiveMonthlyIncome(settings);
    double balance = activeIncome;
    if (_selectedSourceId == 'all') {
      balance += settings.initialSavingsBalance;
      balance -= settings.priorSpentThisMonth;
    }
    final filtered = _getFilteredTransactions(transactions, settings);
    for (final transaction in filtered) {
      if (transaction.type == TransactionType.expense) {
        balance -= transaction.amount;
      } else if (transaction.type == TransactionType.income) {
        balance += transaction.amount;
      }
    }
    return balance;
  }

  double _calculateTotalSpent(
    List<Transaction> transactions,
    Setting settings,
  ) {
    final filtered = _getFilteredTransactions(transactions, settings);
    final transSpent = filtered
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return transSpent +
        (_selectedSourceId == 'all' ? settings.priorSpentThisMonth : 0.0);
  }

  double _calculateTotalIncome(
    List<Transaction> transactions,
    Setting settings,
  ) {
    final activeIncome = _getActiveMonthlyIncome(settings);
    final filtered = _getFilteredTransactions(transactions, settings);
    final transIncome = filtered
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    return activeIncome + transIncome;
  }

  Widget _buildHeroCard(
    BuildContext context,
    double balance,
    double spent,
    double income,
    String currency,
  ) {
    return PrimaryHeroCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'All data stored locally on your device',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          AnimatedBuilder(
            animation: _balanceAnimation,
            builder: (context, child) {
              final animatedBalance = balance * _balanceAnimation.value;
              return Text(
                CurrencyHelper.formatAmountWithDecimals(
                  animatedBalance,
                  currency,
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spaceLg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              CurrencyHelper.formatAmount(income, currency),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expenditure',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              CurrencyHelper.formatAmount(spent, currency),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    final periods = [
      (SpendingPeriod.day, 'Daily'),
      (SpendingPeriod.week, 'Weekly'),
      (SpendingPeriod.month, 'Monthly'),
      (SpendingPeriod.year, 'Yearly'),
    ];

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: periods.map((p) {
          final isSelected = _selectedPeriod == p.$1;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedPeriod = p.$1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.darkSurfaceHigh : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm + 2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  p.$2,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.onSurface)
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPeriodContent(
    BuildContext context,
    List<Transaction> allTransactions,
    Setting settings,
    bool isDark,
  ) {
    switch (_selectedPeriod) {
      case SpendingPeriod.day:
        return _buildDailyExpenditureSection(
          context,
          allTransactions,
          settings,
          isDark,
        );
      case SpendingPeriod.week:
        return _buildWeeklyExpenditureSection(
          context,
          allTransactions,
          settings,
          isDark,
        );
      case SpendingPeriod.month:
        return _buildMonthlyExpenditureSection(
          context,
          allTransactions,
          settings,
          isDark,
        );
      case SpendingPeriod.year:
        return _buildYearlyExpenditureSection(
          context,
          allTransactions,
          settings,
          isDark,
        );
    }
  }

  Widget _buildDailyExpenditureSection(
    BuildContext context,
    List<Transaction> transactions,
    Setting settings,
    bool isDark,
  ) {
    final now = DateTime.now();
    final targetDate = now.subtract(Duration(days: _selectedDayOffset));

    final dayExpenses = transactions.where((t) {
      return t.type == TransactionType.expense &&
          t.date.year == targetDate.year &&
          t.date.month == targetDate.month &&
          t.date.day == targetDate.day;
    }).toList();

    final dayTotal = dayExpenses.fold(0.0, (sum, t) => sum + t.amount);
    final symbol = CurrencyHelper.getSymbol(settings.currency);

    String dayLabel;
    if (_selectedDayOffset == 0) {
      dayLabel = "Today's Expenditure";
    } else if (_selectedDayOffset == 1) {
      dayLabel = "Yesterday's Expenditure";
    } else {
      dayLabel = '${DateFormat('MMM dd').format(targetDate)} Expenditure';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) {
              final d = now.subtract(Duration(days: index));
              final isSelected = _selectedDayOffset == index;
              final isToday = index == 0;
              final isYesterday = index == 1;

              String title = isToday
                  ? 'Today'
                  : isYesterday
                  ? 'Yesterday'
                  : DateFormat('EEE').format(d);
              String subtitle = DateFormat('MMM d').format(d);

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedDayOffset = index);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryEmerald.withValues(alpha: 0.16)
                        : (isDark ? AppColors.darkSurface : AppColors.gray100),
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryEmerald
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppColors.cardBorder),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected
                              ? AppColors.primaryEmerald
                              : (isDark ? Colors.white : AppColors.onSurface),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppTheme.spaceMd),

        GlassCard(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dayLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      '${dayExpenses.length} ${dayExpenses.length == 1 ? 'item' : 'items'}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$symbol${dayTotal.toStringAsFixed(2)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : AppColors.onSurface,
                ),
              ),

              if (dayExpenses.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spaceMd),
                const Divider(height: 1),
                const SizedBox(height: AppTheme.spaceSm),
                ...dayExpenses.map(
                  (t) => _buildTransactionItem(t, symbol, isDark),
                ),
              ] else ...[
                const SizedBox(height: AppTheme.spaceMd),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No expenditures logged for this day',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyExpenditureSection(
    BuildContext context,
    List<Transaction> transactions,
    Setting settings,
    bool isDark,
  ) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final symbol = CurrencyHelper.getSymbol(settings.currency);

    final thisWeekExpenses = transactions.where((t) {
      return t.type == TransactionType.expense &&
          t.date.isAfter(startOfWeek.subtract(const Duration(seconds: 1)));
    }).toList();

    final weekTotal = thisWeekExpenses.fold(0.0, (sum, t) => sum + t.amount);

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Week\'s Expenditure',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${thisWeekExpenses.length} transactions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$symbol${weekTotal.toStringAsFixed(2)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (thisWeekExpenses.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spaceMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spaceSm),
            ...thisWeekExpenses
                .take(6)
                .map((t) => _buildTransactionItem(t, symbol, isDark)),
          ] else ...[
            const SizedBox(height: AppTheme.spaceMd),
            Center(
              child: Text(
                'No expenditures logged this week',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthlyExpenditureSection(
    BuildContext context,
    List<Transaction> transactions,
    Setting settings,
    bool isDark,
  ) {
    final now = DateTime.now();
    final symbol = CurrencyHelper.getSymbol(settings.currency);

    final thisMonthExpenses = transactions.where((t) {
      return t.type == TransactionType.expense &&
          t.date.year == now.year &&
          t.date.month == now.month;
    }).toList();

    final monthTotal = thisMonthExpenses.fold(0.0, (sum, t) => sum + t.amount);

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateFormat('MMMM yyyy').format(now)} Expenditure',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${thisMonthExpenses.length} transactions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$symbol${monthTotal.toStringAsFixed(2)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (thisMonthExpenses.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spaceMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spaceSm),
            ...thisMonthExpenses
                .take(8)
                .map((t) => _buildTransactionItem(t, symbol, isDark)),
          ] else ...[
            const SizedBox(height: AppTheme.spaceMd),
            Center(
              child: Text(
                'No expenditures logged this month',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYearlyExpenditureSection(
    BuildContext context,
    List<Transaction> transactions,
    Setting settings,
    bool isDark,
  ) {
    final now = DateTime.now();
    final symbol = CurrencyHelper.getSymbol(settings.currency);

    final thisYearExpenses = transactions.where((t) {
      return t.type == TransactionType.expense && t.date.year == now.year;
    }).toList();

    final yearTotal = thisYearExpenses.fold(0.0, (sum, t) => sum + t.amount);

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${now.year} Annual Expenditure',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${thisYearExpenses.length} transactions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$symbol${yearTotal.toStringAsFixed(2)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (thisYearExpenses.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spaceMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spaceSm),
            ...thisYearExpenses
                .take(8)
                .map((t) => _buildTransactionItem(t, symbol, isDark)),
          ] else ...[
            const SizedBox(height: AppTheme.spaceMd),
            Center(
              child: Text(
                'No expenditures logged for ${now.year}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction t, String symbol, bool isDark) {
    final timeStr = DateFormat('h:mm a').format(t.date);
    final categoryName =
        t.category.name[0].toUpperCase() + t.category.name.substring(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryEmerald.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForCategory(t.category),
              size: 18,
              color: AppColors.primaryEmerald,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.note.isNotEmpty ? t.note : categoryName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$categoryName • $timeStr',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- $symbol${t.amount.toStringAsFixed(2)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transport:
        return Icons.directions_car_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.housing:
        return Icons.home_rounded;
      case TransactionCategory.health:
        return Icons.medical_services_rounded;
      case TransactionCategory.fun:
        return Icons.celebration_rounded;
      case TransactionCategory.travel:
        return Icons.flight_rounded;
      case TransactionCategory.salary:
        return Icons.account_balance_wallet_rounded;
      case TransactionCategory.freelance:
        return Icons.work_rounded;
      case TransactionCategory.investment:
        return Icons.trending_up_rounded;
      case TransactionCategory.other:
        return Icons.receipt_long_rounded;
    }
  }

  Widget _buildDynamicTrendChart(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
  ) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expenditure Trend (30 Days)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  'Live Data',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryEmerald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLg),
          SizedBox(
            height: 160,
            child: transactionsAsync.when(
              data: (transactions) {
                final expenses = transactions
                    .where((t) => t.type == TransactionType.expense)
                    .toList();

                if (expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.query_stats_rounded,
                          size: 32,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No expenditure records yet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final chartSpots = _calculateRealChartSpots(expenses);

                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.04),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Day ${value.toInt()}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 1,
                    maxX: 30,
                    minY: 0,
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) =>
                            isDark ? AppColors.darkSurfaceHigh : Colors.white,
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        getTooltipItems: (spots) => spots.map((s) {
                          return LineTooltipItem(
                            'Day ${s.x.toInt()}: \$${s.y.toStringAsFixed(0)}',
                            GoogleFonts.plusJakartaSans(
                              color: AppColors.primaryEmerald,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartSpots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        preventCurveOverShooting: true,
                        color: AppColors.primaryEmerald,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primaryEmerald.withValues(alpha: 0.3),
                              AppColors.primaryEmerald.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const Center(child: Text('Chart data error')),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _calculateRealChartSpots(List<Transaction> expenses) {
    final dailySums = List<double>.filled(31, 0.0);
    final now = DateTime.now();

    for (final t in expenses) {
      final diff = now.difference(t.date).inDays;
      if (diff >= 0 && diff < 30) {
        final dayIndex = 30 - diff;
        if (dayIndex >= 1 && dayIndex <= 30) {
          dailySums[dayIndex] += t.amount;
        }
      }
    }

    final spots = <FlSpot>[];
    for (int i = 1; i <= 30; i += 3) {
      spots.add(FlSpot(i.toDouble(), dailySums[i]));
    }
    return spots;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

class _SavingsTargetCard extends StatefulWidget {
  final Setting settings;
  final Budget? budget;
  final List<Transaction> transactions;
  final bool isDark;
  final String selectedSourceId;

  const _SavingsTargetCard({
    required this.settings,
    required this.budget,
    required this.transactions,
    required this.isDark,
    this.selectedSourceId = 'all',
  });

  @override
  State<_SavingsTargetCard> createState() => _SavingsTargetCardState();
}

class _SavingsTargetCardState extends State<_SavingsTargetCard> {
  bool _isManualMissed = false;

  @override
  void initState() {
    super.initState();
    _loadMissedStatus();
  }

  Future<void> _loadMissedStatus() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final isMissed =
        prefs.getBool('savings_missed_${now.year}_${now.month}') ?? false;
    if (mounted) {
      setState(() {
        _isManualMissed = isMissed;
      });
    }
  }

  Future<void> _toggleMissedStatus() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final newStatus = !_isManualMissed;
    await prefs.setBool('savings_missed_${now.year}_${now.month}', newStatus);
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _isManualMissed = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus
                ? 'Marked savings target as MISSED for this month.'
                : 'Restored savings target status to ON TRACK.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final symbol = CurrencyHelper.getSymbol(widget.settings.currency);

    double income = widget.settings.monthlyIncome;
    if (widget.selectedSourceId != 'all') {
      final sources = parseIncomeSources(widget.settings.incomeSources);
      final sel = sources.firstWhere(
        (s) => s.id == widget.selectedSourceId,
        orElse: () => IncomeSourceItem(id: 'all', name: 'All', amount: income),
      );
      income = sel.amount;
    }

    final savingsPercent = widget.budget?.savingsGoalPercent ?? 20.0;
    final expectedSavings = income * (savingsPercent / 100);

    final monthExpenses = widget.transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.year == now.year &&
              t.date.month == now.month,
        )
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    final totalSpentThisMonth = monthExpenses +
        (widget.selectedSourceId == 'all' ? widget.settings.priorSpentThisMonth : 0.0);

    final netSaved = income - totalSpentThisMonth;
    final currentSavings = netSaved.clamp(0.0, double.infinity);

    final progress = expectedSavings > 0
        ? (currentSavings / expectedSavings).clamp(0.0, 1.0)
        : 0.0;

    final achievedPercent = expectedSavings > 0
        ? ((currentSavings / expectedSavings) * 100).toInt()
        : 0;

    final bool isAchieved = expectedSavings > 0 && netSaved >= expectedSavings;
    final bool isOverspent = income > 0 && netSaved <= 0;
    final bool isMissed = _isManualMissed || isOverspent;

    if (income <= 0) {
      return GlassCard(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.savings_outlined,
                color: AppColors.primaryEmerald,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Savings Target',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Set your monthly income in Settings to activate crystal-clear savings target tracking.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    String statusBadgeText;
    Color statusColor;
    if (_isManualMissed || isOverspent) {
      statusBadgeText = 'BEHIND TARGET ⚠️';
      statusColor = AppColors.error;
    } else if (isAchieved) {
      statusBadgeText = 'GOAL ACHIEVED 🎉';
      statusColor = AppColors.primaryEmerald;
    } else {
      statusBadgeText = 'ON TRACK 🟢';
      statusColor = AppColors.primaryEmerald;
    }

    String summaryNote;
    if (isAchieved) {
      summaryNote =
          'Awesome! You reached your $symbol${expectedSavings.toStringAsFixed(0)} goal ($achievedPercent% saved).';
    } else if (netSaved > 0) {
      final remaining = expectedSavings - netSaved;
      summaryNote =
          'Saved $symbol${netSaved.toStringAsFixed(0)} out of $symbol${expectedSavings.toStringAsFixed(0)} target ($achievedPercent%). $symbol${remaining.toStringAsFixed(0)} remaining to hit target.';
    } else {
      summaryNote =
          'Total spending currently equals or exceeds monthly income. Reduce expenditures to build net savings.';
    }

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isMissed
                          ? Icons.warning_amber_rounded
                          : (isAchieved ? Icons.stars_rounded : Icons.savings_outlined),
                      color: statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Savings Target',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Target Rate: ${savingsPercent.toInt()}% of income',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  statusBadgeText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppColors.gray100,
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              border: Border.all(
                color: widget.isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.cardBorder,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Monthly Income',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$symbol${income.toStringAsFixed(0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: widget.isDark ? Colors.white : AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: widget.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.cardBorder,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Spent So Far',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$symbol${totalSpentThisMonth.toStringAsFixed(0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: widget.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.cardBorder,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Net Saved',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$symbol${netSaved.toStringAsFixed(0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: netSaved >= 0
                              ? AppColors.primaryEmerald
                              : AppColors.error,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Savings Goal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$symbol${expectedSavings.toStringAsFixed(0)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: widget.isDark ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                ],
              ),

              _MiniSavingsSparkline(progress: progress, isMissed: isMissed),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Achieved ($achievedPercent%)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$symbol${currentSavings.toStringAsFixed(0)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: widget.isDark
                  ? Colors.white10
                  : AppColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  summaryNote,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PressableScale(
                onTap: _toggleMissedStatus,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _isManualMissed
                        ? AppColors.primaryEmerald.withValues(alpha: 0.12)
                        : AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(
                    _isManualMissed ? 'Mark On Track' : 'Mark Missed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _isManualMissed
                          ? AppColors.primaryEmerald
                          : AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniSavingsSparkline extends StatelessWidget {
  final double progress;
  final bool isMissed;

  const _MiniSavingsSparkline({required this.progress, required this.isMissed});

  @override
  Widget build(BuildContext context) {
    final barColor = isMissed ? AppColors.error : AppColors.primaryEmerald;
    final heights = [0.4, 0.55, 0.45, 0.7, 0.6, 0.85, progress.clamp(0.1, 1.0)];

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: heights.map((h) {
          return Container(
            width: 4,
            height: 28 * h,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: barColor.withValues(alpha: 0.3 + (h * 0.7)),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
