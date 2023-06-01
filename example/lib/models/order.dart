import 'package:data_class_plugin/data_class_plugin.dart';

part 'order.gen.dart';

@DataClass(fromJson: true)
abstract class Order {
  Order.ctor();

  /// Default constructor
  factory Order({
    required String id,
    required String status,
  }) = _$OrderImpl;

  String get id;
  String get status;

  /// Creates an instance of [Order] from [json]
  factory Order.fromJson(Map<dynamic, dynamic> json) = _$OrderImpl.fromJson;
}
