/// A lightweight, idiomatic Result type for functional error handling.
sealed class Result<T> {
  const Result();

  /// Creates a successful result containing [data].
  const factory Result.ok(T data) = Ok<T>;

  /// Creates a failure result containing an [error] and optional [stackTrace].
  const factory Result.err(Object error, [StackTrace? stackTrace]) = Err<T>;

  /// Returns true if this is an [Ok] result.
  bool get isOk => this is Ok<T>;

  /// Returns true if this is an [Err] result.
  bool get isErr => this is Err<T>;

  /// Unwraps the data if [isOk], or returns [defaultValue] if [isErr].
  T unwrapOr(T defaultValue) {
    return switch (this) {
      Ok<T>(:final data) => data,
      Err<T>() => defaultValue,
    };
  }

  /// Transforms the contained value if [isOk].
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Ok<T>(:final data) => Result.ok(transform(data)),
      Err<T>(:final error, :final stackTrace) => Result.err(error, stackTrace),
    };
  }

  /// Pattern matching helper.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Object error, StackTrace? stackTrace) onFailure,
  }) {
    return switch (this) {
      Ok<T>(:final data) => onSuccess(data),
      Err<T>(:final error, :final stackTrace) => onFailure(error, stackTrace),
    };
  }
}

/// Represents a successful computation.
final class Ok<T> extends Result<T> {
  final T data;
  const Ok(this.data);

  @override
  String toString() => 'Result.ok($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ok<T> && other.data == data);

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed computation.
final class Err<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;

  const Err(this.error, [this.stackTrace]);

  @override
  String toString() => 'Result.err($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Err<T> && other.error == error);

  @override
  int get hashCode => error.hashCode;
}
