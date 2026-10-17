class AuthSession {
  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiresAt;
  final String userId;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.userId,
  });

  bool get isExpired => DateTime.now().toUtc().isAfter(accessExpiresAt.subtract(const Duration(seconds: 60)));

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'accessExpiresAt': accessExpiresAt.toUtc().toIso8601String(),
        'userId': userId,
      };

  static AuthSession? fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];
    final accessExpiresAtRaw = json['accessExpiresAt'];
    final userId = json['userId'];

    if (accessToken is! String ||
        refreshToken is! String ||
        accessExpiresAtRaw is! String ||
        userId is! String) {
      return null;
    }

    final expiresAt = DateTime.tryParse(accessExpiresAtRaw);
    if (expiresAt == null) return null;

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessExpiresAt: expiresAt.toUtc(),
      userId: userId,
    );
  }

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? accessExpiresAt,
    String? userId,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessExpiresAt: accessExpiresAt ?? this.accessExpiresAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthSession &&
          other.accessToken == accessToken &&
          other.refreshToken == refreshToken &&
          other.accessExpiresAt == accessExpiresAt &&
          other.userId == userId);

  @override
  int get hashCode => Object.hash(accessToken, refreshToken, accessExpiresAt, userId);
}
