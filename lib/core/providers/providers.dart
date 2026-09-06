import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../services/quick_notification_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance();
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this.ref) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final Ref ref;

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('app_theme_mode') ?? 'system';
    switch (savedMode) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
        break;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String modeString = 'system';
    if (mode == ThemeMode.light) modeString = 'light';
    if (mode == ThemeMode.dark) modeString = 'dark';

    await prefs.setString('app_theme_mode', modeString);
    state = mode;
  }
}

final settingsProvider = FutureProvider<Setting>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.getSettings();
});

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final db = ref.read(databaseProvider);
  return db.select(db.transactions).watch();
});

final budgetProvider = StreamProvider<Budget?>((ref) {
  final db = ref.read(databaseProvider);
  return db.select(db.budgets).watchSingleOrNull();
});

final purchaseGoalsProvider = StreamProvider<List<PurchaseGoal>>((ref) {
  final db = ref.read(databaseProvider);
  return (db.select(db.purchaseGoals)
        ..where((g) => g.isCompleted.equals(false))
        ..orderBy([(g) => OrderingTerm.asc(g.createdAt)]))
      .watch();
});

final insightsProvider = StreamProvider<List<InsightsCacheData>>((ref) {
  final db = ref.read(databaseProvider);
  return (db.select(db.insightsCache)
        ..where((i) => i.isDismissed.equals(false))
        ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)])
        ..limit(10))
      .watch();
});

final chatHistoryProvider = FutureProvider<List<ChatMessage>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.getChatHistory();
});

final quickNotificationProvider =
    StateNotifierProvider<QuickNotificationNotifier, bool>((ref) {
      return QuickNotificationNotifier(ref);
    });

class QuickNotificationNotifier extends StateNotifier<bool> {
  QuickNotificationNotifier(this.ref) : super(true) {
    _loadStatus();
  }

  final Ref ref;

  Future<void> _loadStatus() async {
    final enabled = await QuickNotificationService.isEnabled();
    state = enabled;
  }

  Future<void> setEnabled(bool enabled) async {
    await QuickNotificationService.setEnabled(enabled);
    state = enabled;
  }
}
