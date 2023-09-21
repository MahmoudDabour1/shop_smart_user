import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.userName,
    required super.userImage,
    required super.userEmail,
    required super.createdAt,
    required super.userCart,
    required super.userWish,
  });
}
