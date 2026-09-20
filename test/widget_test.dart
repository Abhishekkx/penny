import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pennora/main.dart';

void main() {
  testWidgets('Pennora app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PennoraApp()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
