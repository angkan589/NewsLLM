import 'package:flutter/material.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/core/theme/app_theme.dart';
import 'package:newsllm/features/home/presentation/pages/home_page.dart';

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
      builder: (context, child) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            NavigationVisibilityController.instance.handleScrollNotification(
              notification,
            );

            return false;
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomePage(),
    );
  }
}
