class UserModel {
  final String? userModelId;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;

  UserModel({
    this.userModelId,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userModelId: json['userModelId'], email: json['email'], displayName: json['displayName'], phoneNumber: json['phoneNumber'], photoUrl: json['photoUrl']);
  }
}