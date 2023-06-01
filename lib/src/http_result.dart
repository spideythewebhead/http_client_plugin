import 'package:data_class_plugin/data_class_plugin.dart';

part 'http_result.gen.dart';

typedef FutureHttpResult<T> = Future<HttpResult<T>>;

@Union()
sealed class HttpResult<T> {
  const HttpResult._();

  factory HttpResult.data(T data) = HttpResultData<T>;

  factory HttpResult.failure(
    Exception exception, {
    StackTrace? stackTrace,
  }) = HttpResultFailure<T>;
}
