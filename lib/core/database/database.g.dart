// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TransactionCategory>($TransactionsTable.$convertercategory);
  static const VerificationMeta _isNeedMeta = const VerificationMeta('isNeed');
  @override
  late final GeneratedColumn<bool> isNeed = GeneratedColumn<bool>(
    'is_need',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_need" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amount,
    category,
    isNeed,
    note,
    date,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_need')) {
      context.handle(
        _isNeedMeta,
        isNeed.isAcceptableOrUnknown(data['is_need']!, _isNeedMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: $TransactionsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      isNeed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_need'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionCategory, String, String>
  $convertercategory = const EnumNameConverter<TransactionCategory>(
    TransactionCategory.values,
  );
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final TransactionType type;
  final double amount;
  final TransactionCategory category;
  final bool isNeed;
  final String note;
  final DateTime date;
  final DateTime createdAt;
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.isNeed,
    required this.note,
    required this.date,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount'] = Variable<double>(amount);
    {
      map['category'] = Variable<String>(
        $TransactionsTable.$convertercategory.toSql(category),
      );
    }
    map['is_need'] = Variable<bool>(isNeed);
    map['note'] = Variable<String>(note);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      category: Value(category),
      isNeed: Value(isNeed),
      note: Value(note),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      amount: serializer.fromJson<double>(json['amount']),
      category: $TransactionsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      isNeed: serializer.fromJson<bool>(json['isNeed']),
      note: serializer.fromJson<String>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(
        $TransactionsTable.$convertercategory.toJson(category),
      ),
      'isNeed': serializer.toJson<bool>(isNeed),
      'note': serializer.toJson<String>(note),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith({
    int? id,
    TransactionType? type,
    double? amount,
    TransactionCategory? category,
    bool? isNeed,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) => Transaction(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    isNeed: isNeed ?? this.isNeed,
    note: note ?? this.note,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      isNeed: data.isNeed.present ? data.isNeed.value : this.isNeed,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('isNeed: $isNeed, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, amount, category, isNeed, note, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.isNeed == this.isNeed &&
          other.note == this.note &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<TransactionType> type;
  final Value<double> amount;
  final Value<TransactionCategory> category;
  final Value<bool> isNeed;
  final Value<String> note;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.isNeed = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required TransactionType type,
    required double amount,
    required TransactionCategory category,
    this.isNeed = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  }) : type = Value(type),
       amount = Value(amount),
       category = Value(category),
       date = Value(date);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<bool>? isNeed,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (isNeed != null) 'is_need': isNeed,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<TransactionType>? type,
    Value<double>? amount,
    Value<TransactionCategory>? category,
    Value<bool>? isNeed,
    Value<String>? note,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isNeed: isNeed ?? this.isNeed,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $TransactionsTable.$convertercategory.toSql(category.value),
      );
    }
    if (isNeed.present) {
      map['is_need'] = Variable<bool>(isNeed.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('isNeed: $isNeed, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dailyLimitMeta = const VerificationMeta(
    'dailyLimit',
  );
  @override
  late final GeneratedColumn<double> dailyLimit = GeneratedColumn<double>(
    'daily_limit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savingsGoalPercentMeta =
      const VerificationMeta('savingsGoalPercent');
  @override
  late final GeneratedColumn<double> savingsGoalPercent =
      GeneratedColumn<double>(
        'savings_goal_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(20),
      );
  static const VerificationMeta _categoryBudgetsMeta = const VerificationMeta(
    'categoryBudgets',
  );
  @override
  late final GeneratedColumn<String> categoryBudgets = GeneratedColumn<String>(
    'category_budgets',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyLimit,
    savingsGoalPercent,
    categoryBudgets,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_limit')) {
      context.handle(
        _dailyLimitMeta,
        dailyLimit.isAcceptableOrUnknown(data['daily_limit']!, _dailyLimitMeta),
      );
    }
    if (data.containsKey('savings_goal_percent')) {
      context.handle(
        _savingsGoalPercentMeta,
        savingsGoalPercent.isAcceptableOrUnknown(
          data['savings_goal_percent']!,
          _savingsGoalPercentMeta,
        ),
      );
    }
    if (data.containsKey('category_budgets')) {
      context.handle(
        _categoryBudgetsMeta,
        categoryBudgets.isAcceptableOrUnknown(
          data['category_budgets']!,
          _categoryBudgetsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_limit'],
      )!,
      savingsGoalPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}savings_goal_percent'],
      )!,
      categoryBudgets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_budgets'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final double dailyLimit;
  final double savingsGoalPercent;
  final String categoryBudgets;
  final DateTime updatedAt;
  const Budget({
    required this.id,
    required this.dailyLimit,
    required this.savingsGoalPercent,
    required this.categoryBudgets,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_limit'] = Variable<double>(dailyLimit);
    map['savings_goal_percent'] = Variable<double>(savingsGoalPercent);
    map['category_budgets'] = Variable<String>(categoryBudgets);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      dailyLimit: Value(dailyLimit),
      savingsGoalPercent: Value(savingsGoalPercent),
      categoryBudgets: Value(categoryBudgets),
      updatedAt: Value(updatedAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      dailyLimit: serializer.fromJson<double>(json['dailyLimit']),
      savingsGoalPercent: serializer.fromJson<double>(
        json['savingsGoalPercent'],
      ),
      categoryBudgets: serializer.fromJson<String>(json['categoryBudgets']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyLimit': serializer.toJson<double>(dailyLimit),
      'savingsGoalPercent': serializer.toJson<double>(savingsGoalPercent),
      'categoryBudgets': serializer.toJson<String>(categoryBudgets),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Budget copyWith({
    int? id,
    double? dailyLimit,
    double? savingsGoalPercent,
    String? categoryBudgets,
    DateTime? updatedAt,
  }) => Budget(
    id: id ?? this.id,
    dailyLimit: dailyLimit ?? this.dailyLimit,
    savingsGoalPercent: savingsGoalPercent ?? this.savingsGoalPercent,
    categoryBudgets: categoryBudgets ?? this.categoryBudgets,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      dailyLimit: data.dailyLimit.present
          ? data.dailyLimit.value
          : this.dailyLimit,
      savingsGoalPercent: data.savingsGoalPercent.present
          ? data.savingsGoalPercent.value
          : this.savingsGoalPercent,
      categoryBudgets: data.categoryBudgets.present
          ? data.categoryBudgets.value
          : this.categoryBudgets,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('dailyLimit: $dailyLimit, ')
          ..write('savingsGoalPercent: $savingsGoalPercent, ')
          ..write('categoryBudgets: $categoryBudgets, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyLimit,
    savingsGoalPercent,
    categoryBudgets,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.dailyLimit == this.dailyLimit &&
          other.savingsGoalPercent == this.savingsGoalPercent &&
          other.categoryBudgets == this.categoryBudgets &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<double> dailyLimit;
  final Value<double> savingsGoalPercent;
  final Value<String> categoryBudgets;
  final Value<DateTime> updatedAt;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.dailyLimit = const Value.absent(),
    this.savingsGoalPercent = const Value.absent(),
    this.categoryBudgets = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    this.dailyLimit = const Value.absent(),
    this.savingsGoalPercent = const Value.absent(),
    this.categoryBudgets = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<double>? dailyLimit,
    Expression<double>? savingsGoalPercent,
    Expression<String>? categoryBudgets,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyLimit != null) 'daily_limit': dailyLimit,
      if (savingsGoalPercent != null)
        'savings_goal_percent': savingsGoalPercent,
      if (categoryBudgets != null) 'category_budgets': categoryBudgets,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<double>? dailyLimit,
    Value<double>? savingsGoalPercent,
    Value<String>? categoryBudgets,
    Value<DateTime>? updatedAt,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      savingsGoalPercent: savingsGoalPercent ?? this.savingsGoalPercent,
      categoryBudgets: categoryBudgets ?? this.categoryBudgets,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyLimit.present) {
      map['daily_limit'] = Variable<double>(dailyLimit.value);
    }
    if (savingsGoalPercent.present) {
      map['savings_goal_percent'] = Variable<double>(savingsGoalPercent.value);
    }
    if (categoryBudgets.present) {
      map['category_budgets'] = Variable<String>(categoryBudgets.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('dailyLimit: $dailyLimit, ')
          ..write('savingsGoalPercent: $savingsGoalPercent, ')
          ..write('categoryBudgets: $categoryBudgets, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseGoalsTable extends PurchaseGoals
    with TableInfo<$PurchaseGoalsTable, PurchaseGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPriceMeta = const VerificationMeta(
    'targetPrice',
  );
  @override
  late final GeneratedColumn<double> targetPrice = GeneratedColumn<double>(
    'target_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAmountMeta = const VerificationMeta(
    'savedAmount',
  );
  @override
  late final GeneratedColumn<double> savedAmount = GeneratedColumn<double>(
    'saved_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetPrice,
    savedAmount,
    targetDate,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_price')) {
      context.handle(
        _targetPriceMeta,
        targetPrice.isAcceptableOrUnknown(
          data['target_price']!,
          _targetPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPriceMeta);
    }
    if (data.containsKey('saved_amount')) {
      context.handle(
        _savedAmountMeta,
        savedAmount.isAcceptableOrUnknown(
          data['saved_amount']!,
          _savedAmountMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_price'],
      )!,
      savedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saved_amount'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PurchaseGoalsTable createAlias(String alias) {
    return $PurchaseGoalsTable(attachedDatabase, alias);
  }
}

class PurchaseGoal extends DataClass implements Insertable<PurchaseGoal> {
  final int id;
  final String name;
  final double targetPrice;
  final double savedAmount;
  final DateTime? targetDate;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PurchaseGoal({
    required this.id,
    required this.name,
    required this.targetPrice,
    required this.savedAmount,
    this.targetDate,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_price'] = Variable<double>(targetPrice);
    map['saved_amount'] = Variable<double>(savedAmount);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchaseGoalsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetPrice: Value(targetPrice),
      savedAmount: Value(savedAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PurchaseGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseGoal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetPrice: serializer.fromJson<double>(json['targetPrice']),
      savedAmount: serializer.fromJson<double>(json['savedAmount']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetPrice': serializer.toJson<double>(targetPrice),
      'savedAmount': serializer.toJson<double>(savedAmount),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PurchaseGoal copyWith({
    int? id,
    String? name,
    double? targetPrice,
    double? savedAmount,
    Value<DateTime?> targetDate = const Value.absent(),
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PurchaseGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetPrice: targetPrice ?? this.targetPrice,
    savedAmount: savedAmount ?? this.savedAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PurchaseGoal copyWithCompanion(PurchaseGoalsCompanion data) {
    return PurchaseGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetPrice: data.targetPrice.present
          ? data.targetPrice.value
          : this.targetPrice,
      savedAmount: data.savedAmount.present
          ? data.savedAmount.value
          : this.savedAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('savedAmount: $savedAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetPrice,
    savedAmount,
    targetDate,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetPrice == this.targetPrice &&
          other.savedAmount == this.savedAmount &&
          other.targetDate == this.targetDate &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchaseGoalsCompanion extends UpdateCompanion<PurchaseGoal> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> targetPrice;
  final Value<double> savedAmount;
  final Value<DateTime?> targetDate;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PurchaseGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.savedAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PurchaseGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double targetPrice,
    this.savedAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       targetPrice = Value(targetPrice);
  static Insertable<PurchaseGoal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? targetPrice,
    Expression<double>? savedAmount,
    Expression<DateTime>? targetDate,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetPrice != null) 'target_price': targetPrice,
      if (savedAmount != null) 'saved_amount': savedAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PurchaseGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? targetPrice,
    Value<double>? savedAmount,
    Value<DateTime?>? targetDate,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PurchaseGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetPrice: targetPrice ?? this.targetPrice,
      savedAmount: savedAmount ?? this.savedAmount,
      targetDate: targetDate ?? this.targetDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetPrice.present) {
      map['target_price'] = Variable<double>(targetPrice.value);
    }
    if (savedAmount.present) {
      map['saved_amount'] = Variable<double>(savedAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('savedAmount: $savedAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InsightsCacheTable extends InsightsCache
    with TableInfo<$InsightsCacheTable, InsightsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _insightTypeMeta = const VerificationMeta(
    'insightType',
  );
  @override
  late final GeneratedColumn<String> insightType = GeneratedColumn<String>(
    'insight_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataSourceMeta = const VerificationMeta(
    'dataSource',
  );
  @override
  late final GeneratedColumn<String> dataSource = GeneratedColumn<String>(
    'data_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    insightType,
    title,
    description,
    severity,
    dataSource,
    generatedAt,
    isDismissed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insights_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<InsightsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('insight_type')) {
      context.handle(
        _insightTypeMeta,
        insightType.isAcceptableOrUnknown(
          data['insight_type']!,
          _insightTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_insightTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('data_source')) {
      context.handle(
        _dataSourceMeta,
        dataSource.isAcceptableOrUnknown(data['data_source']!, _dataSourceMeta),
      );
    } else if (isInserting) {
      context.missing(_dataSourceMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InsightsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InsightsCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      insightType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insight_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      dataSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_source'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
    );
  }

  @override
  $InsightsCacheTable createAlias(String alias) {
    return $InsightsCacheTable(attachedDatabase, alias);
  }
}

class InsightsCacheData extends DataClass
    implements Insertable<InsightsCacheData> {
  final int id;
  final String insightType;
  final String title;
  final String description;
  final String severity;
  final String dataSource;
  final DateTime generatedAt;
  final bool isDismissed;
  const InsightsCacheData({
    required this.id,
    required this.insightType,
    required this.title,
    required this.description,
    required this.severity,
    required this.dataSource,
    required this.generatedAt,
    required this.isDismissed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['insight_type'] = Variable<String>(insightType);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['severity'] = Variable<String>(severity);
    map['data_source'] = Variable<String>(dataSource);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    return map;
  }

  InsightsCacheCompanion toCompanion(bool nullToAbsent) {
    return InsightsCacheCompanion(
      id: Value(id),
      insightType: Value(insightType),
      title: Value(title),
      description: Value(description),
      severity: Value(severity),
      dataSource: Value(dataSource),
      generatedAt: Value(generatedAt),
      isDismissed: Value(isDismissed),
    );
  }

  factory InsightsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InsightsCacheData(
      id: serializer.fromJson<int>(json['id']),
      insightType: serializer.fromJson<String>(json['insightType']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      severity: serializer.fromJson<String>(json['severity']),
      dataSource: serializer.fromJson<String>(json['dataSource']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'insightType': serializer.toJson<String>(insightType),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'severity': serializer.toJson<String>(severity),
      'dataSource': serializer.toJson<String>(dataSource),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'isDismissed': serializer.toJson<bool>(isDismissed),
    };
  }

  InsightsCacheData copyWith({
    int? id,
    String? insightType,
    String? title,
    String? description,
    String? severity,
    String? dataSource,
    DateTime? generatedAt,
    bool? isDismissed,
  }) => InsightsCacheData(
    id: id ?? this.id,
    insightType: insightType ?? this.insightType,
    title: title ?? this.title,
    description: description ?? this.description,
    severity: severity ?? this.severity,
    dataSource: dataSource ?? this.dataSource,
    generatedAt: generatedAt ?? this.generatedAt,
    isDismissed: isDismissed ?? this.isDismissed,
  );
  InsightsCacheData copyWithCompanion(InsightsCacheCompanion data) {
    return InsightsCacheData(
      id: data.id.present ? data.id.value : this.id,
      insightType: data.insightType.present
          ? data.insightType.value
          : this.insightType,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      severity: data.severity.present ? data.severity.value : this.severity,
      dataSource: data.dataSource.present
          ? data.dataSource.value
          : this.dataSource,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCacheData(')
          ..write('id: $id, ')
          ..write('insightType: $insightType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('dataSource: $dataSource, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    insightType,
    title,
    description,
    severity,
    dataSource,
    generatedAt,
    isDismissed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InsightsCacheData &&
          other.id == this.id &&
          other.insightType == this.insightType &&
          other.title == this.title &&
          other.description == this.description &&
          other.severity == this.severity &&
          other.dataSource == this.dataSource &&
          other.generatedAt == this.generatedAt &&
          other.isDismissed == this.isDismissed);
}

class InsightsCacheCompanion extends UpdateCompanion<InsightsCacheData> {
  final Value<int> id;
  final Value<String> insightType;
  final Value<String> title;
  final Value<String> description;
  final Value<String> severity;
  final Value<String> dataSource;
  final Value<DateTime> generatedAt;
  final Value<bool> isDismissed;
  const InsightsCacheCompanion({
    this.id = const Value.absent(),
    this.insightType = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.severity = const Value.absent(),
    this.dataSource = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.isDismissed = const Value.absent(),
  });
  InsightsCacheCompanion.insert({
    this.id = const Value.absent(),
    required String insightType,
    required String title,
    required String description,
    required String severity,
    required String dataSource,
    this.generatedAt = const Value.absent(),
    this.isDismissed = const Value.absent(),
  }) : insightType = Value(insightType),
       title = Value(title),
       description = Value(description),
       severity = Value(severity),
       dataSource = Value(dataSource);
  static Insertable<InsightsCacheData> custom({
    Expression<int>? id,
    Expression<String>? insightType,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? severity,
    Expression<String>? dataSource,
    Expression<DateTime>? generatedAt,
    Expression<bool>? isDismissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (insightType != null) 'insight_type': insightType,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (severity != null) 'severity': severity,
      if (dataSource != null) 'data_source': dataSource,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (isDismissed != null) 'is_dismissed': isDismissed,
    });
  }

  InsightsCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? insightType,
    Value<String>? title,
    Value<String>? description,
    Value<String>? severity,
    Value<String>? dataSource,
    Value<DateTime>? generatedAt,
    Value<bool>? isDismissed,
  }) {
    return InsightsCacheCompanion(
      id: id ?? this.id,
      insightType: insightType ?? this.insightType,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      dataSource: dataSource ?? this.dataSource,
      generatedAt: generatedAt ?? this.generatedAt,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (insightType.present) {
      map['insight_type'] = Variable<String>(insightType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (dataSource.present) {
      map['data_source'] = Variable<String>(dataSource.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCacheCompanion(')
          ..write('id: $id, ')
          ..write('insightType: $insightType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('dataSource: $dataSource, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _isDarkModeMeta = const VerificationMeta(
    'isDarkMode',
  );
  @override
  late final GeneratedColumn<bool> isDarkMode = GeneratedColumn<bool>(
    'is_dark_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dark_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _monthlyIncomeMeta = const VerificationMeta(
    'monthlyIncome',
  );
  @override
  late final GeneratedColumn<double> monthlyIncome = GeneratedColumn<double>(
    'monthly_income',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incomeSourcesMeta = const VerificationMeta(
    'incomeSources',
  );
  @override
  late final GeneratedColumn<String> incomeSources = GeneratedColumn<String>(
    'income_sources',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _priorSpentThisMonthMeta =
      const VerificationMeta('priorSpentThisMonth');
  @override
  late final GeneratedColumn<double> priorSpentThisMonth =
      GeneratedColumn<double>(
        'prior_spent_this_month',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _initialSavingsBalanceMeta =
      const VerificationMeta('initialSavingsBalance');
  @override
  late final GeneratedColumn<double> initialSavingsBalance =
      GeneratedColumn<double>(
        'initial_savings_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _enableAIChatMeta = const VerificationMeta(
    'enableAIChat',
  );
  @override
  late final GeneratedColumn<bool> enableAIChat = GeneratedColumn<bool>(
    'enable_a_i_chat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_a_i_chat" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasCompletedOnboardingMeta =
      const VerificationMeta('hasCompletedOnboarding');
  @override
  late final GeneratedColumn<bool> hasCompletedOnboarding =
      GeneratedColumn<bool>(
        'has_completed_onboarding',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_onboarding" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _hasSeenIncomeNudgeMeta =
      const VerificationMeta('hasSeenIncomeNudge');
  @override
  late final GeneratedColumn<bool> hasSeenIncomeNudge = GeneratedColumn<bool>(
    'has_seen_income_nudge',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_seen_income_nudge" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userName,
    currency,
    isDarkMode,
    language,
    monthlyIncome,
    incomeSources,
    priorSpentThisMonth,
    initialSavingsBalance,
    enableAIChat,
    hasCompletedOnboarding,
    hasSeenIncomeNudge,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('is_dark_mode')) {
      context.handle(
        _isDarkModeMeta,
        isDarkMode.isAcceptableOrUnknown(
          data['is_dark_mode']!,
          _isDarkModeMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('monthly_income')) {
      context.handle(
        _monthlyIncomeMeta,
        monthlyIncome.isAcceptableOrUnknown(
          data['monthly_income']!,
          _monthlyIncomeMeta,
        ),
      );
    }
    if (data.containsKey('income_sources')) {
      context.handle(
        _incomeSourcesMeta,
        incomeSources.isAcceptableOrUnknown(
          data['income_sources']!,
          _incomeSourcesMeta,
        ),
      );
    }
    if (data.containsKey('prior_spent_this_month')) {
      context.handle(
        _priorSpentThisMonthMeta,
        priorSpentThisMonth.isAcceptableOrUnknown(
          data['prior_spent_this_month']!,
          _priorSpentThisMonthMeta,
        ),
      );
    }
    if (data.containsKey('initial_savings_balance')) {
      context.handle(
        _initialSavingsBalanceMeta,
        initialSavingsBalance.isAcceptableOrUnknown(
          data['initial_savings_balance']!,
          _initialSavingsBalanceMeta,
        ),
      );
    }
    if (data.containsKey('enable_a_i_chat')) {
      context.handle(
        _enableAIChatMeta,
        enableAIChat.isAcceptableOrUnknown(
          data['enable_a_i_chat']!,
          _enableAIChatMeta,
        ),
      );
    }
    if (data.containsKey('has_completed_onboarding')) {
      context.handle(
        _hasCompletedOnboardingMeta,
        hasCompletedOnboarding.isAcceptableOrUnknown(
          data['has_completed_onboarding']!,
          _hasCompletedOnboardingMeta,
        ),
      );
    }
    if (data.containsKey('has_seen_income_nudge')) {
      context.handle(
        _hasSeenIncomeNudgeMeta,
        hasSeenIncomeNudge.isAcceptableOrUnknown(
          data['has_seen_income_nudge']!,
          _hasSeenIncomeNudgeMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      isDarkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dark_mode'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      monthlyIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_income'],
      )!,
      incomeSources: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_sources'],
      )!,
      priorSpentThisMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prior_spent_this_month'],
      )!,
      initialSavingsBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_savings_balance'],
      )!,
      enableAIChat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_a_i_chat'],
      )!,
      hasCompletedOnboarding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_onboarding'],
      )!,
      hasSeenIncomeNudge: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_seen_income_nudge'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String userName;
  final String currency;
  final bool isDarkMode;
  final String language;
  final double monthlyIncome;
  final String incomeSources;
  final double priorSpentThisMonth;
  final double initialSavingsBalance;
  final bool enableAIChat;
  final bool hasCompletedOnboarding;
  final bool hasSeenIncomeNudge;
  final DateTime updatedAt;
  const Setting({
    required this.id,
    required this.userName,
    required this.currency,
    required this.isDarkMode,
    required this.language,
    required this.monthlyIncome,
    required this.incomeSources,
    required this.priorSpentThisMonth,
    required this.initialSavingsBalance,
    required this.enableAIChat,
    required this.hasCompletedOnboarding,
    required this.hasSeenIncomeNudge,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['currency'] = Variable<String>(currency);
    map['is_dark_mode'] = Variable<bool>(isDarkMode);
    map['language'] = Variable<String>(language);
    map['monthly_income'] = Variable<double>(monthlyIncome);
    map['income_sources'] = Variable<String>(incomeSources);
    map['prior_spent_this_month'] = Variable<double>(priorSpentThisMonth);
    map['initial_savings_balance'] = Variable<double>(initialSavingsBalance);
    map['enable_a_i_chat'] = Variable<bool>(enableAIChat);
    map['has_completed_onboarding'] = Variable<bool>(hasCompletedOnboarding);
    map['has_seen_income_nudge'] = Variable<bool>(hasSeenIncomeNudge);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      userName: Value(userName),
      currency: Value(currency),
      isDarkMode: Value(isDarkMode),
      language: Value(language),
      monthlyIncome: Value(monthlyIncome),
      incomeSources: Value(incomeSources),
      priorSpentThisMonth: Value(priorSpentThisMonth),
      initialSavingsBalance: Value(initialSavingsBalance),
      enableAIChat: Value(enableAIChat),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      hasSeenIncomeNudge: Value(hasSeenIncomeNudge),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      currency: serializer.fromJson<String>(json['currency']),
      isDarkMode: serializer.fromJson<bool>(json['isDarkMode']),
      language: serializer.fromJson<String>(json['language']),
      monthlyIncome: serializer.fromJson<double>(json['monthlyIncome']),
      incomeSources: serializer.fromJson<String>(json['incomeSources']),
      priorSpentThisMonth: serializer.fromJson<double>(
        json['priorSpentThisMonth'],
      ),
      initialSavingsBalance: serializer.fromJson<double>(
        json['initialSavingsBalance'],
      ),
      enableAIChat: serializer.fromJson<bool>(json['enableAIChat']),
      hasCompletedOnboarding: serializer.fromJson<bool>(
        json['hasCompletedOnboarding'],
      ),
      hasSeenIncomeNudge: serializer.fromJson<bool>(json['hasSeenIncomeNudge']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'currency': serializer.toJson<String>(currency),
      'isDarkMode': serializer.toJson<bool>(isDarkMode),
      'language': serializer.toJson<String>(language),
      'monthlyIncome': serializer.toJson<double>(monthlyIncome),
      'incomeSources': serializer.toJson<String>(incomeSources),
      'priorSpentThisMonth': serializer.toJson<double>(priorSpentThisMonth),
      'initialSavingsBalance': serializer.toJson<double>(initialSavingsBalance),
      'enableAIChat': serializer.toJson<bool>(enableAIChat),
      'hasCompletedOnboarding': serializer.toJson<bool>(hasCompletedOnboarding),
      'hasSeenIncomeNudge': serializer.toJson<bool>(hasSeenIncomeNudge),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith({
    int? id,
    String? userName,
    String? currency,
    bool? isDarkMode,
    String? language,
    double? monthlyIncome,
    String? incomeSources,
    double? priorSpentThisMonth,
    double? initialSavingsBalance,
    bool? enableAIChat,
    bool? hasCompletedOnboarding,
    bool? hasSeenIncomeNudge,
    DateTime? updatedAt,
  }) => Setting(
    id: id ?? this.id,
    userName: userName ?? this.userName,
    currency: currency ?? this.currency,
    isDarkMode: isDarkMode ?? this.isDarkMode,
    language: language ?? this.language,
    monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    incomeSources: incomeSources ?? this.incomeSources,
    priorSpentThisMonth: priorSpentThisMonth ?? this.priorSpentThisMonth,
    initialSavingsBalance: initialSavingsBalance ?? this.initialSavingsBalance,
    enableAIChat: enableAIChat ?? this.enableAIChat,
    hasCompletedOnboarding:
        hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    hasSeenIncomeNudge: hasSeenIncomeNudge ?? this.hasSeenIncomeNudge,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      currency: data.currency.present ? data.currency.value : this.currency,
      isDarkMode: data.isDarkMode.present
          ? data.isDarkMode.value
          : this.isDarkMode,
      language: data.language.present ? data.language.value : this.language,
      monthlyIncome: data.monthlyIncome.present
          ? data.monthlyIncome.value
          : this.monthlyIncome,
      incomeSources: data.incomeSources.present
          ? data.incomeSources.value
          : this.incomeSources,
      priorSpentThisMonth: data.priorSpentThisMonth.present
          ? data.priorSpentThisMonth.value
          : this.priorSpentThisMonth,
      initialSavingsBalance: data.initialSavingsBalance.present
          ? data.initialSavingsBalance.value
          : this.initialSavingsBalance,
      enableAIChat: data.enableAIChat.present
          ? data.enableAIChat.value
          : this.enableAIChat,
      hasCompletedOnboarding: data.hasCompletedOnboarding.present
          ? data.hasCompletedOnboarding.value
          : this.hasCompletedOnboarding,
      hasSeenIncomeNudge: data.hasSeenIncomeNudge.present
          ? data.hasSeenIncomeNudge.value
          : this.hasSeenIncomeNudge,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('currency: $currency, ')
          ..write('isDarkMode: $isDarkMode, ')
          ..write('language: $language, ')
          ..write('monthlyIncome: $monthlyIncome, ')
          ..write('incomeSources: $incomeSources, ')
          ..write('priorSpentThisMonth: $priorSpentThisMonth, ')
          ..write('initialSavingsBalance: $initialSavingsBalance, ')
          ..write('enableAIChat: $enableAIChat, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('hasSeenIncomeNudge: $hasSeenIncomeNudge, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userName,
    currency,
    isDarkMode,
    language,
    monthlyIncome,
    incomeSources,
    priorSpentThisMonth,
    initialSavingsBalance,
    enableAIChat,
    hasCompletedOnboarding,
    hasSeenIncomeNudge,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.currency == this.currency &&
          other.isDarkMode == this.isDarkMode &&
          other.language == this.language &&
          other.monthlyIncome == this.monthlyIncome &&
          other.incomeSources == this.incomeSources &&
          other.priorSpentThisMonth == this.priorSpentThisMonth &&
          other.initialSavingsBalance == this.initialSavingsBalance &&
          other.enableAIChat == this.enableAIChat &&
          other.hasCompletedOnboarding == this.hasCompletedOnboarding &&
          other.hasSeenIncomeNudge == this.hasSeenIncomeNudge &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> currency;
  final Value<bool> isDarkMode;
  final Value<String> language;
  final Value<double> monthlyIncome;
  final Value<String> incomeSources;
  final Value<double> priorSpentThisMonth;
  final Value<double> initialSavingsBalance;
  final Value<bool> enableAIChat;
  final Value<bool> hasCompletedOnboarding;
  final Value<bool> hasSeenIncomeNudge;
  final Value<DateTime> updatedAt;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.currency = const Value.absent(),
    this.isDarkMode = const Value.absent(),
    this.language = const Value.absent(),
    this.monthlyIncome = const Value.absent(),
    this.incomeSources = const Value.absent(),
    this.priorSpentThisMonth = const Value.absent(),
    this.initialSavingsBalance = const Value.absent(),
    this.enableAIChat = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    this.hasSeenIncomeNudge = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.currency = const Value.absent(),
    this.isDarkMode = const Value.absent(),
    this.language = const Value.absent(),
    this.monthlyIncome = const Value.absent(),
    this.incomeSources = const Value.absent(),
    this.priorSpentThisMonth = const Value.absent(),
    this.initialSavingsBalance = const Value.absent(),
    this.enableAIChat = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    this.hasSeenIncomeNudge = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? currency,
    Expression<bool>? isDarkMode,
    Expression<String>? language,
    Expression<double>? monthlyIncome,
    Expression<String>? incomeSources,
    Expression<double>? priorSpentThisMonth,
    Expression<double>? initialSavingsBalance,
    Expression<bool>? enableAIChat,
    Expression<bool>? hasCompletedOnboarding,
    Expression<bool>? hasSeenIncomeNudge,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (currency != null) 'currency': currency,
      if (isDarkMode != null) 'is_dark_mode': isDarkMode,
      if (language != null) 'language': language,
      if (monthlyIncome != null) 'monthly_income': monthlyIncome,
      if (incomeSources != null) 'income_sources': incomeSources,
      if (priorSpentThisMonth != null)
        'prior_spent_this_month': priorSpentThisMonth,
      if (initialSavingsBalance != null)
        'initial_savings_balance': initialSavingsBalance,
      if (enableAIChat != null) 'enable_a_i_chat': enableAIChat,
      if (hasCompletedOnboarding != null)
        'has_completed_onboarding': hasCompletedOnboarding,
      if (hasSeenIncomeNudge != null)
        'has_seen_income_nudge': hasSeenIncomeNudge,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? userName,
    Value<String>? currency,
    Value<bool>? isDarkMode,
    Value<String>? language,
    Value<double>? monthlyIncome,
    Value<String>? incomeSources,
    Value<double>? priorSpentThisMonth,
    Value<double>? initialSavingsBalance,
    Value<bool>? enableAIChat,
    Value<bool>? hasCompletedOnboarding,
    Value<bool>? hasSeenIncomeNudge,
    Value<DateTime>? updatedAt,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      currency: currency ?? this.currency,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      incomeSources: incomeSources ?? this.incomeSources,
      priorSpentThisMonth: priorSpentThisMonth ?? this.priorSpentThisMonth,
      initialSavingsBalance:
          initialSavingsBalance ?? this.initialSavingsBalance,
      enableAIChat: enableAIChat ?? this.enableAIChat,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasSeenIncomeNudge: hasSeenIncomeNudge ?? this.hasSeenIncomeNudge,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isDarkMode.present) {
      map['is_dark_mode'] = Variable<bool>(isDarkMode.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (monthlyIncome.present) {
      map['monthly_income'] = Variable<double>(monthlyIncome.value);
    }
    if (incomeSources.present) {
      map['income_sources'] = Variable<String>(incomeSources.value);
    }
    if (priorSpentThisMonth.present) {
      map['prior_spent_this_month'] = Variable<double>(
        priorSpentThisMonth.value,
      );
    }
    if (initialSavingsBalance.present) {
      map['initial_savings_balance'] = Variable<double>(
        initialSavingsBalance.value,
      );
    }
    if (enableAIChat.present) {
      map['enable_a_i_chat'] = Variable<bool>(enableAIChat.value);
    }
    if (hasCompletedOnboarding.present) {
      map['has_completed_onboarding'] = Variable<bool>(
        hasCompletedOnboarding.value,
      );
    }
    if (hasSeenIncomeNudge.present) {
      map['has_seen_income_nudge'] = Variable<bool>(hasSeenIncomeNudge.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('currency: $currency, ')
          ..write('isDarkMode: $isDarkMode, ')
          ..write('language: $language, ')
          ..write('monthlyIncome: $monthlyIncome, ')
          ..write('incomeSources: $incomeSources, ')
          ..write('priorSpentThisMonth: $priorSpentThisMonth, ')
          ..write('initialSavingsBalance: $initialSavingsBalance, ')
          ..write('enableAIChat: $enableAIChat, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('hasSeenIncomeNudge: $hasSeenIncomeNudge, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, role, content, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final String role;
  final String content;
  final DateTime timestamp;
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
    );
  }

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ChatMessage copyWith({
    int? id,
    String? role,
    String? content,
    DateTime? timestamp,
  }) => ChatMessage(
    id: id ?? this.id,
    role: role ?? this.role,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
  );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, content, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String role,
    required String content,
    this.timestamp = const Value.absent(),
  }) : role = Value(role),
       content = Value(content);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? timestamp,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $PurchaseGoalsTable purchaseGoals = $PurchaseGoalsTable(this);
  late final $InsightsCacheTable insightsCache = $InsightsCacheTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    budgets,
    purchaseGoals,
    insightsCache,
    settings,
    chatMessages,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required TransactionType type,
      required double amount,
      required TransactionCategory category,
      Value<bool> isNeed,
      Value<String> note,
      required DateTime date,
      Value<DateTime> createdAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<TransactionType> type,
      Value<double> amount,
      Value<TransactionCategory> category,
      Value<bool> isNeed,
      Value<String> note,
      Value<DateTime> date,
      Value<DateTime> createdAt,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    TransactionCategory,
    TransactionCategory,
    String
  >
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isNeed => $composableBuilder(
    column: $table.isNeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNeed => $composableBuilder(
    column: $table.isNeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isNeed =>
      $composableBuilder(column: $table.isNeed, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<TransactionCategory> category = const Value.absent(),
                Value<bool> isNeed = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                amount: amount,
                category: category,
                isNeed: isNeed,
                note: note,
                date: date,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TransactionType type,
                required double amount,
                required TransactionCategory category,
                Value<bool> isNeed = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime date,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                category: category,
                isNeed: isNeed,
                note: note,
                date: date,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<double> dailyLimit,
      Value<double> savingsGoalPercent,
      Value<String> categoryBudgets,
      Value<DateTime> updatedAt,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<double> dailyLimit,
      Value<double> savingsGoalPercent,
      Value<String> categoryBudgets,
      Value<DateTime> updatedAt,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyLimit => $composableBuilder(
    column: $table.dailyLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savingsGoalPercent => $composableBuilder(
    column: $table.savingsGoalPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryBudgets => $composableBuilder(
    column: $table.categoryBudgets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyLimit => $composableBuilder(
    column: $table.dailyLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savingsGoalPercent => $composableBuilder(
    column: $table.savingsGoalPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryBudgets => $composableBuilder(
    column: $table.categoryBudgets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get dailyLimit => $composableBuilder(
    column: $table.dailyLimit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get savingsGoalPercent => $composableBuilder(
    column: $table.savingsGoalPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryBudgets => $composableBuilder(
    column: $table.categoryBudgets,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> dailyLimit = const Value.absent(),
                Value<double> savingsGoalPercent = const Value.absent(),
                Value<String> categoryBudgets = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                dailyLimit: dailyLimit,
                savingsGoalPercent: savingsGoalPercent,
                categoryBudgets: categoryBudgets,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> dailyLimit = const Value.absent(),
                Value<double> savingsGoalPercent = const Value.absent(),
                Value<String> categoryBudgets = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                dailyLimit: dailyLimit,
                savingsGoalPercent: savingsGoalPercent,
                categoryBudgets: categoryBudgets,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$PurchaseGoalsTableCreateCompanionBuilder =
    PurchaseGoalsCompanion Function({
      Value<int> id,
      required String name,
      required double targetPrice,
      Value<double> savedAmount,
      Value<DateTime?> targetDate,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PurchaseGoalsTableUpdateCompanionBuilder =
    PurchaseGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> targetPrice,
      Value<double> savedAmount,
      Value<DateTime?> targetDate,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PurchaseGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseGoalsTable> {
  $$PurchaseGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseGoalsTable> {
  $$PurchaseGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseGoalsTable> {
  $$PurchaseGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PurchaseGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseGoalsTable,
          PurchaseGoal,
          $$PurchaseGoalsTableFilterComposer,
          $$PurchaseGoalsTableOrderingComposer,
          $$PurchaseGoalsTableAnnotationComposer,
          $$PurchaseGoalsTableCreateCompanionBuilder,
          $$PurchaseGoalsTableUpdateCompanionBuilder,
          (
            PurchaseGoal,
            BaseReferences<_$AppDatabase, $PurchaseGoalsTable, PurchaseGoal>,
          ),
          PurchaseGoal,
          PrefetchHooks Function()
        > {
  $$PurchaseGoalsTableTableManager(_$AppDatabase db, $PurchaseGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> targetPrice = const Value.absent(),
                Value<double> savedAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PurchaseGoalsCompanion(
                id: id,
                name: name,
                targetPrice: targetPrice,
                savedAmount: savedAmount,
                targetDate: targetDate,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double targetPrice,
                Value<double> savedAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PurchaseGoalsCompanion.insert(
                id: id,
                name: name,
                targetPrice: targetPrice,
                savedAmount: savedAmount,
                targetDate: targetDate,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseGoalsTable,
      PurchaseGoal,
      $$PurchaseGoalsTableFilterComposer,
      $$PurchaseGoalsTableOrderingComposer,
      $$PurchaseGoalsTableAnnotationComposer,
      $$PurchaseGoalsTableCreateCompanionBuilder,
      $$PurchaseGoalsTableUpdateCompanionBuilder,
      (
        PurchaseGoal,
        BaseReferences<_$AppDatabase, $PurchaseGoalsTable, PurchaseGoal>,
      ),
      PurchaseGoal,
      PrefetchHooks Function()
    >;
typedef $$InsightsCacheTableCreateCompanionBuilder =
    InsightsCacheCompanion Function({
      Value<int> id,
      required String insightType,
      required String title,
      required String description,
      required String severity,
      required String dataSource,
      Value<DateTime> generatedAt,
      Value<bool> isDismissed,
    });
typedef $$InsightsCacheTableUpdateCompanionBuilder =
    InsightsCacheCompanion Function({
      Value<int> id,
      Value<String> insightType,
      Value<String> title,
      Value<String> description,
      Value<String> severity,
      Value<String> dataSource,
      Value<DateTime> generatedAt,
      Value<bool> isDismissed,
    });

class $$InsightsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $InsightsCacheTable> {
  $$InsightsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataSource => $composableBuilder(
    column: $table.dataSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsightsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $InsightsCacheTable> {
  $$InsightsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataSource => $composableBuilder(
    column: $table.dataSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsightsCacheTable> {
  $$InsightsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get dataSource => $composableBuilder(
    column: $table.dataSource,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );
}

class $$InsightsCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsightsCacheTable,
          InsightsCacheData,
          $$InsightsCacheTableFilterComposer,
          $$InsightsCacheTableOrderingComposer,
          $$InsightsCacheTableAnnotationComposer,
          $$InsightsCacheTableCreateCompanionBuilder,
          $$InsightsCacheTableUpdateCompanionBuilder,
          (
            InsightsCacheData,
            BaseReferences<
              _$AppDatabase,
              $InsightsCacheTable,
              InsightsCacheData
            >,
          ),
          InsightsCacheData,
          PrefetchHooks Function()
        > {
  $$InsightsCacheTableTableManager(_$AppDatabase db, $InsightsCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> insightType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> dataSource = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
              }) => InsightsCacheCompanion(
                id: id,
                insightType: insightType,
                title: title,
                description: description,
                severity: severity,
                dataSource: dataSource,
                generatedAt: generatedAt,
                isDismissed: isDismissed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String insightType,
                required String title,
                required String description,
                required String severity,
                required String dataSource,
                Value<DateTime> generatedAt = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
              }) => InsightsCacheCompanion.insert(
                id: id,
                insightType: insightType,
                title: title,
                description: description,
                severity: severity,
                dataSource: dataSource,
                generatedAt: generatedAt,
                isDismissed: isDismissed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsightsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsightsCacheTable,
      InsightsCacheData,
      $$InsightsCacheTableFilterComposer,
      $$InsightsCacheTableOrderingComposer,
      $$InsightsCacheTableAnnotationComposer,
      $$InsightsCacheTableCreateCompanionBuilder,
      $$InsightsCacheTableUpdateCompanionBuilder,
      (
        InsightsCacheData,
        BaseReferences<_$AppDatabase, $InsightsCacheTable, InsightsCacheData>,
      ),
      InsightsCacheData,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> currency,
      Value<bool> isDarkMode,
      Value<String> language,
      Value<double> monthlyIncome,
      Value<String> incomeSources,
      Value<double> priorSpentThisMonth,
      Value<double> initialSavingsBalance,
      Value<bool> enableAIChat,
      Value<bool> hasCompletedOnboarding,
      Value<bool> hasSeenIncomeNudge,
      Value<DateTime> updatedAt,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> currency,
      Value<bool> isDarkMode,
      Value<String> language,
      Value<double> monthlyIncome,
      Value<String> incomeSources,
      Value<double> priorSpentThisMonth,
      Value<double> initialSavingsBalance,
      Value<bool> enableAIChat,
      Value<bool> hasCompletedOnboarding,
      Value<bool> hasSeenIncomeNudge,
      Value<DateTime> updatedAt,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDarkMode => $composableBuilder(
    column: $table.isDarkMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incomeSources => $composableBuilder(
    column: $table.incomeSources,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priorSpentThisMonth => $composableBuilder(
    column: $table.priorSpentThisMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialSavingsBalance => $composableBuilder(
    column: $table.initialSavingsBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableAIChat => $composableBuilder(
    column: $table.enableAIChat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSeenIncomeNudge => $composableBuilder(
    column: $table.hasSeenIncomeNudge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDarkMode => $composableBuilder(
    column: $table.isDarkMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeSources => $composableBuilder(
    column: $table.incomeSources,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priorSpentThisMonth => $composableBuilder(
    column: $table.priorSpentThisMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialSavingsBalance => $composableBuilder(
    column: $table.initialSavingsBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableAIChat => $composableBuilder(
    column: $table.enableAIChat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSeenIncomeNudge => $composableBuilder(
    column: $table.hasSeenIncomeNudge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isDarkMode => $composableBuilder(
    column: $table.isDarkMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<double> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get incomeSources => $composableBuilder(
    column: $table.incomeSources,
    builder: (column) => column,
  );

  GeneratedColumn<double> get priorSpentThisMonth => $composableBuilder(
    column: $table.priorSpentThisMonth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialSavingsBalance => $composableBuilder(
    column: $table.initialSavingsBalance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableAIChat => $composableBuilder(
    column: $table.enableAIChat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSeenIncomeNudge => $composableBuilder(
    column: $table.hasSeenIncomeNudge,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isDarkMode = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<double> monthlyIncome = const Value.absent(),
                Value<String> incomeSources = const Value.absent(),
                Value<double> priorSpentThisMonth = const Value.absent(),
                Value<double> initialSavingsBalance = const Value.absent(),
                Value<bool> enableAIChat = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                Value<bool> hasSeenIncomeNudge = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                userName: userName,
                currency: currency,
                isDarkMode: isDarkMode,
                language: language,
                monthlyIncome: monthlyIncome,
                incomeSources: incomeSources,
                priorSpentThisMonth: priorSpentThisMonth,
                initialSavingsBalance: initialSavingsBalance,
                enableAIChat: enableAIChat,
                hasCompletedOnboarding: hasCompletedOnboarding,
                hasSeenIncomeNudge: hasSeenIncomeNudge,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isDarkMode = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<double> monthlyIncome = const Value.absent(),
                Value<String> incomeSources = const Value.absent(),
                Value<double> priorSpentThisMonth = const Value.absent(),
                Value<double> initialSavingsBalance = const Value.absent(),
                Value<bool> enableAIChat = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                Value<bool> hasSeenIncomeNudge = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                userName: userName,
                currency: currency,
                isDarkMode: isDarkMode,
                language: language,
                monthlyIncome: monthlyIncome,
                incomeSources: incomeSources,
                priorSpentThisMonth: priorSpentThisMonth,
                initialSavingsBalance: initialSavingsBalance,
                enableAIChat: enableAIChat,
                hasCompletedOnboarding: hasCompletedOnboarding,
                hasSeenIncomeNudge: hasSeenIncomeNudge,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      required String role,
      required String content,
      Value<DateTime> timestamp,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      Value<String> role,
      Value<String> content,
      Value<DateTime> timestamp,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessage,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessage,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
          ),
          ChatMessage,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String role,
                required String content,
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessage,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessage,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
      ),
      ChatMessage,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$PurchaseGoalsTableTableManager get purchaseGoals =>
      $$PurchaseGoalsTableTableManager(_db, _db.purchaseGoals);
  $$InsightsCacheTableTableManager get insightsCache =>
      $$InsightsCacheTableTableManager(_db, _db.insightsCache);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
}
