// ignore_for_file: file_names
import 'dart:convert';

Auth authFromMap(String str) => Auth.fromMap(json.decode(str));

String authToMap(Auth data) => json.encode(data.toMap());

class Auth {
  Auth({
    this.id,
    required this.email,
    required this.password,
  });

  String? id;
  final String email;
  final String password;

  factory Auth.fromMap(Map<String, dynamic> json) => Auth(
        id: json["id"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "password": password,
      };
}
