import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../transactions/presentation/add_transaction_sheet.dart';
import '../../ai_chat/presentation/talk_to_pocket_screen.dart';
import '../../../core/utils/csv_exporter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isQuickNotifEnabled = ref.watch(quickNotificationProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: settingsAsync.when(
            data: (settings) => ListView(
              physics: const BouncingScrollPhysics(),
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
                        'Settings',
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

                GlassCard(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
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
                            settings.userName.isNotEmpty
                                ? settings.userName
                                      .split(' ')
                                      .map(
                                        (w) => w.isNotEmpty
                                            ? w[0].toUpperCase()
                                            : '',
                                      )
                                      .take(2)
                                      .join()
                                : '?',
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
                            Text(
                              settings.userName.isNotEmpty
                                  ? settings.userName
                                  : 'Set your name',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${settings.currency} • ₹${settings.monthlyIncome.toStringAsFixed(0)}/month',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PressableScale(
                        onTap: () =>
                            _showEditProfileSheet(context, ref, settings),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                            border: Border.all(
                              color: AppColors.primaryEmerald.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            'Edit',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),

                const SizedBox(height: AppTheme.spaceXl),

                Text(
                  'Preferences',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: AppTheme.spaceSm),

                GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildSettingTile(
                            context,
                            title: 'Currency',
                            subtitle: settings.currency,
                            icon: Icons.currency_exchange_rounded,
                            iconBgColor: AppColors.primaryEmerald.withValues(
                              alpha: 0.15,
                            ),
                            iconColor: AppColors.primaryEmerald,
                            onTap: () =>
                                _showCurrencyPicker(context, ref, settings),
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingTile(
                            context,
                            title: 'Monthly Income',
                            subtitle: settings.monthlyIncome > 0
                                ? CurrencyHelper.formatAmount(
                                    settings.monthlyIncome,
                                    settings.currency,
                                  )
                                : 'Set regular income',
                            icon: Icons.account_balance_wallet_rounded,
                            iconBgColor: AppColors.tertiary.withValues(
                              alpha: 0.15,
                            ),
                            iconColor: AppColors.tertiary,
                            onTap: () =>
                                _showIncomeDialog(context, ref, settings),
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingTile(
                            context,
                            title: 'App Theme',
                            subtitle: themeMode == ThemeMode.system
                                ? 'System Default (Follows phone)'
                                : (themeMode == ThemeMode.dark
                                      ? 'Dark Theme'
                                      : 'Light Theme'),
                            icon: Icons.palette_outlined,
                            iconBgColor: AppColors.accentIndigo.withValues(
                              alpha: 0.15,
                            ),
                            iconColor: AppColors.accentIndigo,
                            onTap: () =>
                                _showThemePicker(context, ref, themeMode),
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingTile(
                            context,
                            title: 'Talk to your Pocket',
                            subtitle: 'AI financial coach powered by Gemini',
                            icon: Icons.auto_awesome_rounded,
                            iconBgColor: AppColors.primaryEmerald.withValues(
                              alpha: 0.15,
                            ),
                            iconColor: AppColors.primaryEmerald,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TalkToPocketScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingTile(
                            context,
                            title: 'Quick Record Notification',
                            subtitle: isQuickNotifEnabled
                                ? 'Sticky status bar shortcut active'
                                : 'Status bar shortcut disabled',
                            icon: Icons.notifications_active_rounded,
                            iconBgColor: AppColors.primaryEmerald.withValues(
                              alpha: 0.15,
                            ),
                            iconColor: AppColors.primaryEmerald,
                            trailing: Switch.adaptive(
                              value: isQuickNotifEnabled,
                              activeColor: AppColors.primaryEmerald,
                              onChanged: (val) {
                                HapticFeedback.selectionClick();
                                ref
                                    .read(quickNotificationProvider.notifier)
                                    .setEnabled(val);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 350.ms, delay: 50.ms)
                    .slideY(begin: 0.08, end: 0),

                const SizedBox(height: AppTheme.spaceXl),

                Text(
                  'Data & Security',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                const SizedBox(height: AppTheme.spaceSm),

                GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildSettingTile(
                            context,
                            title: 'Export Data (CSV / Excel)',
                            subtitle:
                                'Download all financial records to device',
                            icon: Icons.file_download_outlined,
                            iconBgColor: AppColors.info.withValues(alpha: 0.15),
                            iconColor: AppColors.info,
                            onTap: () async {
                              HapticFeedback.selectionClick();
                              final transactions =
                                  ref.read(transactionsProvider).value ?? [];
                              final symbol = CurrencyHelper.getSymbol(
                                settings.currency,
                              );
                              final file = await CsvExporter.exportAndShareCsv(
                                transactions: transactions,
                                currencySymbol: symbol,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Exported ${transactions.length} records to ${file.path.split('/').last}',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingTile(
                            context,
                            title: 'Reset All Data',
                            subtitle: 'Erase all transactions, budgets & goals',
                            icon: Icons.delete_forever_rounded,
                            iconBgColor: AppColors.error.withValues(
                              alpha: 0.15,
                            ),
                            iconColor: AppColors.error,
                            onTap: () => _showResetConfirmation(context, ref),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 350.ms, delay: 150.ms)
                    .slideY(begin: 0.08, end: 0),

                const SizedBox(height: AppTheme.spaceXl * 1.5),

                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusFull,
                          ),
                          border: Border.all(
                            color: AppColors.primaryEmerald.withValues(
                              alpha: 0.35,
                            ),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryEmerald.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_rounded,
                              color: AppColors.primaryEmerald,
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'All data stored locally on your device',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.primaryEmerald,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceSm),
                      Text(
                        'Penny v1.0.0 • Offline Drift Database',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                const SizedBox(height: 80),
              ],
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) =>
                const Center(child: Text('Error loading settings')),
          ),
        ),
      ),
    );
  }

  void _showEditProfileSheet(
    BuildContext context,
    WidgetRef ref,
    Setting settings,
  ) {
    final nameController = TextEditingController(text: settings.userName);
    final incomeController = TextEditingController(
      text: settings.monthlyIncome > 0
          ? settings.monthlyIncome.toStringAsFixed(0)
          : '',
    );
    String selectedCurrency = settings.currency;

    const currencies = [
      ('INR', '₹', 'Indian Rupee'),
      ('USD', '\$', 'US Dollar'),
      ('EUR', '€', 'Euro'),
      ('GBP', '£', 'British Pound'),
      ('JPY', '¥', 'Japanese Yen'),
      ('AUD', 'A\$', 'Australian Dollar'),
      ('CAD', 'C\$', 'Canadian Dollar'),
      ('SGD', 'S\$', 'Singapore Dollar'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final symbol = currencies
                .firstWhere((c) => c.$1 == selectedCurrency)
                .$2;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgStart : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXl),
                ),
                border: Border.all(
                  color: isDark
                      ? AppColors.glassBorderDark
                      : AppColors.cardBorder,
                  width: 1.2,
                ),
              ),
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceLg,
                left: AppTheme.spaceLg,
                right: AppTheme.spaceLg,
                top: AppTheme.spaceMd,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusFull,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),

                    Text(
                      'Edit Profile',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update your name, currency, and income preferences.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceLg),

                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        hintText: 'e.g. Abhishek',
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),

                    DropdownButtonFormField<String>(
                      value: selectedCurrency,
                      decoration: InputDecoration(
                        labelText: 'Default Currency',
                        prefixIcon: Container(
                          alignment: Alignment.center,
                          width: 40,
                          child: Text(
                            symbol,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ),
                      ),
                      items: currencies.map((c) {
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
                        if (val != null) {
                          setModalState(() => selectedCurrency = val);
                        }
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceMd),

                    TextField(
                      controller: incomeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monthly Income (Optional)',
                        prefixText: '$symbol ',
                        prefixStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryEmerald,
                        ),
                        hintText: '50000',
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceLg),

                    PressableScale(
                      onTap: () async {
                        final db = ref.read(databaseProvider);
                        final income =
                            double.tryParse(incomeController.text) ?? 0;
                        final updated = settings.copyWith(
                          userName: nameController.text.trim(),
                          currency: selectedCurrency,
                          monthlyIncome: income,
                          updatedAt: DateTime.now(),
                        );
                        await db.updateSettings(updated);
                        ref.invalidate(settingsProvider);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully ✅'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusDefault,
                          ),
                          boxShadow: AppTheme.ambientGlow(
                            color: AppColors.primaryEmerald,
                            opacity: 0.3,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Save Profile',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    Setting settings,
  ) {
    final currencies = [
      ('INR', 'Indian Rupee (₹)'),
      ('USD', 'US Dollar (\$)'),
      ('EUR', 'Euro (€)'),
      ('GBP', 'British Pound (£)'),
      ('JPY', 'Japanese Yen (¥)'),
      ('AUD', 'Australian Dollar (A\$)'),
      ('CAD', 'Canadian Dollar (C\$)'),
      ('SGD', 'Singapore Dollar (S\$)'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgStart : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusXl),
            ),
            border: Border.all(
              color: isDark ? AppColors.glassBorderDark : AppColors.cardBorder,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spaceLg,
            AppTheme.spaceMd,
            AppTheme.spaceLg,
            AppTheme.spaceLg,
          ),
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
              Text(
                'Select Currency',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTheme.spaceSm),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: currencies.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final curr = currencies[index];
                    final code = curr.$1;
                    final label = curr.$2;
                    final isSelected = settings.currency == code;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      title: Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryEmerald,
                            )
                          : null,
                      onTap: () async {
                        final db = ref.read(databaseProvider);
                        final updated = settings.copyWith(
                          currency: code,
                          updatedAt: DateTime.now(),
                        );
                        await db.updateSettings(updated);
                        ref.invalidate(settingsProvider);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIncomeDialog(
    BuildContext context,
    WidgetRef ref,
    Setting settings,
  ) {
    final controller = TextEditingController(
      text: settings.monthlyIncome > 0
          ? settings.monthlyIncome.toStringAsFixed(0)
          : '',
    );
    final symbol = CurrencyHelper.getSymbol(settings.currency);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
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
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceLg,
            left: AppTheme.spaceLg,
            right: AppTheme.spaceLg,
            top: AppTheme.spaceMd,
          ),
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
              Text(
                'Set Monthly Income',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Used for budget pacing and savings rate calculation.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  labelText: 'Regular Monthly Income',
                  prefixText: '$symbol ',
                  prefixStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryEmerald,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),
              PressableScale(
                onTap: () async {
                  final amount = double.tryParse(controller.text) ?? 0;
                  final db = ref.read(databaseProvider);
                  final updated = settings.copyWith(
                    monthlyIncome: amount,
                    updatedAt: DateTime.now(),
                  );
                  await db.updateSettings(updated);
                  ref.invalidate(settingsProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Monthly income updated')),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Save Income',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'Warning: This will permanently delete all your transactions, monthly income, daily limits, purchase goals, and profile settings. This data cannot be recovered once deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);

              await db.clearAllDatabaseData();

              ref.invalidate(settingsProvider);
              ref.invalidate(transactionsProvider);
              ref.invalidate(purchaseGoalsProvider);
              ref.invalidate(insightsProvider);
              ref.invalidate(budgetProvider);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data permanently reset.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgStart : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusLg),
            ),
            border: Border.all(
              color: isDark ? AppColors.glassBorderDark : AppColors.cardBorder,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App Theme',
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
              Text(
                'By default, Penny matches your phone\'s system theme settings.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              _buildThemeOptionTile(
                context: context,
                ref: ref,
                title: 'System Default',
                subtitle: 'Automatically follow phone settings (Default)',
                icon: Icons.phone_android_rounded,
                mode: ThemeMode.system,
                currentMode: currentMode,
              ),
              const SizedBox(height: 8),
              _buildThemeOptionTile(
                context: context,
                ref: ref,
                title: 'Light Theme',
                subtitle: 'Always use clean light theme',
                icon: Icons.light_mode_rounded,
                mode: ThemeMode.light,
                currentMode: currentMode,
              ),
              const SizedBox(height: 8),
              _buildThemeOptionTile(
                context: context,
                ref: ref,
                title: 'Dark Theme',
                subtitle: 'Always use deep dark theme',
                icon: Icons.dark_mode_rounded,
                mode: ThemeMode.dark,
                currentMode: currentMode,
              ),
              const SizedBox(height: AppTheme.spaceLg),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOptionTile({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
  }) {
    final isSelected = mode == currentMode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PressableScale(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryEmerald.withValues(alpha: 0.12)
              : (isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.5)
                    : AppColors.gray50),
          borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryEmerald
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.cardBorder),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryEmerald
                  : AppColors.onSurfaceVariant,
              size: 20,
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
                      color: isSelected ? AppColors.primaryEmerald : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryEmerald,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
