class AuthResponse {
  final String? token;
  final DateTime? expiration;
  final String message;

  AuthResponse({this.token, this.expiration, required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      expiration: json['expiration'] != null ? DateTime.parse(json['expiration']) : null,
      message: json['message'] ?? 'Success',
    );
  }
}
