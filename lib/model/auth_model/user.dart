import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String token;
  @HiveField(1)
  int userId;
  @HiveField(2)
  String fullName;
  @HiveField(3)
  String mobileNumber;
  @HiveField(4)
  String email;

  User(
      {required this.token,
      required this.userId,
      required this.email,
      required this.mobileNumber,
      required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        token: json['token'] ?? '',
        userId: json['userId'] ?? 0,
        email: json['email'] ?? '',
        mobileNumber: json['mobileNumber'] ?? '',
        fullName: json['fullName'] ?? '');
  }
}
