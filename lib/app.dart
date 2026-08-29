import 'package:flutter/material.dart';

import 'core/design/app_theme.dart';
import 'core/navigation/app_router.dart';

class MilqoApp extends StatelessWidget {
  const MilqoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Milqo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}
