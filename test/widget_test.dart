import 'package:flutter_test/flutter_test.dart';
import 'package:newsllm/main.dart';

void main() {
  testWidgets('NewsLLM app loads successfully', (tester) async {
    await tester.pumpWidget(const NewsLLMApp());

    expect(find.text('NewsLLM'), findsOneWidget);
  });
}