import 'package:dio/dio.dart';
import 'package:example/models/order.dart';
import 'package:example/models/payment_method.dart';
import 'package:example/models/user.dart';
import 'package:http_client_plugin/http_client_plugin.dart';

part 'example.gen.dart';

@HttpService()
abstract class AppHttpService {
  AppHttpService._();

  factory AppHttpService(
    Dio client, [
    String pathPrefix,
  ]) = _$AppHttpServiceImpl;

  AppHttpService overrideHttpClient(Dio client);

  UsersService get user;

  PaymentMethodsService get paymentMethods;

  GooglePlacesService get places;
}

@HttpService('/users')
abstract class UsersService {
  UsersService._();

  factory UsersService(
    Dio client, [
    String pathPrefix,
  ]) = _$UsersServiceImpl;

  UsersService overrideHttpClient(Dio client);

  OrdersService get orders;

  @HttpMethod.post('')
  FutureHttpResult<User> get(@QueryParam() int id);

  @HttpMethod.post('/update')
  FutureHttpResult<User> updateUser({
    @HttpPayload() User data = const User(id: '11', username: '11'),
  });

  @HttpMethod.post('/register')
  @HttpMultipart()
  FutureHttpResult<User> register({
    @HttpFormField() required String username,
    @HttpFormField() required String password,
    @HttpFormField(name: 'user.name') required String name,
    @HttpFormField() required int age,
    @HttpFormField.file(name: 'picture') required String filePath,
  });
}

@HttpService('/:userId/orders')
abstract class OrdersService {
  OrdersService._();

  factory OrdersService(
    Dio client, [
    String pathPrefix,
  ]) = _$OrdersServiceImpl;

  OrdersService overrideHttpClient(Dio client);

  @HttpMethod.get('')
  FutureHttpResult<Order> getOrderById({
    @PathParam() required int userId,
    @QueryParam() required int id,
  });

  @HttpMethod.get('/all')
  FutureHttpResult<List<Order>> getOrders(@PathParam() int userId);
}

@HttpService('/payment-methods')
abstract class PaymentMethodsService {
  PaymentMethodsService._();

  factory PaymentMethodsService(
    Dio client, [
    String pathPrefix,
  ]) = _$PaymentMethodsServiceImpl;

  PaymentMethodsService overrideHttpClient(Dio client);

  @HttpMethod.get('/:userId/list')
  FutureHttpResult<List<PaymentMethod>> getAll(@PathParam() int userId);
}

enum GoogleApiResponseOutput {
  json,
  xml;

  @override
  String toString() => name;
}

@HttpService('maps/api/place')
abstract class GooglePlacesService {
  GooglePlacesService._();

  factory GooglePlacesService(
    Dio client, [
    String pathPrefix,
  ]) = _$GooglePlacesServiceImpl;

  GooglePlacesService overrideHttpClient(Dio client);

  @HttpMethod.get('/autocomplete')
  FutureHttpResult<Map<String, dynamic>> autocomplete({
    @QueryParam() required String query,
    @QueryParam() int limit = 25,
    @QueryParam('apiKey') required int key,
    @QueryParam('output') GoogleApiResponseOutput output = GoogleApiResponseOutput.json,
  });
}

void main() async {
  final Dio httpClient = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api',
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ))
    ..interceptors.add(LogInterceptor());
  final AppHttpService httpService = AppHttpService(httpClient);

  // httpService.places will use a different http client
  httpService.places.overrideHttpClient(Dio(
    BaseOptions(baseUrl: 'https://maps.googleapis.com'),
  ));

  final HttpResult<User> getUserResult = await httpService.user.get(11);
  switch (getUserResult) {
    case HttpResultData<User>(:final User data):
      print(data);
    case HttpResultFailure<User>(:final Exception exception) when exception is DioException:
      print(exception);
    default:
      print('Something went bad');
  }
}
