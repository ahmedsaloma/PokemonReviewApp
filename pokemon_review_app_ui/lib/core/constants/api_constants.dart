import 'package:flutter/foundation.dart';

class ApiConstants {
  // Optional override for physical devices or custom hosts:
  // flutter run --dart-define=API_BASE_URL=http://192.168.1.9:5219/api/
  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;

    // Android emulator maps host machine localhost to 10.0.2.2.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5219/api/';
    }

    // Windows/iOS/macOS/Linux/Web running on the same machine.
    return 'http://localhost:5219/api/';
  }
}
