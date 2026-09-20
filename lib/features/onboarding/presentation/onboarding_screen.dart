import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/widgets/custom_slider.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../core/widgets/income_manager_card.dart';
import '../../dashboard/presentation/main_navigation.dart';
import '../../../core/services/quick_notification_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipOnboarding() async {
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final db = ref.read(databaseProvider);
    final settings = await db.getSettings();
    final updated = settings.copyWith(
      hasCompletedOnboarding: true,
      updatedAt: DateTime.now(),
    );
    await db.updateSettings(updated);

    ref.invalidate(settingsProvider);
    ref.invalidate(budgetProvider);
    ref.invalidate(transactionsProvider);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                  vertical: AppTheme.spaceSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        ),
                        icon: const Icon(Icons.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: 48),
                    if (_currentPage < 3)
                      TextButton(
                        onPressed: _skipOnboarding,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryEmerald,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    _OnboardingPage1(),
                    _OnboardingPage2(),
                    _OnboardingPage3(),
                    _OnboardingPage4Setup(),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        4,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primaryEmerald
                                : AppColors.primaryEmerald.withValues(
                                    alpha: 0.2,
                                  ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (_currentPage < 3)
                      PressableScale(
                        onTap: () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        ),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryButtonGradient,
                            boxShadow: AppTheme.ambientGlow(
                              color: AppColors.primaryEmerald,
                              opacity: 0.3,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryEmerald.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryCardGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.ambientGlow(
                    color: AppColors.primaryEmerald,
                    opacity: 0.35,
                  ),
                ),
                child: const Icon(
                  Icons.savings_rounded,
                  size: 54,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

          const SizedBox(height: AppTheme.spaceXl),

          Text(
            'Welcome to Pennora',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: AppTheme.spaceMd),

          Text(
            'Your private offline finance tracker. Simple, secure, and completely local.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: AppTheme.spaceLg),
        ],
      ),
    );
  }
}

class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.ambientGlow(
                    color: AppColors.secondary,
                    opacity: 0.35,
                  ),
                ),
                child: const Icon(
                  Icons.auto_graph_rounded,
                  size: 54,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

          const SizedBox(height: AppTheme.spaceXl),

          Text(
            'Track Every Single Penny',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: AppTheme.spaceMd),

          Text(
            'Log income, expenses, and investments with rich interactive glass controls and live analytics — all auto-timestamped.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }
}

class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.tertiary.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.ambientGlow(
                    color: AppColors.tertiary,
                    opacity: 0.35,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 54,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

          const SizedBox(height: AppTheme.spaceXl),

          Text(
            'Automated Intelligence',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: AppTheme.spaceMd),

          Text(
            'Discover spending patterns, stay under budget limits, and achieve purchase milestones with ease.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }
}

class _OnboardingPage4Setup extends ConsumerStatefulWidget {
  const _OnboardingPage4Setup();

  @override
  ConsumerState<_OnboardingPage4Setup> createState() =>
      _OnboardingPage4SetupState();
}

class _OnboardingPage4SetupState extends ConsumerState<_OnboardingPage4Setup> {
  String _selectedCurrency = 'INR'; // default to INR
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _limitController = TextEditingController(
    text: '1000',
  );
  double _dailyLimit = 1000.0;
  bool _isNameValid = false;

  List<IncomeSourceItem> _incomeSources = [];
  double _priorSpent = 0.0;
  double _savingsBalance = 0.0;

  static const List<(String, String, String)> _currencies = [
    ('INR', '₹', 'Indian Rupee'),
    ('USD', '\$', 'US Dollar'),
    ('EUR', '€', 'Euro'),
    ('GBP', '£', 'British Pound'),
    ('JPY', '¥', 'Japanese Yen'),
    ('AUD', 'A\$', 'Australian Dollar'),
    ('CAD', 'C\$', 'Canadian Dollar'),
    ('SGD', 'S\$', 'Singapore Dollar'),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  void _validateName() {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  String _getSelectedCurrencySymbol() {
    return _currencies.firstWhere((c) => c.$1 == _selectedCurrency).$2;
  }

  Future<void> _finishOnboarding() async {
    if (!_isNameValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to continue')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final settings = await db.getSettings();

    final totalIncome = _incomeSources.fold(0.0, (sum, item) => sum + item.amount);

    final updated = settings.copyWith(
      userName: _nameController.text.trim(),
      currency: _selectedCurrency,
      monthlyIncome: totalIncome,
      incomeSources: jsonEncode(_incomeSources.map((e) => e.toJson()).toList()),
      priorSpentThisMonth: _priorSpent,
      initialSavingsBalance: _savingsBalance,
      hasCompletedOnboarding: true,
      updatedAt: DateTime.now(),
    );

    await db.updateSettings(updated);

    await db
        .into(db.budgets)
        .insertOnConflictUpdate(
          BudgetsCompanion.insert(
            dailyLimit: Value(_dailyLimit),
            savingsGoalPercent: const Value(20.0),
          ),
        );

    ref.invalidate(settingsProvider);
    ref.invalidate(budgetProvider);
    ref.invalidate(transactionsProvider);

    await QuickNotificationService.setEnabled(true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameText = _nameController.text.trim();
    final initials = nameText.isNotEmpty
        ? nameText
              .split(' ')
              .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
              .take(2)
              .join()
        : '?';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spaceMargin,
        AppTheme.spaceSm,
        AppTheme.spaceMargin,
        AppTheme.spaceXl,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Personalisation',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ).animate().fadeIn(),

          const SizedBox(height: AppTheme.spaceXs),

          Text(
            'Set up your profile and baseline budget preferences. You can always change these later in Settings.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
              height: 1.45,
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: AppTheme.spaceLg),

          GlassCard(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryCardGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.ambientGlow(
                          color: AppColors.primaryEmerald,
                          opacity: 0.22,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
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
                                'Your Name',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryEmerald.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  'Required',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryEmerald,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'This is how Pennora will greet you',
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
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Abhishek',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: AppTheme.spaceMd),

          GlassCard(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.currency_exchange_rounded,
                      size: 18,
                      color: AppColors.primaryEmerald,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Default Currency',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Used for all balances, budgets, and transaction amounts.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCurrency,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      alignment: Alignment.center,
                      width: 40,
                      child: Text(
                        _getSelectedCurrencySymbol(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                    ),
                  ),
                  items: _currencies.map((c) {
                    return DropdownMenuItem(
                      value: c.$1,
                      child: Text(
                        '${c.$2}  ${c.$3} (${c.$1})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCurrency = val);
                  },
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: AppTheme.spaceMd),

          IncomeManagerCard(
            currencySymbol: _getSelectedCurrencySymbol(),
            initialIncomeSources: _incomeSources,
            initialPriorSpent: _priorSpent,
            initialSavingsBalance: _savingsBalance,
            onChanged: (sources, totalIncome, priorSpent, savingsBalance, suggestedDailyLimit) {
              setState(() {
                _incomeSources = sources;
                _priorSpent = priorSpent;
                _savingsBalance = savingsBalance;
                _dailyLimit = suggestedDailyLimit;
                _limitController.text = suggestedDailyLimit.toStringAsFixed(0);
              });
            },
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: AppTheme.spaceMd),

          GlassCard(
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
                          Icons.tune_rounded,
                          size: 18,
                          color: AppColors.accentIndigo,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Daily Spending Limit',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentIndigo.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusFull,
                        ),
                      ),
                      child: Text(
                        '${_getSelectedCurrencySymbol()}${_dailyLimit.toStringAsFixed(0)}/day',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentIndigo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Pennora will alert you when you approach this limit. Use slider or enter exact amount below.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _limitController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter Custom Daily Limit',
                    prefixText: '${_getSelectedCurrencySymbol()} ',
                    prefixStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentIndigo,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      setState(() {
                        _dailyLimit = parsed;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                CustomGradientSlider(
                  value: _dailyLimit.clamp(50.0, 10000.0),
                  min: 50,
                  max: 10000,
                  divisions: 199,
                  onChanged: (val) {
                    setState(() {
                      _dailyLimit = val;
                      _limitController.text = val.toStringAsFixed(0);
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_getSelectedCurrencySymbol()}50',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${_getSelectedCurrencySymbol()}10,000',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: AppTheme.spaceLg),

          PressableScale(
            onTap: _isNameValid ? _finishOnboarding : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: _isNameValid ? AppColors.primaryButtonGradient : null,
                color: _isNameValid
                    ? null
                    : (isDark ? AppColors.darkSurfaceHigh : AppColors.gray300),
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                boxShadow: _isNameValid
                    ? AppTheme.ambientGlow(
                        color: AppColors.primaryEmerald,
                        opacity: 0.35,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isNameValid
                        ? Icons.rocket_launch_rounded
                        : Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isNameValid
                        ? 'Get Started with Pennora'
                        : 'Enter your name to continue',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.12, end: 0),

          const SizedBox(height: AppTheme.spaceXl),
        ],
      ),
    );
  }
}
