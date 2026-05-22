import 'user.dart';

class Session {
  final String token;
  final User user;
  final DateTime expiresAt;

  Session({required this.token, required this.user, required this.expiresAt});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'].toString(),
      user: User.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      expiresAt:
          DateTime.tryParse(json['expires_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  bool isValid() {
    return token.isNotEmpty && DateTime.now().isBefore(expiresAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
