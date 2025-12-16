import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/people_remote_datasource.dart';
import '../../data/repositories/people_repository_impl.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/people_repository.dart';

/// People remote datasource provider
final peopleRemoteDataSourceProvider = Provider<PeopleRemoteDataSource>((ref) {
  final dio = ref.watch(swapiDioProvider);
  return PeopleRemoteDataSourceImpl(dio: dio);
});

/// People repository provider
final peopleRepositoryProvider = Provider<PeopleRepository>((ref) {
  final remoteDataSource = ref.watch(peopleRemoteDataSourceProvider);
  return PeopleRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// People list state notifier
class PeopleNotifier extends Notifier<AsyncValue<List<Person>>> {
  int _currentPage = 1;
  bool _hasMore = true;
  List<Person> _allPeople = [];

  @override
  AsyncValue<List<Person>> build() {
    loadPeople();
    return const AsyncValue.loading();
  }

  PeopleRepository get _repository => ref.read(peopleRepositoryProvider);

  Future<void> loadPeople() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();

    final result = await _repository.fetchPeople(page: _currentPage);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (people) {
        if (people.isEmpty) {
          _hasMore = false;
        } else {
          _allPeople.addAll(people);
          _currentPage++;
        }
        state = AsyncValue.data(_allPeople);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final result = await _repository.fetchPeople(page: _currentPage);

    result.fold(
      (failure) {
        // Keep current state on error, just show a message
      },
      (people) {
        if (people.isEmpty) {
          _hasMore = false;
        } else {
          _allPeople.addAll(people);
          _currentPage++;
          state = AsyncValue.data(_allPeople);
        }
      },
    );
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _allPeople = [];
    await loadPeople();
  }

  bool get hasMore => _hasMore;
}

/// People provider
final peopleProvider =
    NotifierProvider<PeopleNotifier, AsyncValue<List<Person>>>(() {
      return PeopleNotifier();
    });

/// Search query provider
final peopleSearchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered people provider
final filteredPeopleProvider = Provider<AsyncValue<List<Person>>>((ref) {
  final query = ref.watch(peopleSearchQueryProvider);
  final peopleAsync = ref.watch(peopleProvider);

  if (query.isEmpty) {
    return peopleAsync;
  }

  return peopleAsync.when(
    data: (people) {
      final filtered = people
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
