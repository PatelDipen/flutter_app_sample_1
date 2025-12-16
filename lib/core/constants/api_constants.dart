/// API Constants for the application
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // Base URLs
  static const String swapiBaseUrl = 'https://swapi.dev/api';
  static const String dummyJsonBaseUrl = 'https://dummyjson.com';

  // SWAPI Endpoints
  static const String peopleEndpoint = '/people';
  static const String starshipsEndpoint = '/starships';
  static const String planetsEndpoint = '/planets';

  // DummyJSON Endpoints
  static const String authLoginEndpoint = '/auth/login';
  static const String authMeEndpoint = '/auth/me';
  static const String usersEndpoint = '/users';

  // Pagination
  static const int defaultPageSize = 10;
  static const int defaultTimeout = 30000; // 30 seconds

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';

  // Cache Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String peopleFilterKey = 'people_filter';
  static const String starshipsFilterKey = 'starships_filter';
  static const String planetsFilterKey = 'planets_filter';
}
