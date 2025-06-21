import 'package:tb_mobile/model/user.dart';

class LoginResponse {
  final String token;
  final User author;

  LoginResponse({
    required this.token,
    required this.author,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      author: User.fromJson(json['author']),
    );
  }
}