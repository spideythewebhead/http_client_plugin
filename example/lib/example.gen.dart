// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'example.dart';

class _$AppHttpServiceImpl extends AppHttpService {
  _$AppHttpServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = pathPrefix;
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  AppHttpService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  late final UsersService user = UsersService(_client, _pathPrefix);

  @override
  late final PaymentMethodsService paymentMethods = PaymentMethodsService(_client, _pathPrefix);

  @override
  late final GooglePlacesService places = GooglePlacesService(_client, _pathPrefix);

  @override
  late final JsonPlaceholderHttpService jsonPlaceholder =
      JsonPlaceholderHttpService(_client, _pathPrefix);
}

class _$UsersServiceImpl extends UsersService {
  _$UsersServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = '${pathPrefix}/users';
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  UsersService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  late final OrdersService orders = OrdersService(_client, _pathPrefix);

  @override
  FutureHttpResult<User> get(
    int id,
  ) async {
    try {
      final String path = '$_pathPrefix/';
      final Response<dynamic> response = await _client.post(
        path,
        queryParameters: <String, String>{
          'id': id.toString(),
        },
      );
      return HttpResult<User>.data(User.fromJson(response.data!));
    } on Exception catch (exception, stackTrace) {
      return HttpResult<User>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  FutureHttpResult<User> updateUser({
    User data = const User(id: '11', username: '11'),
  }) async {
    try {
      final String path = '$_pathPrefix/update';
      final Response<dynamic> response = await _client.post(
        path,
        data: data.toJson(),
      );
      return HttpResult<User>.data(User.fromJson(response.data!));
    } on Exception catch (exception, stackTrace) {
      return HttpResult<User>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  FutureHttpResult<User> register({
    required String username,
    required String password,
    required String name,
    required int age,
    required String filePath,
  }) async {
    try {
      final String path = '$_pathPrefix/register';
      final Response<dynamic> response = await _client.post(
        path,
        data: await (() async {
          final FormData data = FormData.fromMap({
            'username': username,
            'password': password,
            'user.name': name,
            'age': age,
            'picture': await MultipartFile.fromFile(filePath),
          }, ListFormat.multi);
          return data;
        })(),
      );
      return HttpResult<User>.data(User.fromJson(response.data!));
    } on Exception catch (exception, stackTrace) {
      return HttpResult<User>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }
}

class _$OrdersServiceImpl extends OrdersService {
  _$OrdersServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = '${pathPrefix}/:userId/orders';
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  OrdersService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  FutureHttpResult<Order> getOrderById({
    required int userId,
    required int id,
  }) async {
    try {
      final String path = '$_pathPrefix/'.replaceAllMapped(RegExp(r':(userId)'), (Match match) {
        return switch (match.group(1)) {
          'userId' => '$userId',
          _ => '',
        };
      });
      final Response<dynamic> response = await _client.get(
        path,
        queryParameters: <String, String>{
          'id': id.toString(),
        },
      );
      return HttpResult<Order>.data(Order.fromJson(response.data!));
    } on Exception catch (exception, stackTrace) {
      return HttpResult<Order>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  FutureHttpResult<List<Order>> getOrders(
    int userId,
  ) async {
    try {
      final String path = '$_pathPrefix/all'.replaceAllMapped(RegExp(r':(userId)'), (Match match) {
        return switch (match.group(1)) {
          'userId' => '$userId',
          _ => '',
        };
      });
      final Response<dynamic> response = await _client.get(
        path,
      );
      return HttpResult<List<Order>>.data(
          <Order>[for (final dynamic i0 in (response.data! as List<dynamic>)) Order.fromJson(i0)]);
    } on Exception catch (exception, stackTrace) {
      return HttpResult<List<Order>>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }
}

class _$PaymentMethodsServiceImpl extends PaymentMethodsService {
  _$PaymentMethodsServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = '${pathPrefix}/payment-methods';
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  PaymentMethodsService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  FutureHttpResult<List<PaymentMethod>> getAll(
    int userId,
  ) async {
    try {
      final String path =
          '$_pathPrefix/:userId/list'.replaceAllMapped(RegExp(r':(userId)'), (Match match) {
        return switch (match.group(1)) {
          'userId' => '$userId',
          _ => '',
        };
      });
      final Response<dynamic> response = await _client.get(
        path,
      );
      return HttpResult<List<PaymentMethod>>.data(<PaymentMethod>[
        for (final dynamic i0 in (response.data! as List<dynamic>)) PaymentMethod.fromJson(i0)
      ]);
    } on Exception catch (exception, stackTrace) {
      return HttpResult<List<PaymentMethod>>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }
}

class _$GooglePlacesServiceImpl extends GooglePlacesService {
  _$GooglePlacesServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = '${pathPrefix}/maps/api/place';
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  GooglePlacesService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  FutureHttpResult<Map<String, dynamic>> autocomplete({
    required String query,
    int limit = 25,
    required int key,
    GoogleApiResponseOutput output = GoogleApiResponseOutput.json,
  }) async {
    try {
      final String path = '$_pathPrefix/autocomplete';
      final Response<dynamic> response = await _client.get(
        path,
        queryParameters: <String, String>{
          'query': query.toString(),
          'limit': limit.toString(),
          'apiKey': key.toString(),
          'output': output.toString(),
        },
      );
      return HttpResult<Map<String, dynamic>>.data(<String, dynamic>{
        for (final MapEntry<dynamic, dynamic> e0
            in (response.data! as Map<dynamic, dynamic>).entries)
          e0.key as String: e0.value
      });
    } on Exception catch (exception, stackTrace) {
      return HttpResult<Map<String, dynamic>>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }
}
