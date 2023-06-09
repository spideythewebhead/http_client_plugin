// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
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
  bool operator ==(Object? other) {
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
