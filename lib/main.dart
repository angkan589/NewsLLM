import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_theme.dart';
import 'package:newsllm/features/home/presentation/pages/home_page.dart';
import 'package:newsllm/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppSession.instance.initializeAuthentication();

  runApp(const NewsLLMApp());
}

class NewsLLMApp extends StatelessWidget {
  const NewsLLMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'NewsLLM',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppSession.instance.themeMode,
          builder: (context, child) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                NavigationVisibilityController.instance
                    .handleScrollNotification(notification);
                return false;
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const HomePage(),
        );
      },
    );
  }
}
