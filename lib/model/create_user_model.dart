import 'dart:convert';

CreateUserResponseModel createUserResponseModelFromJson(String str) =>
    CreateUserResponseModel.fromJson(json.decode(str));

String createUserResponseModelToJson(CreateUserResponseModel data) =>
    json.encode(data.toJson());

class CreateUserResponseModel {
  int? createdBy;
  String? createdOn;
  int? modifiedBy;
  String? modifiedOn;
  int? id;
  String? userId;
  String? password;
  int? userRoleId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? address;
  String? pincode;
  String? city;
  String? state;
  String? gstNo;
  String? pan;
  String? website;
  String? authToken;
  bool? isBlockedUser;

  CreateUserResponseModel({
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.id,
    this.userId,
    this.password,
    this.userRoleId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.pincode,
    this.city,
    this.state,
    this.gstNo,
    this.pan,
    this.website,
    this.authToken,
    this.isBlockedUser,
  });

  factory CreateUserResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateUserResponseModel(
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        id: json["id"],
        userId: json["userId"],
        password: json["password"],
        userRoleId: json["userRoleId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
        gstNo: json["gstNo"],
        pan: json["pan"],
        website: json["website"],
        authToken: json["authToken"],
        isBlockedUser: json["isBlockedUser"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "createdOn": createdOn,
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "id": id,
        "userId": userId,
        "password": password,
        "userRoleId": userRoleId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "address": address,
        "pincode": pincode,
        "city": city,
        "state": state,
        "gstNo": gstNo,
        "pan": pan,
        "website": website,
        "authToken": authToken,
        "isBlockedUser": isBlockedUser,
      };
}
