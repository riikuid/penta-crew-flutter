import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_messages.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/state_views.dart';

class ForbiddenScreen extends StatelessWidget {
  const ForbiddenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access denied')),
      body: ErrorView(
        message: AppMessages.forbidden,
        retryLabel: 'Go home',
        onRetry: () => context.go(AppRoutes.home),
      ),
    );
  }
}
