// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
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
  bool operator ==(Object other) {
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
