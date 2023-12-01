class UserModel {
  final String? userModelId;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? photoUrl;

  UserModel({
    this.userModelId,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.photoUrl,
  });

}