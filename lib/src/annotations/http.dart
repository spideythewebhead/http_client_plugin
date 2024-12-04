import 'package:http_client_plugin/src/multipart_list_format.dart';
import 'package:meta/meta_meta.dart';

@Target(<TargetKind>{TargetKind.classType})
class HttpService {
  static const String name = 'HttpService';

  const HttpService([String path = '']);
}

@Target(<TargetKind>{TargetKind.method})
class HttpMethod {
  static const String name = 'HttpMethod';

  const HttpMethod.get([String path = '']);
  const HttpMethod.post([String path = '']);
  const HttpMethod.delete([String path = '']);
  const HttpMethod.put([String path = '']);
}

@Target(<TargetKind>{TargetKind.method})
class HttpHeader {
  static const String name = 'HttpHeader';

  const HttpHeader(String key, String value);
}

@Target(<TargetKind>{TargetKind.parameter})
class QueryParam {
  static const String name = 'QueryParam';

  const QueryParam([String? key]);
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

@Target(<TargetKind>{TargetKind.method})
class HttpMultipart {
  static const String name = 'HttpMultipart';

  const HttpMultipart({
    MultipartListFormat listFormat = MultipartListFormat.multi,
  });
}

@Target(<TargetKind>{TargetKind.parameter})
class HttpFormField {
  static const String name = 'HttpFormField';

  const HttpFormField({
    String? name,
  });

  const HttpFormField.file({
    String? name,
    String? fileName,
  });
}
