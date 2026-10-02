/// Outcome of a repository/usecase call.
///
/// Every network call returns a `Result<T>` instead of throwing, so a cubit only
/// has to pattern-match:
///
/// ```dart
/// switch (await _getList(params)) {
///   case Success(:final value): emit(Loaded(value));
///   case Failed(:final message): emit(Error(message));
/// }
/// ```
sealed class Result<T> {
  const Result({this.statusCode});

  /// HTTP status of the response, when there was one.
  final int? statusCode;

  const factory Result.success(T value, {int? statusCode}) = Success<T>;

  const factory Result.failed(
    String message, {
    int? statusCode,
    Map<String, List<String>>? fieldErrors,
  }) = Failed<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailed => this is Failed<T>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failed() => null,
  };

  String? get errorMessage => switch (this) {
    Success() => null,
    Failed(:final message) => message,
  };

  /// Transform the success value, keeping failures untouched.
  Result<U> map<U>(U Function(T value) transform) => switch (this) {
    Success(:final value, :final statusCode) => Success(
      transform(value),
      statusCode: statusCode,
    ),
    Failed(:final message, :final statusCode, :final fieldErrors) => Failed(
      message,
      statusCode: statusCode,
      fieldErrors: fieldErrors,
    ),
  };

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failed<T> failure) onFailed,
  }) => switch (this) {
    Success(:final value) => onSuccess(value),
    Failed() => onFailed(this as Failed<T>),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value, {super.statusCode});

  final T value;

  @override
  String toString() => 'Success($value, status: $statusCode)';
}

final class Failed<T> extends Result<T> {
  const Failed(this.message, {super.statusCode, this.fieldErrors});

  /// Human-readable message, already safe to show to the user.
  final String message;

  /// Laravel-style validation errors (`422`): `{ "email": ["..."] }`.
  final Map<String, List<String>>? fieldErrors;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidation => statusCode == 422;

  /// First validation message for [field], if any.
  String? fieldError(String field) => fieldErrors?[field]?.firstOrNull;

  @override
  String toString() => 'Failed($message, status: $statusCode)';
}
