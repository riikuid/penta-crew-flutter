import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/state_views.dart';
import '../../models/sample_item.dart';
import '../cubit/sample_detail_cubit.dart';
import '../cubit/sample_detail_state.dart';

class SampleDetailScreen extends StatelessWidget {
  const SampleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocSelector<SampleDetailCubit, SampleDetailState, String>(
          selector: (state) => switch (state) {
            SampleDetailLoaded(:final item) => item.title,
            _ => 'Detail',
          },
          builder: (context, title) => Text(title),
        ),
      ),
      body: BlocBuilder<SampleDetailCubit, SampleDetailState>(
        builder: (context, state) => switch (state) {
          SampleDetailInitial() || SampleDetailLoading() => const LoadingView(),
          SampleDetailError(:final message) => ErrorView(
            message: message,
            onRetry: context.read<SampleDetailCubit>().retry,
          ),
          SampleDetailLoaded(:final item) => _Body(item: item),
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.item});

  final SampleItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(item.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (item.category case final category?)
              Chip(label: Text(category.name), visualDensity: VisualDensity.compact),
            if (item.createdAt case final createdAt?)
              Text(
                DateFormat('d MMM yyyy, HH:mm').format(createdAt.toLocal()),
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(item.description ?? '-', style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
