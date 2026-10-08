import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/constants/app_strings.dart';
import '../features/onboarding/splash.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      home: const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
