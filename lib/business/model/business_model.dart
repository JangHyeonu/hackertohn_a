class BusinessModel {
  // 유저 정보
  String? userModelId;
  String? email;

  // 계정의 사업자 권한 인증 상태
  String? state;  // apply, approve, reject
  // 사용 권한
  String auth = "user";   // user, business

  // 사업자 등록번호
  String? businessNumber;
  // 사업자 상호명
  String? businessTitle;
  // 사업자 업종
  String? businessCategory;
  // 사업자 대표자명
  String? businessName;
  // 사업자등록증 사진
  String? businessImagePath;

  BusinessModel({
    this.userModelId,
    this.email,
    this.state,
    this.businessNumber,
    this.businessTitle,
    this.businessCategory,
    this.businessName,
    this.businessImagePath,
  });

  BusinessModel copyWith({
    String? userModelId, String? email, String? state,
    String? businessNumber, String? businessTitle, String? businessCategory, String? businessName, String? businessImagePath,
  }) {
    return BusinessModel(
      userModelId: userModelId ?? this.userModelId,
      email: email ?? this.email,
      state: state ?? this.state,
      businessNumber: businessNumber ?? this.businessNumber,
      businessTitle: businessTitle ?? this.businessTitle,
      businessCategory: businessCategory ?? this.businessCategory,
      businessName: businessName ?? this.businessName,
      businessImagePath: businessImagePath ?? this.businessImagePath,
    );
  }

}
