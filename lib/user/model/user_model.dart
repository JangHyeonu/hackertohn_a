class UserModel {
  final String? userModelId;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;

  // 계정의 사업자 권한 인증 상태
  final String? state;  // apply, approve, reject
  // 사용 권한
  final String auth = "user";   // user, business

  UserModel({
    this.userModelId,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.state,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userModelId: json['userModelId'], email: json['email'], displayName: json['displayName'], phoneNumber: json['phoneNumber'], photoUrl: json['photoUrl']);
  }
}