import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_theme.dart';

void main() {
  runApp(const NewsLLMApp());
}

class NewsLLMApp extends StatelessWidget {
  const NewsLLMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsLLM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('NewsLLM'),
        ),
      ),
    );
  }
}