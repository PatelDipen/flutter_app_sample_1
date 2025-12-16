import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/planets_remote_datasource.dart';
import '../../data/repositories/planets_repository_impl.dart';
import '../../domain/entities/planet.dart';
import '../../domain/repositories/planets_repository.dart';

final planetsRemoteDataSourceProvider = Provider<PlanetsRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(swapiDioProvider);
  return PlanetsRemoteDataSourceImpl(dio: dio);
});

final planetsRepositoryProvider = Provider<PlanetsRepository>((ref) {
  final remoteDataSource = ref.watch(planetsRemoteDataSourceProvider);
  return PlanetsRepositoryImpl(remoteDataSource: remoteDataSource);
});

class PlanetsNotifier extends Notifier<AsyncValue<List<Planet>>> {
  int _currentPage = 1;
  bool _hasMore = true;
  List<Planet> _allPlanets = [];

  @override
  AsyncValue<List<Planet>> build() {
    loadPlanets();
    return const AsyncValue.loading();
  }

  PlanetsRepository get _repository => ref.read(planetsRepositoryProvider);

  Future<void> loadPlanets() async {
    if (!_hasMore) return;
    state = const AsyncValue.loading();

    final result = await _repository.fetchPlanets(page: _currentPage);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (planets) {
        if (planets.isEmpty) {
          _hasMore = false;
        } else {
          _allPlanets.addAll(planets);
          _currentPage++;
        }
        state = AsyncValue.data(_allPlanets);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    final result = await _repository.fetchPlanets(page: _currentPage);
    result.fold((failure) {}, (planets) {
      if (planets.isEmpty) {
        _hasMore = false;
      } else {
        _allPlanets.addAll(planets);
        _currentPage++;
        state = AsyncValue.data(_allPlanets);
      }
    });
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _allPlanets = [];
    await loadPlanets();
  }

  bool get hasMore => _hasMore;
}

final planetsProvider =
    NotifierProvider<PlanetsNotifier, AsyncValue<List<Planet>>>(() {
      return PlanetsNotifier();
    });

final planetsSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredPlanetsProvider = Provider<AsyncValue<List<Planet>>>((ref) {
  final query = ref.watch(planetsSearchQueryProvider);
  final planetsAsync = ref.watch(planetsProvider);

  if (query.isEmpty) return planetsAsync;

  return planetsAsync.when(
    data: (planets) {
      final filtered = planets
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
