import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/widgets/pressable_scale.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  final TransactionType initialType;

  const AddTransactionSheet({
    super.key,
    this.initialType = TransactionType.expense,
  });

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late TransactionType _selectedType;
  late TransactionCategory _selectedCategory;
  late DateTime _selectedDateTime;
  bool _isNeed = true;
  bool _isSaving = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedCategory = _getCategoriesForType().first;
    _selectedDateTime = DateTime.now(); // Auto timestamp current date and time

    double lastFontSize = 44.0;
    _amountController.addListener(() {
      final currentFontSize = _getDynamicFontSize(_amountController.text);
      if (currentFontSize != lastFontSize) {
        lastFontSize = currentFontSize;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<TransactionCategory> _getCategoriesForType() {
    if (_selectedType == TransactionType.income) {
      return [
        TransactionCategory.salary,
        TransactionCategory.freelance,
        TransactionCategory.other,
      ];
    } else if (_selectedType == TransactionType.investment) {
      return [TransactionCategory.investment];
    } else {
      return [
        TransactionCategory.food,
        TransactionCategory.transport,
        TransactionCategory.shopping,
        TransactionCategory.housing,
        TransactionCategory.health,
        TransactionCategory.fun,
        TransactionCategory.travel,
        TransactionCategory.other,
      ];
    }
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
        return Icons.more_horiz_rounded;
    }
  }

  Color _getColorForCategory(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return const Color(0xFFF97316);
      case TransactionCategory.transport:
        return const Color(0xFF06B6D4);
      case TransactionCategory.shopping:
        return const Color(0xFFF59E0B);
      case TransactionCategory.housing:
        return const Color(0xFF3B82F6);
      case TransactionCategory.health:
        return const Color(0xFFEF4444);
      case TransactionCategory.fun:
        return const Color(0xFFEC4899);
      case TransactionCategory.travel:
        return const Color(0xFF8B5CF6);
      case TransactionCategory.salary:
        return AppColors.primaryEmerald;
      case TransactionCategory.freelance:
        return AppColors.primaryTeal;
      case TransactionCategory.investment:
        return AppColors.accentIndigo;
      case TransactionCategory.other:
        return AppColors.gray500;
    }
  }

  double _getDynamicFontSize(String text) {
    if (text.length > 8) return 28.0;
    if (text.length > 5) return 36.0;
    return 44.0;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final db = ref.read(databaseProvider);
    await db.insertTransaction(
      TransactionsCompanion.insert(
        type: _selectedType,
        amount: amount,
        category: _selectedCategory,
        isNeed: Value(_isNeed),
        note: Value(_noteController.text.trim()),
        date: _selectedDateTime, // Exact auto timestamp
      ),
    );

    await HapticFeedback.mediumImpact();

    if (mounted) {
      setState(() {
        _isSaving = false;
        _isSuccess = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedType == TransactionType.expense
                  ? 'Expenditure recorded successfully!'
                  : 'Transaction recorded successfully!',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) => _buildSheet(context, settings.currency),
      loading: () => _buildSheet(context, 'INR'),
      error: (_, __) => _buildSheet(context, 'INR'),
    );
  }

  Widget _buildSheet(BuildContext context, String currency) {
    final currencySymbol = CurrencyHelper.getSymbol(currency);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontSize = _getDynamicFontSize(_amountController.text);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgStart : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.cardBorder,
          width: 1.2,
        ),
        boxShadow: AppTheme.cardShadow(isDark: isDark),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceLg,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceHigh
                          : AppColors.gray300,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceMd),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedType == TransactionType.expense
                              ? 'Record Expenditure'
                              : 'Add Transaction',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Auto-logged with date & time',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 22),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceHigh
                            : AppColors.gray100,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spaceMd),

                _buildSegmentedControl(isDark),

                const SizedBox(height: AppTheme.spaceLg),

                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.gray100,
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusDefault,
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.primaryEmerald,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat(
                            'MMM dd, yyyy • h:mm a',
                          ).format(_selectedDateTime),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          size: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spaceMd),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface.withValues(alpha: 0.6)
                        : AppColors.gray50,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        currencySymbol,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: fontSize * 0.85,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          autofocus: true,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: isDark ? Colors.white : AppColors.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.35,
                              ),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spaceLg),

                Text(
                  'Category',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                _buildCategoryGrid(isDark),

                const SizedBox(height: AppTheme.spaceLg),

                if (_selectedType == TransactionType.expense) ...[
                  Text(
                    'Spending Type',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceSm),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _isNeed = true);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: _isNeed
                                  ? AppColors.primaryEmerald.withValues(
                                      alpha: 0.14,
                                    )
                                  : (isDark
                                        ? AppColors.darkSurface.withValues(
                                            alpha: 0.6,
                                          )
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                              border: Border.all(
                                color: _isNeed
                                    ? AppColors.primaryEmerald
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : AppColors.cardBorder),
                                width: _isNeed ? 1.8 : 1.0,
                              ),
                              boxShadow: _isNeed
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryEmerald
                                            .withValues(alpha: 0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: _isNeed
                                        ? AppColors.primaryEmerald
                                        : (isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.08,
                                                )
                                              : AppColors.gray100),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: _isNeed
                                        ? Colors.white
                                        : AppColors.onSurfaceVariant,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Essential Need',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: _isNeed
                                              ? AppColors.primaryEmerald
                                              : (isDark
                                                    ? Colors.white
                                                    : AppColors.onSurface),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rent, groceries',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariant,
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
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _isNeed = false);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: !_isNeed
                                  ? AppColors.secondary.withValues(alpha: 0.14)
                                  : (isDark
                                        ? AppColors.darkSurface.withValues(
                                            alpha: 0.6,
                                          )
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                              border: Border.all(
                                color: !_isNeed
                                    ? AppColors.secondary
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : AppColors.cardBorder),
                                width: !_isNeed ? 1.8 : 1.0,
                              ),
                              boxShadow: !_isNeed
                                  ? [
                                      BoxShadow(
                                        color: AppColors.secondary.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: !_isNeed
                                        ? AppColors.secondary
                                        : (isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.08,
                                                )
                                              : AppColors.gray100),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shopping_basket_rounded,
                                    color: !_isNeed
                                        ? Colors.white
                                        : AppColors.onSurfaceVariant,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Discretionary',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: !_isNeed
                                              ? AppColors.secondary
                                              : (isDark
                                                    ? Colors.white
                                                    : AppColors.onSurface),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Dining out, fun',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariant,
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                ],

                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'Add note (optional)',
                    prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
                    hintText: 'e.g. Lunch with friends, groceries',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusDefault,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spaceXl),

                PressableScale(
                  onTap: _isSaving || _isSuccess ? null : _saveTransaction,
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: _isSuccess
                          ? const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            )
                          : AppColors.primaryButtonGradient,
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusDefault,
                      ),
                      boxShadow: AppTheme.ambientGlow(
                        color: AppColors.primaryEmerald,
                        opacity: 0.35,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _isSuccess
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Recorded!',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        : _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedType == TransactionType.expense
                                    ? 'Record Expenditure'
                                    : 'Save Transaction',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(bool isDark) {
    final types = [
      (TransactionType.expense, 'Expenditure', Icons.arrow_upward_rounded),
      (TransactionType.income, 'Income', Icons.arrow_downward_rounded),
      (TransactionType.investment, 'Investment', Icons.trending_up_rounded),
    ];

    return Container(
      height: 48,
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
        children: types.map((item) {
          final type = item.$1;
          final label = item.$2;
          final icon = item.$3;
          final isSelected = _selectedType == type;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedType = type;
                  _selectedCategory = _getCategoriesForType().first;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: isSelected
                          ? AppColors.primaryEmerald
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.onSurface)
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDark) {
    final categories = _getCategoriesForType();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = _selectedCategory == category;
        final color = _getColorForCategory(category);
        final icon = _getIconForCategory(category);
        final title =
            category.name[0].toUpperCase() + category.name.substring(1);

        return PressableScale(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedCategory = category;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.18)
                  : (isDark
                        ? AppColors.darkSurface.withValues(alpha: 0.6)
                        : AppColors.gray50),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(
                color: isSelected
                    ? color
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.cardBorder),
                width: isSelected ? 1.8 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? color : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.onSurface)
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
