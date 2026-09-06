import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/pressable_scale.dart';

class TalkToPocketScreen extends ConsumerStatefulWidget {
  const TalkToPocketScreen({super.key});

  @override
  ConsumerState<TalkToPocketScreen> createState() => _TalkToPocketScreenState();
}

class _TalkToPocketScreenState extends ConsumerState<TalkToPocketScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  static const List<String> _suggestedQuestions = [
    'How much did I spend this week?',
    'Where can I cut down expenses?',
    'Am I on track with my daily budget?',
    'What is my Need vs Want ratio?',
    'How to reach my savings goals faster?',
  ];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final db = ref.read(databaseProvider);
    final history = await db.getChatHistory();
    if (history.isNotEmpty) {
      setState(() {
        _messages = List<ChatMessage>.from(history);
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String queryText) async {
    final text = queryText.trim();
    if (text.isEmpty || _isLoading) return;

    _textController.clear();
    HapticFeedback.lightImpact();

    final db = ref.read(databaseProvider);
    final userMsgId = await db.insertChatMessage(
      ChatMessagesCompanion.insert(role: 'user', content: text),
    );

    final userMsg = ChatMessage(
      id: userMsgId,
      role: 'user',
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
    });
    _scrollToBottom();

    final transactions = ref.read(transactionsProvider).value ?? [];
    final settings = ref.read(settingsProvider).value;
    final budget = ref.read(budgetProvider).value;
    final goals = ref.read(purchaseGoalsProvider).value ?? [];

    final currency = settings?.currency ?? 'INR';
    final symbol = CurrencyHelper.getSymbol(currency);
    final income = settings?.monthlyIncome ?? 0;
    final name = settings?.userName ?? 'User';
    final rawCsv = CsvExporter.generateTransactionsCsv(transactions, symbol);

    double totalNeeds = 0;
    double totalWants = 0;
    double totalExpenses = 0;

    for (final tx in transactions) {
      if (tx.type == TransactionType.expense) {
        totalExpenses += tx.amount;
        if (tx.isNeed) {
          totalNeeds += tx.amount;
        } else {
          totalWants += tx.amount;
        }
      }
    }

    final needPercent = totalExpenses > 0
        ? ((totalNeeds / totalExpenses) * 100).toStringAsFixed(1)
        : '0';
    final wantPercent = totalExpenses > 0
        ? ((totalWants / totalExpenses) * 100).toStringAsFixed(1)
        : '0';

    final goalsSummary = goals
        .map(
          (g) =>
              '- ${g.name}: Saved $symbol${g.savedAmount.toStringAsFixed(0)} / Target $symbol${g.targetPrice.toStringAsFixed(0)}',
        )
        .join('\n');

    final financialContext =
        '''
USER PROFILE:
- Name: $name
- Currency: $currency ($symbol)
- Monthly Income: $symbol${income.toStringAsFixed(0)}

BUDGET & SAVINGS TARGETS:
- Daily Expense Limit: $symbol${budget?.dailyLimit.toStringAsFixed(0) ?? '0'}/day
- Target Monthly Savings Rate: ${budget?.savingsGoalPercent.toStringAsFixed(0) ?? '20'}%

REAL-TIME NEED VS WANT RATIO:
- Total Expenses: $symbol${totalExpenses.toStringAsFixed(0)}
- Essential Needs: $symbol${totalNeeds.toStringAsFixed(0)} ($needPercent% of expenses)
- Discretionary Wants: $symbol${totalWants.toStringAsFixed(0)} ($wantPercent% of expenses)

PURCHASE & SAVINGS GOALS:
${goalsSummary.isEmpty ? 'No active goals set yet.' : goalsSummary}

TRANSACTION DATABASE RECORDS (CSV):
${rawCsv.trim().isEmpty ? 'No transactions logged yet.' : rawCsv}''';

    try {
      final responseText = await GeminiService.generateResponse(
        userPrompt: text,
        history: _messages,
        financialContextCsv: financialContext,
      );

      final modelMsgId = await db.insertChatMessage(
        ChatMessagesCompanion.insert(role: 'model', content: responseText),
      );

      final modelMsg = ChatMessage(
        id: modelMsgId,
        role: 'model',
        content: responseText,
        timestamp: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _messages.add(modelMsg);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        final errText =
            'Sorry, I ran into an error connecting to Gemini. Please try again.';
        final errMsgId = await db.insertChatMessage(
          ChatMessagesCompanion.insert(role: 'model', content: errText),
        );
        setState(() {
          _messages.add(
            ChatMessage(
              id: errMsgId,
              role: 'model',
              content: errText,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryCardGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.ambientGlow(
                          color: AppColors.primaryEmerald,
                          opacity: 0.3,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Talk to your Pocket',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
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
                                  'Gemini AI',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryEmerald,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'All data stored locally on your device',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_messages.isNotEmpty)
                      IconButton(
                        tooltip: 'Clear Chat History',
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Clear Chat History?'),
                              content: const Text(
                                'This will delete all saved chat messages from your device.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                  ),
                                  child: const Text('Clear'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final db = ref.read(databaseProvider);
                            await db.clearChatHistory();
                            setState(() {
                              _messages.clear();
                            });
                          }
                        },
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: _messages.isEmpty
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(AppTheme.spaceLg),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryEmerald.withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 40,
                                color: AppColors.primaryEmerald,
                              ),
                            ).animate().scale(duration: 400.ms),
                            const SizedBox(height: 16),
                            Text(
                              'Ask Pocket Anything',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pocket analyzes your offline transactions and budget in real-time to give personalized financial advice.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 24),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Suggested Questions',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 10,
                              children: _suggestedQuestions.map((question) {
                                return PressableScale(
                                  onTap: () => _sendMessage(question),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurface.withValues(
                                              alpha: 0.6,
                                            )
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        AppTheme.radiusLg,
                                      ),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.1,
                                              )
                                            : AppColors.cardBorder,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: AppColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          question,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : AppColors.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppTheme.spaceLg),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isUser = msg.role == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.82,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: isUser
                                    ? AppColors.primaryButtonGradient
                                    : null,
                                color: isUser
                                    ? null
                                    : (isDark
                                          ? AppColors.darkSurface.withValues(
                                              alpha: 0.8,
                                            )
                                          : Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(
                                    AppTheme.radiusLg,
                                  ),
                                  topRight: const Radius.circular(
                                    AppTheme.radiusLg,
                                  ),
                                  bottomLeft: Radius.circular(
                                    isUser ? AppTheme.radiusLg : 4,
                                  ),
                                  bottomRight: Radius.circular(
                                    isUser ? 4 : AppTheme.radiusLg,
                                  ),
                                ),
                                border: isUser
                                    ? null
                                    : Border.all(
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.1,
                                              )
                                            : AppColors.cardBorder,
                                      ),
                                boxShadow: isUser
                                    ? AppTheme.ambientGlow(
                                        color: AppColors.primaryEmerald,
                                        opacity: 0.2,
                                      )
                                    : null,
                              ),
                              child: _buildMessageContent(
                                msg.content,
                                isUser,
                                isDark,
                              ),
                            ),
                          );
                        },
                      ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: _AnalysisLoaderWidget(),
                ),

              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_messages.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: _suggestedQuestions.map((q) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                                bottom: 8,
                              ),
                              child: GestureDetector(
                                onTap: () => _sendMessage(q),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryEmerald.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusFull,
                                    ),
                                    border: Border.all(
                                      color: AppColors.primaryEmerald
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        q,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryEmerald,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: _sendMessage,
                            decoration: InputDecoration(
                              hintText: 'Ask Pocket about your money...',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusFull,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.darkSurfaceHigh
                                  : AppColors.gray100,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PressableScale(
                          onTap: () => _sendMessage(_textController.text),
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
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(String rawText, bool isUser, bool isDark) {
    final text = GeminiService.cleanResponseText(rawText);
    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : AppColors.onSurface);

    if (isUser) {
      return Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      );
    }

    final lines = text.split('\n');
    final children = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        children.add(const SizedBox(height: 8));
        continue;
      }

      if (line.startsWith('•') || line.startsWith('-')) {
        final content = line.replaceFirst(RegExp(r'^[•\-]\s*'), '');
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryEmerald,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: GoogleFonts.plusJakartaSans(
                      color: textColor,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              line,
              style: GoogleFonts.plusJakartaSans(
                color: textColor,
                fontSize: 14,
                height: 1.45,
                fontWeight: (i == 0 || line.endsWith(':'))
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _AnalysisLoaderWidget extends StatefulWidget {
  const _AnalysisLoaderWidget();

  @override
  State<_AnalysisLoaderWidget> createState() => _AnalysisLoaderWidgetState();
}

class _AnalysisLoaderWidgetState extends State<_AnalysisLoaderWidget> {
  int _currentStep = 0;
  Timer? _timer;

  static const List<String> _steps = [
    'Reading your financial data...',
    'Checking income & expenses...',
    'Analyzing category breakdowns...',
    'Formulating AI recommendations...',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1100), (timer) {
      if (mounted) {
        setState(() {
          _currentStep = (_currentStep + 1) % _steps.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColors.primaryEmerald,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _steps[_currentStep],
                key: ValueKey(_steps[_currentStep]),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryEmerald,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(0.92, 0.92));
  }
}
