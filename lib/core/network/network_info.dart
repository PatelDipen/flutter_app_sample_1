import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract interface for network connectivity checking
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of network info checker
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      // Try to lookup Google's DNS
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}

/// Provider for network info
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});
