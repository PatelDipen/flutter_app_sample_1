import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/people_provider.dart';
import '../widgets/person_card.dart';

class PeopleListScreen extends ConsumerStatefulWidget {
  const PeopleListScreen({super.key});

  @override
  ConsumerState<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends ConsumerState<PeopleListScreen> {
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
      ref.read(peopleProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final peopleAsync = ref.watch(filteredPeopleProvider);
    final searchQuery = ref.watch(peopleSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(peopleProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search people...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(peopleSearchQueryProvider.notifier).state =
                              '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(peopleSearchQueryProvider.notifier).state = value;
              },
            ),
          ),

          // People list
          Expanded(
            child: peopleAsync.when(
              data: (people) {
                if (people.isEmpty) {
                  return EmptyStateWidget(
                    message: searchQuery.isEmpty
                        ? 'No people found'
                        : 'No results for "$searchQuery"',
                    icon: Icons.person_off_outlined,
                    onAction: searchQuery.isNotEmpty
                        ? () {
                            _searchController.clear();
                            ref.read(peopleSearchQueryProvider.notifier).state =
                                '';
                          }
                        : null,
                    actionLabel: 'Clear Search',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(peopleProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: people.length + 1,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      if (index == people.length) {
                        // Loading indicator at bottom
                        return ref.watch(peopleProvider.notifier).hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink();
                      }

                      return PersonCard(person: people[index]);
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(message: 'Loading people...'),
              error: (error, stack) => ErrorDisplayWidget(
                message: error.toString(),
                onRetry: () {
                  ref.read(peopleProvider.notifier).refresh();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
