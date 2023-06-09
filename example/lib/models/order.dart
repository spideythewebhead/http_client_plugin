import 'package:data_class_plugin/data_class_plugin.dart';

part 'order.gen.dart';

@DataClass()
abstract class Order {
  Order.ctor();

  /// Default constructor
  factory Order({
    required String id,
    required String status,
  }) = _$OrderImpl;

  /// Creates an instance of [Order] from [json]
  factory Order.fromJson(Map<dynamic, dynamic> json) = _$OrderImpl.fromJson;

  String get id;
  String get status;

  /// Converts [Order] to a [Map] json
  Map<String, dynamic> toJson();
}
