// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'payment_method.dart';

class _$PaymentMethodImpl extends PaymentMethod {
  _$PaymentMethodImpl({
    required this.id,
    required this.last4,
    required this.expDate,
    required this.issuer,
  }) : super.ctor();

  @override
  final String id;

  @override
  final String last4;

  @override
  final String expDate;

  @override
  final String issuer;

  factory _$PaymentMethodImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$PaymentMethodImpl(
      id: json['id'] as String,
      last4: json['last4'] as String,
      expDate: json['expDate'] as String,
      issuer: json['issuer'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'last4': last4,
      'expDate': expDate,
      'issuer': issuer,
    };
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is PaymentMethod &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            last4 == other.last4 &&
            expDate == other.expDate &&
            issuer == other.issuer;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      last4,
      expDate,
      issuer,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'PaymentMethod{<optimized out>}';
    assert(() {
      toStringOutput =
          'PaymentMethod@<$hexIdentity>{id: $id, last4: $last4, expDate: $expDate, issuer: $issuer}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => PaymentMethod;
}

class _$PaymentMethodCopyWithProxy {
  _$PaymentMethodCopyWithProxy(this._value);

  final PaymentMethod _value;

  @pragma('vm:prefer-inline')
  PaymentMethod id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  PaymentMethod last4(String newValue) => this(last4: newValue);

  @pragma('vm:prefer-inline')
  PaymentMethod expDate(String newValue) => this(expDate: newValue);

  @pragma('vm:prefer-inline')
  PaymentMethod issuer(String newValue) => this(issuer: newValue);

  @pragma('vm:prefer-inline')
  PaymentMethod call({
    final String? id,
    final String? last4,
    final String? expDate,
    final String? issuer,
  }) {
    return _$PaymentMethodImpl(
      id: id ?? _value.id,
      last4: last4 ?? _value.last4,
      expDate: expDate ?? _value.expDate,
      issuer: issuer ?? _value.issuer,
    );
  }
}

class $PaymentMethodCopyWithProxyChain<$Result> {
  $PaymentMethodCopyWithProxyChain(this._value, this._chain);

  final PaymentMethod _value;
  final $Result Function(PaymentMethod update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result last4(String newValue) => this(last4: newValue);

  @pragma('vm:prefer-inline')
  $Result expDate(String newValue) => this(expDate: newValue);

  @pragma('vm:prefer-inline')
  $Result issuer(String newValue) => this(issuer: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final String? id,
    final String? last4,
    final String? expDate,
    final String? issuer,
  }) {
    return _chain(_$PaymentMethodImpl(
      id: id ?? _value.id,
      last4: last4 ?? _value.last4,
      expDate: expDate ?? _value.expDate,
      issuer: issuer ?? _value.issuer,
    ));
  }
}

extension $PaymentMethodExtension on PaymentMethod {
  _$PaymentMethodCopyWithProxy get copyWith => _$PaymentMethodCopyWithProxy(this);
}
