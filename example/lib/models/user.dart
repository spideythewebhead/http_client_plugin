import 'package:data_class_plugin/data_class_plugin.dart';

part 'user.gen.dart';

@DataClass(
  fromJson: true,
  toJson: true,
)
abstract class User {
  const User.ctor();

  /// Default constructor
  const factory User({
    required String id,
    required String username,
  }) = _$UserImpl;

  String get id;

  String get username;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}
