import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsllm/main.dart';

void main() {
  testWidgets('NewsLLM app loads successfully', (tester) async {
    await tester.pumpWidget(const NewsLLMApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(
      find.text('Good morning. Here’s what matters today.'),
      findsOneWidget,
    );
  });
}
