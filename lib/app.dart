import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_page.dart';

class CoupleFitApp extends StatelessWidget {
  const CoupleFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoupleFit',
      theme: AppTheme.lightTheme,
      home: const DashboardPage(),
    );
  }
}
