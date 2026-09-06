import 'package:drift/drift.dart';
import '../database/database.dart';

class MockDataSeeder {
  static Future<void> seedIfEmpty(AppDatabase db) async {
    final transactions = await db.getAllTransactions();
    if (transactions.isEmpty) {
      await seedMockData(db);
    }
  }

  static Future<void> seedMockData(AppDatabase db) async {
    final settings = await db.getSettings();
    await db.updateSettings(
      settings.copyWith(
        userName: 'Alex',
        currency: 'INR',
        monthlyIncome: 75000.0,
        hasCompletedOnboarding: true,
        updatedAt: DateTime.now(),
      ),
    );

    final budget = await db.getCurrentBudget();
    if (budget != null) {
      await db.updateBudget(
        budget.copyWith(
          dailyLimit: 2000.0,
          savingsGoalPercent: 25.0,
          updatedAt: DateTime.now(),
        ),
      );
    }

    await db.delete(db.purchaseGoals).go();
    final now = DateTime.now();

    await db.insertPurchaseGoal(
      PurchaseGoalsCompanion.insert(
        name: 'MacBook Pro M3',
        targetPrice: 2000.0,
        savedAmount: const Value(1350.0), // 67.5% - passed 🎯 50%
        targetDate: Value(now.add(const Duration(days: 45))),
      ),
    );

    await db.insertPurchaseGoal(
      PurchaseGoalsCompanion.insert(
        name: 'Japan Cherry Blossom Trip',
        targetPrice: 3500.0,
        savedAmount: const Value(1750.0), // exactly 50% 🎯
        targetDate: Value(now.add(const Duration(days: 120))),
      ),
    );

    await db.insertPurchaseGoal(
      PurchaseGoalsCompanion.insert(
        name: 'Emergency Rainy Day Fund',
        targetPrice: 5000.0,
        savedAmount: const Value(4500.0), // 90% - almost 🚀
        targetDate: Value(now.add(const Duration(days: 60))),
      ),
    );

    await db.delete(db.transactions).go();

    final List<
      (TransactionType, double, TransactionCategory, bool, String, DateTime)
    >
    demoList = [
      (
        TransactionType.expense,
        8.50,
        TransactionCategory.food,
        false,
        'Morning Espresso & Croissant',
        DateTime(now.year, now.month, now.day, 8, 30),
      ),
      (
        TransactionType.expense,
        4.00,
        TransactionCategory.transport,
        true,
        'Subway Metro Transit',
        DateTime(now.year, now.month, now.day, 9, 15),
      ),
      (
        TransactionType.expense,
        16.50,
        TransactionCategory.food,
        true,
        'Mediterranean Bowl Lunch',
        DateTime(now.year, now.month, now.day, 13, 20),
      ),
      (
        TransactionType.expense,
        12.00,
        TransactionCategory.fun,
        false,
        'Afternoon Matcha & Pastry',
        DateTime(now.year, now.month, now.day, 16, 45),
      ),

      (
        TransactionType.expense,
        74.20,
        TransactionCategory.food,
        true,
        'Whole Foods Grocery Restock',
        DateTime(now.year, now.month, now.day - 1, 18, 30),
      ),
      (
        TransactionType.expense,
        22.50,
        TransactionCategory.health,
        true,
        'Pharmacy & Vitamins',
        DateTime(now.year, now.month, now.day - 1, 14, 10),
      ),
      (
        TransactionType.expense,
        35.00,
        TransactionCategory.transport,
        true,
        'Uber to Airport',
        DateTime(now.year, now.month, now.day - 1, 11, 0),
      ),

      (
        TransactionType.expense,
        115.00,
        TransactionCategory.housing,
        true,
        'Electric & Fiber Internet Bill',
        DateTime(now.year, now.month, now.day - 2, 10, 0),
      ),
      (
        TransactionType.expense,
        45.00,
        TransactionCategory.shopping,
        false,
        'Wireless Desk Charger',
        DateTime(now.year, now.month, now.day - 2, 15, 30),
      ),

      (
        TransactionType.expense,
        58.00,
        TransactionCategory.food,
        false,
        'Dinner with Friends at Bistro',
        DateTime(now.year, now.month, now.day - 3, 20, 15),
      ),
      (
        TransactionType.expense,
        24.00,
        TransactionCategory.fun,
        false,
        'Movie Theater Tickets',
        DateTime(now.year, now.month, now.day - 3, 22, 0),
      ),

      (
        TransactionType.expense,
        42.00,
        TransactionCategory.transport,
        true,
        'Gas Station Refill',
        DateTime(now.year, now.month, now.day - 4, 12, 30),
      ),

      (
        TransactionType.expense,
        35.00,
        TransactionCategory.shopping,
        false,
        'Kindle Books & Audiobooks',
        DateTime(now.year, now.month, now.day - 5, 17, 0),
      ),

      (
        TransactionType.expense,
        48.50,
        TransactionCategory.food,
        true,
        'Weekend Farmers Market Produce',
        DateTime(now.year, now.month, now.day - 6, 11, 30),
      ),

      (
        TransactionType.expense,
        55.00,
        TransactionCategory.health,
        true,
        'Fitness Gym Monthly Pass',
        DateTime(now.year, now.month, now.day - 7, 9, 0),
      ),

      (
        TransactionType.income,
        1200.00,
        TransactionCategory.freelance,
        true,
        'Mobile App UI Client Retainer',
        DateTime(now.year, now.month, now.day - 10, 14, 0),
      ),
      (
        TransactionType.investment,
        500.00,
        TransactionCategory.investment,
        true,
        'Index Fund Automatic Investment',
        DateTime(now.year, now.month, now.day - 12, 10, 0),
      ),
      (
        TransactionType.income,
        2250.00,
        TransactionCategory.salary,
        true,
        'Bi-weekly Tech Salary',
        DateTime(now.year, now.month, now.day - 15, 9, 0),
      ),
      (
        TransactionType.expense,
        85.00,
        TransactionCategory.transport,
        true,
        'Car Maintenance & Filter Service',
        DateTime(now.year, now.month, now.day - 18, 11, 30),
      ),
      (
        TransactionType.expense,
        28.00,
        TransactionCategory.other,
        true,
        'Cloud Server & Domain Renewals',
        DateTime(now.year, now.month, now.day - 22, 16, 0),
      ),
      (
        TransactionType.expense,
        65.00,
        TransactionCategory.housing,
        false,
        'Living Room Plants & Pottery',
        DateTime(now.year, now.month, now.day - 25, 14, 30),
      ),
      (
        TransactionType.expense,
        1200.00,
        TransactionCategory.housing,
        true,
        'Monthly Apartment Rent',
        DateTime(now.year, now.month, now.day - 28, 9, 0),
      ),
    ];

    for (final item in demoList) {
      await db.insertTransaction(
        TransactionsCompanion.insert(
          type: item.$1,
          amount: item.$2,
          category: item.$3,
          isNeed: Value(item.$4),
          note: Value(item.$5),
          date: item.$6,
        ),
      );
    }
  }
}
