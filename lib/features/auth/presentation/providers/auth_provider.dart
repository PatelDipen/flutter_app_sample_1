import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Auth remote datasource provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dummyJsonDioProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    secureStorage: secureStorage,
  );
});

/// Auth state notifier
class AuthNotifier extends Notifier<AsyncValue<User?>> {
  @override
  AsyncValue<User?> build() {
    _checkAuthStatus();
    return const AsyncValue.data(null);
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> _checkAuthStatus() async {
    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      await getCurrentUser();
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    final result = await _repository.login(
      username: username,
      password: password,
    );

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();

    final result = await _repository.getCurrentUser();

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    final result = await _repository.logout();

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }

  bool get isAuthenticated => state.value != null;
}

/// Auth state provider
final authProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(() {
  return AuthNotifier();
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).value;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).value != null;
});
