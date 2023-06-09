import 'package:data_class_plugin/data_class_plugin.dart';

part 'http_result.gen.dart';

typedef FutureHttpResult<T> = Future<HttpResult<T>>;

typedef HttpResultRecord<T> = (T?, Exception?, StackTrace?);

@Union()
sealed class HttpResult<T> {
  const HttpResult._();

  factory HttpResult.data(T data) = HttpResultData<T>;

  factory HttpResult.failure(
    Exception exception, {
    StackTrace? stackTrace,
  }) = HttpResultFailure<T>;

  HttpResultRecord<T> asRecord() {
    return switch (this) {
      HttpResultData<T> result => (result.data, null, null),
      HttpResultFailure<T> result => (null, result.exception, result.stackTrace)
    };
  }
}
