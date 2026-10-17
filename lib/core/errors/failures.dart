/// Sealed failure hierarchy for the app.
sealed class Failure implements Exception {
  final String message;
  final Object? cause;

  const Failure(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.cause]);
}

final class NetworkFailure extends Failure {
  final int? statusCode;
  const NetworkFailure(String message, {this.statusCode, Object? cause}) : super(message, cause);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.cause]);
}

final class ConflictFailure extends Failure {
  const ConflictFailure(super.message, [super.cause]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.cause]);
}
