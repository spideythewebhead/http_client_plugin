// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'user.dart';

class _$UserImpl extends User {
  const _$UserImpl({
    required this.id,
    required this.username,
  }) : super.ctor();

  @override
  final String id;

  @override
  final String username;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput = 'User@<$hexIdentity>{id: $id, username: $username}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => User;
}
