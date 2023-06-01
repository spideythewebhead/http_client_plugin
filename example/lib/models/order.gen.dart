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

class _$OrderCopyWithProxy {
  _$OrderCopyWithProxy(this._value);

  final Order _value;

  @pragma('vm:prefer-inline')
  Order id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  Order status(String newValue) => this(status: newValue);

  @pragma('vm:prefer-inline')
  Order call({
    final String? id,
    final String? status,
  }) {
    return _$OrderImpl(
      id: id ?? _value.id,
      status: status ?? _value.status,
    );
  }
}

class $OrderCopyWithProxyChain<$Result> {
  $OrderCopyWithProxyChain(this._value, this._chain);

  final Order _value;
  final $Result Function(Order update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result status(String newValue) => this(status: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final String? id,
    final String? status,
  }) {
    return _chain(_$OrderImpl(
      id: id ?? _value.id,
      status: status ?? _value.status,
    ));
  }
}

extension $OrderExtension on Order {
  _$OrderCopyWithProxy get copyWith => _$OrderCopyWithProxy(this);
}
