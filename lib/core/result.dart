sealed class Result<T> {
  const Result();

  R when<R>({required R Function(T) success, required R Function(Failure) failure}) {
    final self = this;
    if (self is Success<T>) return success(self.value);
    if (self is FailureResult<T>) return failure(self.error);
    throw StateError('Unknown Result subtype');
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class FailureResult<T> extends Result<T> {
  final Failure error;
  const FailureResult(this.error);
}

sealed class Failure {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
  const Failure(this.message, {this.cause, this.stackTrace});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.cause, super.stackTrace});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause, super.stackTrace});
}
