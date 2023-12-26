import 'package:json_annotation/json_annotation.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';

@JsonSerializable()
class UserModel {
  // 유저 데이터 구분값
  final String? userUid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  late final JOIN_TYPE? joinType;
  final BusinessModel? businessModel;

  // 사용 권한
  late final String? auth;   // user, business

  // firebase messaging token
  late final String? messagingToken;

  UserModel({
    this.userUid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.businessModel,
    auth,
    this.messagingToken,
  }) {
    this.auth = (auth == null || auth == "") ? "guest" : auth;
  }

  UserModel copyWith({
    String? userUid, String? email,
    String? displayName, String? phoneNumber, String? photoUrl, String? state, BusinessModel? businessModel,
    String? auth, String? messagingToken,
  }) {
    return UserModel(
      userUid: userUid ?? this.userUid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      businessModel: businessModel ?? this.businessModel,
      auth: auth ?? this.auth,
      messagingToken : messagingToken ?? this.messagingToken,
      // state: state ?? this.state,
    );
  }


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userUid: json['userUid'], email: json['email'], displayName: json['displayName'],
      phoneNumber: json['phoneNumber'], photoUrl: json['photoUrl'],
      auth: json['auth'], messagingToken: json['messagingToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userUid" : userUid,
      "email" : email,
      "displayName" : displayName,
      "phoneNumber" : phoneNumber,
      "photoUrl" : photoUrl,
      // "state" : state,
      "auth" : auth,
      "messagingToken" : messagingToken,
    };
  }


}