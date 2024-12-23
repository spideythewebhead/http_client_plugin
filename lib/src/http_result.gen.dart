// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'http_result.dart';

extension $HttpResult<T> on HttpResult<T> {
  R when<R>({
    required R Function(HttpResultData<T> value) data,
    required R Function(HttpResultFailure<T> value) failure,
  }) {
    if (this is HttpResultData<T>) {
      return data(this as HttpResultData<T>);
    }
    if (this is HttpResultFailure<T>) {
      return failure(this as HttpResultFailure<T>);
    }
    throw UnimplementedError('$runtimeType is not generated by this plugin');
  }

  R maybeWhen<R>({
    R Function(HttpResultData<T> value)? data,
    R Function(HttpResultFailure<T> value)? failure,
    required R Function() orElse,
  }) {
    if (data != null && this is HttpResultData<T>) {
      return data(this as HttpResultData<T>);
    }
    if (failure != null && this is HttpResultFailure<T>) {
      return failure(this as HttpResultFailure<T>);
    }
    return orElse();
  }
}

class HttpResultData<T> extends HttpResult<T> {
  HttpResultData(
    this.data,
  ) : super._();

  final T data;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      data,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HttpResultData<T> && runtimeType == other.runtimeType && data == other.data;
  }

  @override
  String toString() {
    String toStringOutput = 'HttpResultData{<optimized out>}';
    assert(() {
      toStringOutput = 'HttpResultData@<$hexIdentity>{data: $data}';
      return true;
    }());
    return toStringOutput;
  }
}

class HttpResultFailure<T> extends HttpResult<T> {
  HttpResultFailure(
    this.exception, {
    this.stackTrace,
  }) : super._();

  final Exception exception;

  final StackTrace? stackTrace;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      exception,
      stackTrace,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HttpResultFailure<T> &&
            runtimeType == other.runtimeType &&
            exception == other.exception &&
            stackTrace == other.stackTrace;
  }

  @override
  String toString() {
    String toStringOutput = 'HttpResultFailure{<optimized out>}';
    assert(() {
      toStringOutput =
          'HttpResultFailure@<$hexIdentity>{exception: $exception, stackTrace: $stackTrace}';
      return true;
    }());
    return toStringOutput;
  }
}
