import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/starships_provider.dart';
import '../widgets/starship_card.dart';

class StarshipsListScreen extends ConsumerStatefulWidget {
  const StarshipsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StarshipsListScreen> createState() =>
      _StarshipsListScreenState();
}

class _StarshipsListScreenState extends ConsumerState<StarshipsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(starshipsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final starshipsAsync = ref.watch(filteredStarshipsProvider);
    final searchQuery = ref.watch(starshipsSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Starships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(starshipsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search starships...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                                  .read(starshipsSearchQueryProvider.notifier)
                                  .state =
                              '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(starshipsSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: starshipsAsync.when(
              data: (starships) {
                if (starships.isEmpty) {
                  return EmptyStateWidget(
                    message: searchQuery.isEmpty
                        ? 'No starships found'
                        : 'No results for "$searchQuery"',
                    icon: Icons.rocket_launch_outlined,
                    onAction: searchQuery.isNotEmpty
                        ? () {
                            _searchController.clear();
                            ref
                                    .read(starshipsSearchQueryProvider.notifier)
                                    .state =
                                '';
                          }
                        : null,
                    actionLabel: 'Clear Search',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(starshipsProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: starships.length + 1,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      if (index == starships.length) {
                        return ref.watch(starshipsProvider.notifier).hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink();
                      }
                      return StarshipCard(starship: starships[index]);
                    },
                  ),
                );
              },
              loading: () =>
                  const LoadingWidget(message: 'Loading starships...'),
              error: (error, stack) => ErrorDisplayWidget(
                message: error.toString(),
                onRetry: () => ref.read(starshipsProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
