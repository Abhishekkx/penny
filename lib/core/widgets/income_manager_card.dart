import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../database/database.dart';
import 'glass_card.dart';
import 'pressable_scale.dart';

class IncomeManagerCard extends StatefulWidget {
  final String currencySymbol;
  final List<IncomeSourceItem> initialIncomeSources;
  final double initialPriorSpent;
  final double initialSavingsBalance;
  final Function(
    List<IncomeSourceItem> sources,
    double totalIncome,
    double priorSpent,
    double savingsBalance,
    double suggestedDailyLimit,
  ) onChanged;

  const IncomeManagerCard({
    super.key,
    required this.currencySymbol,
    required this.initialIncomeSources,
    required this.initialPriorSpent,
    required this.initialSavingsBalance,
    required this.onChanged,
  });

  @override
  State<IncomeManagerCard> createState() => _IncomeManagerCardState();
}

class _IncomeManagerCardState extends State<IncomeManagerCard> {
  late List<IncomeSourceItem> _sources;
  late TextEditingController _priorSpentController;
  late TextEditingController _savingsController;
  bool _isMidMonthSetup = false;

  @override
  void initState() {
    super.initState();
    _sources = List.from(widget.initialIncomeSources);
    _priorSpentController = TextEditingController(
      text: widget.initialPriorSpent > 0 ? widget.initialPriorSpent.toStringAsFixed(0) : '',
    );
    _savingsController = TextEditingController(
      text: widget.initialSavingsBalance > 0 ? widget.initialSavingsBalance.toStringAsFixed(0) : '',
    );
    _isMidMonthSetup = widget.initialPriorSpent > 0 || widget.initialSavingsBalance > 0;
  }

  @override
  void dispose() {
    _priorSpentController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  double get _totalIncome => _sources.fold(0.0, (sum, item) => sum + item.amount);
  double get _priorSpent => double.tryParse(_priorSpentController.text) ?? 0.0;
  double get _savingsBalance => double.tryParse(_savingsController.text) ?? 0.0;

  int get _remainingDaysInMonth {
    final now = DateTime.now();
    final totalDays = DateTime(now.year, now.month + 1, 0).day;
    final remaining = totalDays - now.day + 1;
    return remaining > 0 ? remaining : 1;
  }

  double get _suggestedDailyLimit {
    final netRemaining = _totalIncome - _priorSpent;
    if (netRemaining <= 0) return 100.0;
    return (netRemaining / _remainingDaysInMonth).clamp(50.0, 50000.0);
  }

  void _notifyParent() {
    widget.onChanged(
      _sources,
      _totalIncome,
      _priorSpent,
      _savingsBalance,
      _suggestedDailyLimit,
    );
  }

  void _showAddEditSourceDialog({IncomeSourceItem? existingItem, int? index}) {
    final nameController = TextEditingController(text: existingItem?.name ?? '');
    final amountController = TextEditingController(
      text: existingItem != null ? existingItem.amount.toStringAsFixed(0) : '',
    );
    String selectedCategory = existingItem?.category ?? 'salary';

    final categories = [
      ('salary', 'Salary / Job', Icons.work_outline_rounded),
      ('freelance', 'Freelancing', Icons.laptop_mac_rounded),
      ('business', 'Side Business', Icons.storefront_rounded),
      ('investment', 'Investments', Icons.trending_up_rounded),
      ('rental', 'Rental Income', Icons.home_work_outlined),
      ('other', 'Other Source', Icons.account_balance_wallet_outlined),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceHigh : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: AppTheme.ambientGlow(color: AppColors.primaryEmerald, opacity: 0.2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existingItem == null ? 'Add Income Source' : 'Edit Income Source',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Source Name (e.g. Primary Job, Upwork)',
                        prefixIcon: Icon(Icons.label_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monthly Amount',
                        prefixText: '${widget.currencySymbol} ',
                        prefixStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Category',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((cat) {
                        final isSelected = selectedCategory == cat.$1;
                        return ChoiceChip(
                          selected: isSelected,
                          showCheckmark: false,
                          avatar: Icon(
                            cat.$3,
                            size: 16,
                            color: isSelected ? Colors.white : AppColors.primaryEmerald,
                          ),
                          label: Text(
                            cat.$2,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                          selectedColor: AppColors.primaryEmerald,
                          onSelected: (val) {
                            if (val) setModalState(() => selectedCategory = cat.$1);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    PressableScale(
                      onTap: () {
                        final name = nameController.text.trim();
                        final amount = double.tryParse(amountController.text) ?? 0.0;
                        if (name.isEmpty || amount <= 0) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text('Please enter valid name and amount')),
                          );
                          return;
                        }

                        setState(() {
                          if (index != null && index < _sources.length) {
                            _sources[index] = IncomeSourceItem(
                              id: existingItem!.id,
                              name: name,
                              amount: amount,
                              category: selectedCategory,
                            );
                          } else {
                            _sources.add(IncomeSourceItem(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: name,
                              amount: amount,
                              category: selectedCategory,
                            ));
                          }
                        });
                        _notifyParent();
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          existingItem == null ? 'Add Income Stream' : 'Save Changes',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
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
        return Icons.account_balance_wallet_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 18,
                    color: AppColors.primaryEmerald,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Income Sources',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  'Total: ${widget.currencySymbol}${_totalIncome.toStringAsFixed(0)}/mo',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryEmerald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Add single or multiple income streams for automatic budget pacing.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          if (_sources.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No income streams added yet. Tap below to add your salary or earnings.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sources.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final source = _sources[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(
                      color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(source.category),
                        size: 18,
                        color: AppColors.primaryEmerald,
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
                            ),
                            Text(
                              source.category.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${widget.currencySymbol}${source.amount.toStringAsFixed(0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        onPressed: () => _showAddEditSourceDialog(existingItem: source, index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _sources.removeAt(index);
                          });
                          _notifyParent();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 10),
          PressableScale(
            onTap: () => _showAddEditSourceDialog(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                color: AppColors.primaryEmerald.withValues(alpha: 0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded, size: 18, color: AppColors.primaryEmerald),
                  const SizedBox(width: 6),
                  Text(
                    'Add Another Income Source',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 18, color: AppColors.tertiary),
                  const SizedBox(width: 8),
                  Text(
                    'Mid-Month & Starting Setup',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isMidMonthSetup,
                activeColor: AppColors.primaryEmerald,
                onChanged: (val) {
                  setState(() => _isMidMonthSetup = val);
                  if (!val) {
                    _priorSpentController.clear();
                    _savingsController.clear();
                    _notifyParent();
                  }
                },
              ),
            ],
          ),

          if (_isMidMonthSetup) ...[
            const SizedBox(height: 8),
            Text(
              'Starting Pennora in the middle of a month? Enter what you already spent & your current savings to keep daily budget pacing exact.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priorSpentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Spent so far this month (before Pennora)',
                prefixText: '${widget.currencySymbol} ',
                prefixStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _savingsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Starting Savings / Balance',
                prefixText: '${widget.currencySymbol} ',
                prefixStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.tertiary,
                ),
              ),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insights_rounded, size: 20, color: AppColors.primaryEmerald),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mid-Month Pacing Calculation',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        Text(
                          '$_remainingDaysInMonth days remaining this month. Suggested daily cap: ${widget.currencySymbol}${_suggestedDailyLimit.toStringAsFixed(0)}/day.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
