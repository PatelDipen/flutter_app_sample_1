import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/starships_remote_datasource.dart';
import '../../data/repositories/starships_repository_impl.dart';
import '../../domain/entities/starship.dart';
import '../../domain/repositories/starships_repository.dart';

final starshipsRemoteDataSourceProvider = Provider<StarshipsRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(swapiDioProvider);
  return StarshipsRemoteDataSourceImpl(dio: dio);
});

final starshipsRepositoryProvider = Provider<StarshipsRepository>((ref) {
  final remoteDataSource = ref.watch(starshipsRemoteDataSourceProvider);
  return StarshipsRepositoryImpl(remoteDataSource: remoteDataSource);
});

class StarshipsNotifier extends StateNotifier<AsyncValue<List<Starship>>> {
  final StarshipsRepository _repository;
  int _currentPage = 1;
  bool _hasMore = true;
  List<Starship> _allStarships = [];

  StarshipsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadStarships();
  }

  Future<void> loadStarships() async {
    if (!_hasMore) return;
    state = const AsyncValue.loading();

    final result = await _repository.fetchStarships(page: _currentPage);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (starships) {
        if (starships.isEmpty) {
          _hasMore = false;
        } else {
          _allStarships.addAll(starships);
          _currentPage++;
        }
        state = AsyncValue.data(_allStarships);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    final result = await _repository.fetchStarships(page: _currentPage);
    result.fold((failure) {}, (starships) {
      if (starships.isEmpty) {
        _hasMore = false;
      } else {
        _allStarships.addAll(starships);
        _currentPage++;
        state = AsyncValue.data(_allStarships);
      }
    });
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _allStarships = [];
    await loadStarships();
  }

  bool get hasMore => _hasMore;
}

final starshipsProvider =
    StateNotifierProvider<StarshipsNotifier, AsyncValue<List<Starship>>>((ref) {
      final repository = ref.watch(starshipsRepositoryProvider);
      return StarshipsNotifier(repository);
    });

final starshipsSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredStarshipsProvider = Provider<AsyncValue<List<Starship>>>((ref) {
  final query = ref.watch(starshipsSearchQueryProvider);
  final starshipsAsync = ref.watch(starshipsProvider);

  if (query.isEmpty) return starshipsAsync;

  return starshipsAsync.when(
    data: (starships) {
      final filtered = starships
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
