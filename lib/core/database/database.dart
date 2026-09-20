import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

List<IncomeSourceItem> parseIncomeSources(String jsonStr) {
  try {
    final list = jsonDecode(jsonStr) as List?;
    if (list != null) {
      return list.map((e) => IncomeSourceItem.fromJson(e as Map<String, dynamic>)).toList();
    }
  } catch (_) {}
  return [];
}

/// Transaction types
enum TransactionType { income, expense, investment }

/// Transaction categories
enum TransactionCategory {
  food,
  transport,
  shopping,
  housing,
  health,
  fun,
  travel,
  other,
  salary,
  freelance,
  investment,
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<TransactionType>()();
  RealColumn get amount => real()();
  TextColumn get category => textEnum<TransactionCategory>()();
  BoolColumn get isNeed => boolean().withDefault(const Constant(true))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get dailyLimit => real().withDefault(const Constant(0))();
  RealColumn get savingsGoalPercent => real().withDefault(const Constant(20))();
  TextColumn get categoryBudgets =>
      text().withDefault(const Constant('{}'))(); // JSON map
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class PurchaseGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get targetPrice => real()();
  RealColumn get savedAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class InsightsCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get insightType => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get severity => text()(); // positive, warning, info
  TextColumn get dataSource => text()();
  DateTimeColumn get generatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().withDefault(const Constant(''))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  BoolColumn get isDarkMode => boolean().withDefault(const Constant(false))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  RealColumn get monthlyIncome => real().withDefault(const Constant(0))();
  TextColumn get incomeSources => text().withDefault(const Constant('[]'))();
  RealColumn get priorSpentThisMonth => real().withDefault(const Constant(0))();
  RealColumn get initialSavingsBalance => real().withDefault(const Constant(0))();
  BoolColumn get enableAIChat => boolean().withDefault(const Constant(false))();
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hasSeenIncomeNudge =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()(); // 'user' or 'model'
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class IncomeSourceItem {
  final String id;
  final String name;
  final double amount;
  final String category; // salary, freelance, investment, business, rental, other

  IncomeSourceItem({
    required this.id,
    required this.name,
    required this.amount,
    this.category = 'salary',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'category': category,
  };

  factory IncomeSourceItem.fromJson(Map<String, dynamic> json) => IncomeSourceItem(
    id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: json['name'] as String? ?? 'Income Source',
    amount: (json['amount'] as num? ?? 0.0).toDouble(),
    category: json['category'] as String? ?? 'other',
  );
}

@DriftDatabase(
  tables: [
    Transactions,
    Budgets,
    PurchaseGoals,
    InsightsCache,
    Settings,
    ChatMessages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(settings, settings.userName);
        await m.addColumn(settings, settings.hasSeenIncomeNudge);

        await customStatement(
          'UPDATE settings SET currency = ? WHERE currency = ?',
          ['INR', 'USD'],
        );
      }
      if (from < 3) {
        await m.createTable(chatMessages);
      }
      if (from < 4) {
        await m.addColumn(settings, settings.incomeSources);
        await m.addColumn(settings, settings.priorSpentThisMonth);
        await m.addColumn(settings, settings.initialSavingsBalance);
      }
    },
  );

  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase.instance() => _instance;
  AppDatabase._internal() : super(_openConnection());

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(transactions)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<Transaction>> getTransactionsByType(TransactionType type) {
    return (select(transactions)..where((t) => t.type.equals(type.name))).get();
  }

  Future<int> insertTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  Future<bool> updateTransaction(Transaction entry) {
    return update(transactions).replace(entry);
  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<Budget?> getCurrentBudget() async {
    final results = await select(budgets).get();
    if (results.isEmpty) {
      final id = await into(budgets).insert(BudgetsCompanion.insert());
      return (select(budgets)..where((b) => b.id.equals(id))).getSingle();
    }
    return results.first;
  }

  Future<bool> updateBudget(Budget entry) {
    return update(budgets).replace(entry);
  }

  Future<List<PurchaseGoal>> getAllPurchaseGoals() {
    return (select(purchaseGoals)
          ..where((g) => g.isCompleted.equals(false))
          ..orderBy([(g) => OrderingTerm.asc(g.createdAt)]))
        .get();
  }

  Future<int> insertPurchaseGoal(PurchaseGoalsCompanion entry) {
    return into(purchaseGoals).insert(entry);
  }

  Future<bool> updatePurchaseGoal(PurchaseGoal entry) {
    return update(purchaseGoals).replace(entry);
  }

  Future<int> deletePurchaseGoal(int id) {
    return (delete(purchaseGoals)..where((g) => g.id.equals(id))).go();
  }

  Future<List<InsightsCacheData>> getActiveInsights() {
    return (select(insightsCache)
          ..where((i) => i.isDismissed.equals(false))
          ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)])
          ..limit(10))
        .get();
  }

  Future<int> insertInsight(InsightsCacheCompanion entry) {
    return into(insightsCache).insert(entry);
  }

  Future<int> clearOldInsights() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return (delete(
      insightsCache,
    )..where((i) => i.generatedAt.isSmallerThanValue(thirtyDaysAgo))).go();
  }

  Future<Setting> getSettings() async {
    final results = await select(settings).get();
    if (results.isEmpty) {
      final id = await into(settings).insert(SettingsCompanion.insert());
      return (select(settings)..where((s) => s.id.equals(id))).getSingle();
    }
    return results.first;
  }

  Future<bool> updateSettings(Setting entry) {
    return update(settings).replace(entry);
  }

  Future<List<ChatMessage>> getChatHistory() {
    return (select(
      chatMessages,
    )..orderBy([(c) => OrderingTerm.asc(c.timestamp)])).get();
  }

  Future<int> insertChatMessage(ChatMessagesCompanion entry) {
    return into(chatMessages).insert(entry);
  }

  Future<int> clearChatHistory() {
    return delete(chatMessages).go();
  }

  Future<void> clearAllDatabaseData() async {
    await delete(transactions).go();
    await delete(purchaseGoals).go();
    await delete(insightsCache).go();
    await delete(budgets).go();
    await delete(settings).go();
    await delete(chatMessages).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pennora.db'));
    return NativeDatabase(file);
  });
}
