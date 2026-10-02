import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../sample/sample_routes.dart';

/// Landing page after login. Replace with the real shell (bottom nav, etc.).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthCubit c) => switch (c.state) {
        Authenticated(:final user) => user,
        _ => null,
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hello, ${user?.name ?? '-'}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (user?.email != null) Text(user!.email!),
          const SizedBox(height: 24),
          // Feature entry points go here.
          Card(
            child: ListTile(
              leading: const Icon(Icons.list_alt_outlined),
              title: const Text('Sample'),
              subtitle: const Text('Feature template: paginated list + detail'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(SampleRoutes.list),
            ),
          ),
        ],
      ),
    );
  }
}
