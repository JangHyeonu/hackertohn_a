class BusinessModel {
  String? userModelId;
  String? email;
  // 계정의 사업자 권한 인증 상태
  String? state;  // apply, approve, reject
  // 사용 권한
  String auth = "user";   // user, business
  // 사업자등록증 경로
  String? docImgPath = "none";

  BusinessModel({
    this.userModelId,
    this.email,
    this.state,
    this.docImgPath,
  });

  BusinessModel copyWith({String? userModelId, String? email, String? state, String? docImgPath}) {
    return BusinessModel(
      userModelId: userModelId ?? this.userModelId,
      email: email ?? this.email,
      state: state ?? this.state,
      docImgPath: docImgPath ?? this.docImgPath,
    );
  }

}
