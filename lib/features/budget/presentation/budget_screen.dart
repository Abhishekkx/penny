import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/widgets/custom_slider.dart';
import '../../../core/widgets/progress_milestones.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../core/widgets/income_manager_card.dart';
import '../../transactions/presentation/add_transaction_sheet.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  void _showAddGoalDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    DateTime? targetDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgStart : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
              border: Border.all(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.cardBorder,
              ),
            ),
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceLg,
              left: AppTheme.spaceLg,
              right: AppTheme.spaceLg,
              top: AppTheme.spaceLg,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Set Target Savings Limit',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Savings Target Name',
                      hintText: 'e.g. Emergency Fund, Japan Trip',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  TextField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Target Savings Amount',
                      prefixIcon: Icon(Icons.track_changes_rounded),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 90),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 5),
                        ),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 18, minute: 0),
                        );
                        final selectedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time?.hour ?? 0,
                          time?.minute ?? 0,
                        );
                        setModalState(() {
                          targetDate = selectedDateTime;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.primaryEmerald,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Date & Time',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  targetDate != null
                                      ? DateFormat(
                                          'yyyy-MM-dd HH:mm',
                                        ).format(targetDate!)
                                      : 'Tap to select date & time',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.chevron_right, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final price = double.tryParse(priceController.text);

                        if (name.isEmpty || price == null || price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter a valid goal name and target price',
                              ),
                            ),
                          );
                          return;
                        }

                        final db = ref.read(databaseProvider);
                        await db.insertPurchaseGoal(
                          PurchaseGoalsCompanion.insert(
                            name: name,
                            targetPrice: price,
                            targetDate: Value(targetDate),
                          ),
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Savings target limit set successfully!',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Set Target Savings Limit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDepositDialog(
    BuildContext context,
    PurchaseGoal goal,
    String symbol,
  ) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Savings to "${goal.name}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Saved: $symbol${goal.savedAmount.toStringAsFixed(0)} / $symbol${goal.targetPrice.toStringAsFixed(0)}',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Amount Saved ($symbol)',
                prefixText: '$symbol ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final added = double.tryParse(amountController.text);
              if (added != null && added > 0) {
                final db = ref.read(databaseProvider);
                final newSaved = (goal.savedAmount + added).clamp(
                  0.0,
                  goal.targetPrice * 2,
                );
                final updated = goal.copyWith(
                  savedAmount: newSaved,
                  isCompleted: newSaved >= goal.targetPrice,
                  updatedAt: DateTime.now(),
                );
                await db.updatePurchaseGoal(updated);
                ref.invalidate(purchaseGoalsProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added $symbol${added.toStringAsFixed(0)} savings to ${goal.name}!',
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Add Savings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetAsync = ref.watch(budgetProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final goalsAsync = ref.watch(purchaseGoalsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppTheme.spaceMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppTheme.spaceSm,
                    bottom: AppTheme.spaceMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Budget & Goals',
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

                Text(
                  'Spending & Savings Targets',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(duration: 350.ms),
                const SizedBox(height: AppTheme.spaceMd),

                budgetAsync.when(
                  data: (budget) {
                    if (budget == null) return const SizedBox.shrink();

                    return Column(
                      children: [
                        _buildDailyLimitCard(context, budget, transactionsAsync)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppTheme.spaceMd),
                        _buildSavingsGoalCard(context, budget, settingsAsync)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 80.ms)
                            .slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppTheme.spaceMd),
                        _buildIncomePortfolioCard(context, settingsAsync)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .slideY(begin: 0.08, end: 0),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (_, __) => const Text('Error loading budget'),
                ),

                const SizedBox(height: AppTheme.spaceXl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Purchase Goals',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    PressableScale(
                      onTap: _showAddGoalDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusFull,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppColors.primaryEmerald,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Add Goal',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.primaryEmerald,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 350.ms, delay: 120.ms),
                const SizedBox(height: AppTheme.spaceMd),

                goalsAsync.when(
                  data: (goals) {
                    if (goals.isEmpty) {
                      return _buildEmptyGoalsState(context)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 150.ms)
                          .slideY(begin: 0.08, end: 0);
                    }

                    return Column(
                      children: goals.asMap().entries.map((entry) {
                        final index = entry.key;
                        final goal = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppTheme.spaceMd,
                          ),
                          child:
                              _buildGoalCard(
                                    context,
                                    goal,
                                    transactionsAsync,
                                    settingsAsync,
                                  )
                                  .animate()
                                  .fadeIn(
                                    duration: 400.ms,
                                    delay: (150 + index * 60).ms,
                                  )
                                  .slideY(begin: 0.08, end: 0),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const Text('Error loading goals'),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showIncreaseLimitDialog(
    BuildContext context,
    Budget budget,
    double todaySpent,
    String symbol,
  ) {
    final suggested = (todaySpent * 1.2).ceilToDouble();
    final controller = TextEditingController(
      text: suggested.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adjust Daily Expense Limit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s expenses reached $symbol${todaySpent.toStringAsFixed(0)}, exceeding your set limit of $symbol${budget.dailyLimit.toStringAsFixed(0)}.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'New Daily Limit ($symbol)',
                prefixText: '$symbol ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newLimit = double.tryParse(controller.text);
              if (newLimit != null && newLimit > 0) {
                final db = ref.read(databaseProvider);
                final updated = budget.copyWith(
                  dailyLimit: newLimit,
                  updatedAt: DateTime.now(),
                );
                await db.updateBudget(updated);
                ref.invalidate(budgetProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Daily limit updated to $symbol${newLimit.toStringAsFixed(0)}!',
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Save Limit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyLimitCard(
    BuildContext context,
    Budget budget,
    AsyncValue<List<Transaction>> transactionsAsync,
  ) {
    final monthlyProjection = budget.dailyLimit * 30;
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) {
        final symbol = CurrencyHelper.getSymbol(settings.currency);

        final now = DateTime.now();
        final transactions = transactionsAsync.value ?? [];
        final todaySpent = transactions
            .where(
              (t) =>
                  t.type == TransactionType.expense &&
                  t.date.year == now.year &&
                  t.date.month == now.month &&
                  t.date.day == now.day,
            )
            .fold<double>(0.0, (sum, t) => sum + t.amount);

        final isOverLimit =
            budget.dailyLimit > 0 && todaySpent > budget.dailyLimit;
        final excessAmount = todaySpent - budget.dailyLimit;
        final percentUsed = budget.dailyLimit > 0
            ? ((todaySpent / budget.dailyLimit) * 100).toStringAsFixed(0)
            : '0';

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isOverLimit
                              ? AppColors.error.withValues(alpha: 0.15)
                              : AppColors.primaryEmerald.withValues(
                                  alpha: 0.15,
                                ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isOverLimit
                              ? Icons.warning_amber_rounded
                              : Icons.speed_rounded,
                          color: isOverLimit
                              ? AppColors.error
                              : AppColors.primaryEmerald,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Expense Limit',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: isOverLimit
                          ? AppColors.error.withValues(alpha: 0.1)
                          : AppColors.primaryEmerald.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      '~$symbol${monthlyProjection.toStringAsFixed(0)}/mo',
                      style: GoogleFonts.plusJakartaSans(
                        color: isOverLimit
                            ? AppColors.error
                            : AppColors.primaryEmerald,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    symbol,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isOverLimit
                          ? AppColors.error
                          : AppColors.primaryEmerald,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      key: ValueKey('limit_${budget.dailyLimit}'),
                      controller: TextEditingController(
                        text: budget.dailyLimit.toStringAsFixed(0),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isOverLimit ? AppColors.error : null,
                      ),
                      decoration: const InputDecoration(
                        hintText: '500',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onSubmitted: (value) async {
                        final parsed = double.tryParse(value);
                        if (parsed != null && parsed > 0) {
                          final db = ref.read(databaseProvider);
                          final updated = budget.copyWith(
                            dailyLimit: parsed,
                            updatedAt: DateTime.now(),
                          );
                          await db.updateBudget(updated);
                        }
                      },
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Today: $symbol${todaySpent.toStringAsFixed(0)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isOverLimit
                          ? AppColors.error
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              CustomGradientSlider(
                value: budget.dailyLimit.clamp(0.0, 10000.0),
                min: 0,
                max: 10000,
                divisions: 200,
                prefix: symbol,
                onChanged: (value) async {
                  final db = ref.read(databaseProvider);
                  final updated = budget.copyWith(
                    dailyLimit: value,
                    updatedAt: DateTime.now(),
                  );
                  await db.updateBudget(updated);
                },
              ),

              if (isOverLimit) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exceeded by $symbol${excessAmount.toStringAsFixed(0)} ($percentUsed% used)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                            Text(
                              'If your limit was set too low, you can adjust it anytime.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      PressableScale(
                        onTap: () => _showIncreaseLimitDialog(
                          context,
                          budget,
                          todaySpent,
                          symbol,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                          ),
                          child: Text(
                            'Adjust Limit',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSavingsGoalCard(
    BuildContext context,
    Budget budget,
    AsyncValue<Setting> settingsAsync,
  ) {
    return settingsAsync.when(
      data: (settings) {
        final savingsAmount =
            settings.monthlyIncome * (budget.savingsGoalPercent / 100);
        final symbol = CurrencyHelper.getSymbol(settings.currency);

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.savings_outlined,
                          color: AppColors.tertiary,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Monthly Savings Rate',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      settings.monthlyIncome > 0
                          ? '$symbol${savingsAmount.toStringAsFixed(0)}/mo'
                          : 'Set income',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${budget.savingsGoalPercent.toInt()}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: _getColorForPercent(budget.savingsGoalPercent),
                    ),
                  ),
                  Text(
                    'Target: ${budget.savingsGoalPercent.toInt()}% of income',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              CustomGradientSlider(
                value: budget.savingsGoalPercent,
                min: 0,
                max: 50,
                divisions: 10,
                suffix: '%',
                onChanged: (value) async {
                  final db = ref.read(databaseProvider);
                  final updated = budget.copyWith(
                    savingsGoalPercent: value,
                    updatedAt: DateTime.now(),
                  );
                  await db.updateBudget(updated);
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    PurchaseGoal goal,
    AsyncValue<List<Transaction>> transactionsAsync,
    AsyncValue<Setting> settingsAsync,
  ) {
    return settingsAsync.when(
      data: (settings) {
        final symbol = CurrencyHelper.getSymbol(settings.currency);
        final remaining = goal.targetPrice - goal.savedAmount;
        final progress = (goal.targetPrice > 0)
            ? (goal.savedAmount / goal.targetPrice).clamp(0.0, 1.0)
            : 0.0;

        String timelineText;
        if (settings.monthlyIncome > 0) {
          final monthlySavings = settings.monthlyIncome * 0.2;
          final monthsNeeded = (monthlySavings > 0)
              ? (remaining / monthlySavings).ceil()
              : 1;

          if (goal.targetDate != null) {
            final daysUntilTarget = goal.targetDate!
                .difference(DateTime.now())
                .inDays;
            final monthsAvailable = (daysUntilTarget / 30).floor();
            if (monthsAvailable > 0) {
              final neededPerMonth = remaining / monthsAvailable;
              timelineText =
                  'Save $symbol${neededPerMonth.toStringAsFixed(0)}/mo to reach by ${DateFormat.yMMMd().format(goal.targetDate!)}';
            } else {
              timelineText = 'Target date is close!';
            }
          } else {
            timelineText =
                'Est. $monthsNeeded month${monthsNeeded > 1 ? 's' : ''} with current savings pace';
          }
        } else {
          timelineText = 'Configure monthly income to see dynamic projections';
        }

        return GlassCard(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      goal.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.error,
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Goal?'),
                          content: Text(
                            'Are you sure you want to delete "${goal.name}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        final db = ref.read(databaseProvider);
                        await db.deletePurchaseGoal(goal.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Goal removed')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$symbol${goal.savedAmount.toStringAsFixed(0)} / $symbol${goal.targetPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMd),

              MilestoneProgressBar(
                progress: progress,
                height: 10,
                milestones: const [
                  MilestoneBadge(position: 0.5, emoji: '🎯', label: '50%'),
                  MilestoneBadge(position: 1.0, emoji: '🚀', label: 'Done'),
                ],
              ),

              const SizedBox(height: AppTheme.spaceSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_graph_rounded,
                          size: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            timelineText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PressableScale(
                    onTap: () => _showDepositDialog(context, goal, symbol),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusFull,
                        ),
                        border: Border.all(
                          color: AppColors.primaryEmerald.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.primaryEmerald,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Add Savings',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildEmptyGoalsState(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  size: 28,
                  color: AppColors.primaryEmerald,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.08, 1.08),
                duration: 1600.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            'Create a Purchase Goal',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            'Save up for big purchases and track milestones with real-time target projections.',
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

  Color _getColorForPercent(double percent) {
    if (percent >= 30) return AppColors.primaryEmerald;
    if (percent >= 20) return AppColors.tertiary;
    return AppColors.onSurfaceVariant;
  }

  void _showIncomeEditModal(BuildContext context, Setting settings) {
    final symbol = CurrencyHelper.getSymbol(settings.currency);
    final sources = parseIncomeSources(settings.incomeSources);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgStart : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
              border: Border.all(
                color: isDark ? AppColors.glassBorderDark : AppColors.cardBorder,
              ),
            ),
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage Income Streams',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceSm),
                Expanded(
                  child: SingleChildScrollView(
                    child: IncomeManagerCard(
                      currencySymbol: symbol,
                      initialIncomeSources: sources,
                      initialPriorSpent: settings.priorSpentThisMonth,
                      initialSavingsBalance: settings.initialSavingsBalance,
                      onChanged: (updatedSources, totalIncome, priorSpent, savingsBalance, suggestedDaily) async {
                        final db = ref.read(databaseProvider);
                        final updatedSettings = settings.copyWith(
                          monthlyIncome: totalIncome,
                          incomeSources: jsonEncode(updatedSources.map((e) => e.toJson()).toList()),
                          priorSpentThisMonth: priorSpent,
                          initialSavingsBalance: savingsBalance,
                          updatedAt: DateTime.now(),
                        );
                        await db.updateSettings(updatedSettings);

                        final budget = ref.read(budgetProvider).value;
                        if (budget != null) {
                          final updatedBudget = budget.copyWith(
                            dailyLimit: suggestedDaily,
                            updatedAt: DateTime.now(),
                          );
                          await db.updateBudget(updatedBudget);
                          ref.invalidate(budgetProvider);
                        }
                        ref.invalidate(settingsProvider);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIncomePortfolioCard(
    BuildContext context,
    AsyncValue<Setting> settingsAsync,
  ) {
    return settingsAsync.when(
      data: (settings) {
        final symbol = CurrencyHelper.getSymbol(settings.currency);
        List<IncomeSourceItem> sources = parseIncomeSources(settings.incomeSources);
        if (sources.isEmpty && settings.monthlyIncome > 0) {
          sources = [
            IncomeSourceItem(
              id: 'default',
              name: 'Primary Salary',
              amount: settings.monthlyIncome,
              category: 'salary',
            ),
          ];
        }

        final totalIncome = settings.monthlyIncome > 0
            ? settings.monthlyIncome
            : sources.fold(0.0, (sum, s) => sum + s.amount);

        final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.primaryEmerald,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Income Streams Portfolio',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  PressableScale(
                    onTap: () => _showIncomeEditModal(context, settings),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        border: Border.all(
                          color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.tune_rounded,
                            size: 13,
                            color: AppColors.primaryEmerald,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Manage Streams',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMd),

              if (sources.isEmpty) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          'No income streams configured yet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showIncomeEditModal(context, settings),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Income Source'),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                ...sources.map((source) {
                  final share = totalIncome > 0
                      ? ((source.amount / totalIncome) * 100)
                      : 0.0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : AppColors.gray100,
                      borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(source.category),
                            size: 17,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                source.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _getCategoryLabel(source.category),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$symbol${source.amount.toStringAsFixed(0)}/mo',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                              ),
                              child: Text(
                                '${share.toStringAsFixed(1)}% share',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryEmerald,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Portfolio Monthly Income',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                      Text(
                        '$symbol${totalIncome.toStringAsFixed(0)}/mo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  IconData _getCategoryIcon(String cat) {
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

  String _getCategoryLabel(String cat) {
    switch (cat.toLowerCase()) {
      case 'salary':
        return 'Salary / Job';
      case 'freelance':
        return 'Freelancing';
      case 'business':
        return 'Side Business';
      case 'investment':
        return 'Investments';
      case 'rental':
        return 'Rental Income';
      default:
        return 'Other Source';
    }
  }
}
