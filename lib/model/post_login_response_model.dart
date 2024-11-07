// To parse this JSON data, do
//
//     final postLoginOtpResponseModel = postLoginOtpResponseModelFromJson(jsonString);

import 'dart:convert';

UserLoginResponseModel postLoginResponseModelFromJson(String str) =>
    UserLoginResponseModel.fromJson(json.decode(str));

String postLoginResponseModelToJson(UserLoginResponseModel data) =>
    json.encode(data.toJson());

class UserLoginResponseModel {
  int? id;
  String? authToken;
  String? userId;
  String? firstName;
  dynamic lastName;
  String? role;
  String? mobileNumber;
  dynamic watsAppNumber;
  dynamic email;
  bool? isBlockedUser;
  bool isRegisteredUser;

  UserLoginResponseModel({
    this.id,
    this.authToken,
    this.userId,
    this.firstName,
    this.lastName,
    this.role,
    this.mobileNumber,
    this.watsAppNumber,
    this.email,
    this.isBlockedUser,
    this.isRegisteredUser = false,
  });

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseModel(
        id: json["id"],
        authToken: json["authToken"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        role: json["role"],
        mobileNumber: json["mobileNumber"],
        watsAppNumber: json["watsAppNumber"],
        email: json["email"],
        isBlockedUser: json["isBlockedUser"],
        isRegisteredUser: json["isRegisteredUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "authToken": authToken,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
        "mobileNumber": mobileNumber,
        "watsAppNumber": watsAppNumber,
        "email": email,
        "isBlockedUser": isBlockedUser,
        "isRegisteredUser": isRegisteredUser,
      };
}
