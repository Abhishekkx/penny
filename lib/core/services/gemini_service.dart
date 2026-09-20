import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/database.dart';

class GeminiService {
  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const List<String> _modelHierarchy = [
    'gemini-3.6-flash',
    'gemini-2.5-flash',
    'gemini-1.5-flash',
  ];

  static Future<String> generateResponse({
    required String userPrompt,
    required List<ChatMessage> history,
    String? financialContextCsv,
  }) async {
    final contents = <Map<String, dynamic>>[];

    final systemContext =
        '''You are "Pocket", an ultra-intelligent, friendly, and crystal-clear AI financial advisor inside the Pennora financial app.
Below is the user's complete real-time financial database context:

${financialContextCsv ?? 'No financial database context available.'}

STRICT ADVISOR & FORMATTING RULES:
- You HAVE ACCESS to the user's live financial data above. Use it to give direct, exact numerical answers to their questions (e.g. Need vs Want ratio, spending breakdowns, daily limit pacing, savings targets).
- If the user's records or income are 0 / empty, inform them nicely: "You haven't logged any financial records or income yet! Enter your income or expenses in Pennora to get customized answers, or feel free to ask me general personal finance questions."
- DO NOT use markdown asterisks (*) or double asterisks (**) anywhere in your response.
- Present answers in clean, visually distinct bullet points using (• ) or numbered lists (1., 2., 3.).
- Be direct, structured, to-the-point, and explain clearly without repetitive fluff.''';

    contents.add({
      'role': 'user',
      'parts': [
        {'text': systemContext},
      ],
    });

    final priorHistory = history.where(
      (m) =>
          m != history.lastOrNull ||
          m.role != 'user' ||
          m.content != userPrompt,
    );
    for (final msg in priorHistory) {
      contents.add({
        'role': msg.role == 'user' ? 'user' : 'model',
        'parts': [
          {'text': cleanResponseText(msg.content)},
        ],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': userPrompt},
      ],
    });

    final body = jsonEncode({
      'contents': contents,
      'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 1024},
    });

    for (final model in _modelHierarchy) {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
      );
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final rawText = parts[0]['text'] as String;
              return cleanResponseText(rawText);
            }
          }
        }
      } catch (_) {}
    }

    return 'Could not generate AI response. Please check your internet connection and API key.';
  }

  static String cleanResponseText(String text) {
    return text
        .replaceAll('***', '')
        .replaceAll('**', '')
        .replaceAll('* ', '• ')
        .replaceAll('*', '')
        .trim();
  }
}
