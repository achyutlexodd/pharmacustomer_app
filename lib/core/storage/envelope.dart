import 'dart:convert';

/// Standard storage envelope wrapping all persisted JSON payloads.
/// Schema: { v: int, savedAt: UTC ISO-8601, userId: String?, data: {...} }
class Envelope {
  final int v;
  final DateTime savedAt;
  final String? userId;
  final Map<String, dynamic> data;

  const Envelope({
    required this.v,
    required this.savedAt,
    this.userId,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        'v': v,
        'savedAt': savedAt.toUtc().toIso8601String(),
        'userId': userId,
        'data': data,
      };

  String encode() => jsonEncode(toJson());

  static Envelope? fromJson(Map<String, dynamic> json) {
    final v = json['v'];
    final savedAtRaw = json['savedAt'];
    final dataRaw = json['data'];

    if (v is! int || savedAtRaw is! String || dataRaw is! Map<String, dynamic>) {
      return null;
    }

    final parsedTime = DateTime.tryParse(savedAtRaw);
    if (parsedTime == null) return null;

    final userIdRaw = json['userId'];
    final userId = userIdRaw is String ? userIdRaw : null;

    return Envelope(
      v: v,
      savedAt: parsedTime.toUtc(),
      userId: userId,
      data: dataRaw,
    );
  }

  static Envelope? decode(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) return null;
      return Envelope.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
