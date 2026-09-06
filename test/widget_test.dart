import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:penny/main.dart';

void main() {
  testWidgets('Penny app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PennyApp()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
