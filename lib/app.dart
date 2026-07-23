import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

class StackRushNeonApp extends StatelessWidget {
  const StackRushNeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stack Rush Neon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
