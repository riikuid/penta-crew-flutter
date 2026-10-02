import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/state_views.dart';
import '../../models/sample_item.dart';
import '../../sample_routes.dart';
import '../cubit/sample_list_cubit.dart';
import '../cubit/sample_list_state.dart';

/// Paginated list with search (debounced), pull-to-refresh and infinite scroll.
class SampleListScreen extends StatefulWidget {
  const SampleListScreen({super.key});

  @override
  State<SampleListScreen> createState() => _SampleListScreenState();
}

class _SampleListScreenState extends State<SampleListScreen> {
  static const _debounce = Duration(milliseconds: 400);
  static const _loadMoreThreshold = 300.0;

  final _search = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounceTimer;

  SampleListCubit get _cubit => context.read<SampleListCubit>();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    // Rebuild for the clear button only.
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.extentAfter < _loadMoreThreshold) _cubit.loadMore();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => _submitSearch(value));
  }

  void _submitSearch(String value) {
    _debounceTimer?.cancel();
    _cubit.fetch(search: value);
  }

  void _clearSearch() {
    _search.clear();
    _submitSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _search,
          textInputAction: TextInputAction.search,
          onChanged: _onSearchChanged,
          onSubmitted: _submitSearch,
          decoration: InputDecoration(
            hintText: 'Cari...',
            border: InputBorder.none,
            suffixIcon: _search.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus',
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
      ),
      body: BlocConsumer<SampleListCubit, SampleListState>(
        // Error while data is on screen → toast only, list stays.
        listenWhen: (_, next) => next is SampleListError && next.data.isNotEmpty,
        listener: (_, state) => AppToast.error((state as SampleListError).message),
        // That same transient error is restored to `loaded` right after,
        // so skip rebuilding for it.
        buildWhen: (_, next) => next is! SampleListError || next.data.isEmpty,
        builder: (context, state) => switch (state) {
          SampleListInitial() || SampleListLoading() => const LoadingView(),
          SampleListError(:final message) => ErrorView(
            message: message,
            onRetry: _cubit.retry,
          ),
          SampleListLoaded(:final data) when data.isEmpty => _Refreshable(
            onRefresh: _cubit.refresh,
            child: const EmptyView(message: 'Nothing here yet.'),
          ),
          SampleListLoaded(:final data, :final isLoadingMore) => RefreshIndicator(
            onRefresh: _cubit.refresh,
            child: ListView.builder(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= data.length) return const _LoadingMoreRow();
                final item = data[index];
                return _SampleTile(
                  item: item,
                  onTap: () => context.push(SampleRoutes.detail(item.id)),
                );
              },
            ),
          ),
        },
      ),
    );
  }
}

class _SampleTile extends StatelessWidget {
  const _SampleTile({required this.item, required this.onTap});

  final SampleItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: item.description == null
          ? null
          : Text(item.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: item.category == null
          ? null
          : Chip(
              label: Text(item.category!.name),
              visualDensity: VisualDensity.compact,
            ),
      onTap: onTap,
    );
  }
}

class _LoadingMoreRow extends StatelessWidget {
  const _LoadingMoreRow();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(child: CircularProgressIndicator.adaptive()),
  );
}

/// Makes a non-scrollable child (empty view) pull-to-refreshable.
class _Refreshable extends StatelessWidget {
  const _Refreshable({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: constraints.maxHeight, child: child),
        ),
      ),
    );
  }
}
