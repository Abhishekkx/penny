import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/providers.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/dashboard/presentation/main_navigation.dart';
import 'core/database/database.dart';
import 'core/services/quick_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.instance();
  await QuickNotificationService.initialize();
  runApp(const ProviderScope(child: PennoraApp()));
}

class PennoraApp extends ConsumerWidget {
  const PennoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Pennora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: settingsAsync.when(
        data: (settings) {
          if (!settings.hasCompletedOnboarding) {
            return const OnboardingScreen();
          }
          return const MainNavigation();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) =>
            Scaffold(body: Center(child: Text('Error loading app: $error'))),
      ),
    );
  }
}
