import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/planets_provider.dart';
import '../widgets/planet_card.dart';

class PlanetsListScreen extends ConsumerStatefulWidget {
  const PlanetsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlanetsListScreen> createState() => _PlanetsListScreenState();
}

class _PlanetsListScreenState extends ConsumerState<PlanetsListScreen> {
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
      ref.read(planetsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final planetsAsync = ref.watch(filteredPlanetsProvider);
    final searchQuery = ref.watch(planetsSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(planetsProvider.notifier).refresh(),
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
                hintText: 'Search planets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(planetsSearchQueryProvider.notifier).state =
                              '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(planetsSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: planetsAsync.when(
              data: (planets) {
                if (planets.isEmpty) {
                  return EmptyStateWidget(
                    message: searchQuery.isEmpty
                        ? 'No planets found'
                        : 'No results for "$searchQuery"',
                    icon: Icons.public_off_outlined,
                    onAction: searchQuery.isNotEmpty
                        ? () {
                            _searchController.clear();
                            ref
                                    .read(planetsSearchQueryProvider.notifier)
                                    .state =
                                '';
                          }
                        : null,
                    actionLabel: 'Clear Search',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(planetsProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: planets.length + 1,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      if (index == planets.length) {
                        return ref.watch(planetsProvider.notifier).hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink();
                      }
                      return PlanetCard(planet: planets[index]);
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(message: 'Loading planets...'),
              error: (error, stack) => ErrorDisplayWidget(
                message: error.toString(),
                onRetry: () => ref.read(planetsProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
