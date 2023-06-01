import 'package:meta/meta_meta.dart';

@Target(<TargetKind>{TargetKind.classType})
class HttpService {
  static const String name = 'HttpService';

  const HttpService([this.path = '']);

  final String path;
}

@Target(<TargetKind>{TargetKind.method})
class HttpMethod {
  static const String name = 'HttpMethod';

  const HttpMethod.get(this.path) : method = 'GET';
  const HttpMethod.post(this.path) : method = 'POST';
  const HttpMethod.delete(this.path) : method = 'DELETE';
  const HttpMethod.put(this.path) : method = 'PUT';

  final String method;
  final String path;
}

@Target(<TargetKind>{TargetKind.method})
class HttpHeader {
  static const String name = 'HttpHeader';

  const HttpHeader(this.key, this.value);

  final String key;
  final String value;
}

@Target(<TargetKind>{TargetKind.parameter})
class QueryParam {
  static const String name = 'QueryParam';

  const QueryParam([this.key]);

  final String? key;
}

@Target(<TargetKind>{TargetKind.parameter})
class PathParam {
  static const String name = 'PathParam';

  const PathParam();
}

@Target(<TargetKind>{TargetKind.parameter})
class HttpPayload {
  static const String name = 'HttpPayload';

  const HttpPayload();
}
