// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'order.dart';

class _$OrderImpl extends Order {
  _$OrderImpl({
    required this.id,
    required this.status,
  }) : super.ctor();

  @override
  final String id;

  @override
  final String status;

  factory _$OrderImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$OrderImpl(
      id: json['id'] as String,
      status: json['status'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'status': status,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Order &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            status == other.status;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      status,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Order{<optimized out>}';
    assert(() {
      toStringOutput = 'Order@<$hexIdentity>{id: $id, status: $status}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Order;
}
