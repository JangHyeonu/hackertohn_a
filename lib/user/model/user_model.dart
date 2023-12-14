import 'package:json_annotation/json_annotation.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';

@JsonSerializable()
class UserModel {
  final String? userModelId;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  late final JOIN_TYPE? joinType;
  final BusinessModel? businessModel;

  // 사용 권한
  late final String? auth;   // user, business

  UserModel({
    this.userModelId,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.businessModel,
    auth,
  }) {
    this.auth = (auth == null || auth == "") ? "guest" : auth;
  }

  UserModel copyWith({
    String? userModelId, String? email,
    String? displayName, String? phoneNumber, String? photoUrl, String? state, BusinessModel? businessModel,
  }) {
    return UserModel(
      userModelId: userModelId ?? this.userModelId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      businessModel: businessModel ?? this.businessModel,
      // state: state ?? this.state,
    );
  }


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userModelId: json['userModelId'], email: json['email'], displayName: json['displayName'], phoneNumber: json['phoneNumber'], photoUrl: json['photoUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      "userModelId" : userModelId,
      "email" : email,
      "displayName" : displayName,
      "phoneNumber" : phoneNumber,
      "photoUrl" : photoUrl,
      // "state" : state,
      "auth" : auth,
    };
  }


}