import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model with JSON serialization
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    String? image,
    String? token,
  }) = _UserModel;

  /// Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert model to entity
  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      image: image,
      token: token,
    );
  }

  /// Create model from entity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      image: entity.image,
      token: entity.token,
    );
  }
}
