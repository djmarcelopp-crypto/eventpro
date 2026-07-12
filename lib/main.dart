import 'package:flutter/material.dart';

import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const EventProApp());
}

class EventProApp extends StatelessWidget {
  const EventProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EventPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
