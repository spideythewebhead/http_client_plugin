import 'package:data_class_plugin/data_class_plugin.dart';

part 'payment_method.gen.dart';

@DataClass()
abstract class PaymentMethod {
  PaymentMethod.ctor();

  /// Default constructor
  factory PaymentMethod({
    required String id,
    required String last4,
    required String expDate,
    required String issuer,
  }) = _$PaymentMethodImpl;

  /// Creates an instance of [PaymentMethod] from [json]
  factory PaymentMethod.fromJson(Map<dynamic, dynamic> json) = _$PaymentMethodImpl.fromJson;

  String get id;
  String get last4;
  String get expDate;
  String get issuer;

  /// Converts [PaymentMethod] to a [Map] json
  Map<String, dynamic> toJson();
}
