import 'package:json_annotation/json_annotation.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';

@JsonSerializable()
class UserModel {
  // 유저 데이터 구분값
  final String? userUid;
  final String? id;
  final String? password;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final JOIN_TYPE? joinType;
  final BusinessModel? businessModel;

  // 사용 권한
  late final String? auth;   // user, business

  // firebase messaging token
  late final String? messagingToken;

  UserModel({
    this.userUid,
    this.id,
    this.password,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.businessModel,
    this.joinType,
    auth,
    this.messagingToken,
  }) {
    this.auth = (auth == null || auth == "") ? "guest" : auth;
  }

  // 값 변경시 사용
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

  // Map<String, dynamic> -> UserModel
  static of(Map<String, dynamic> dataMap) {
    return UserModel(
      userUid: dataMap["userUid"],
      id: dataMap["id"],
      password: dataMap["password"],
      email: dataMap["email"],
      displayName: dataMap["displayName"],
      phoneNumber: dataMap["phoneNumber"],
      photoUrl: dataMap["photoUrl"],
      auth: dataMap["auth"],
      joinType: dataMap["joinType"],
      businessModel: BusinessModel.fromJson(dataMap["businessModel"]),
      messagingToken: dataMap["messagingToken"],
    );
  }

  // UserModel -> Map<String, dynamic>
  Map<String, dynamic> toMap() {
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