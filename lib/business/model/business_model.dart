class BusinessModel {
  // 유저 정보
  String? userModelId;
  String? email;

  // 사업자 등록번호
  String? businessNumber;
  // 사업자 상호명
  String? businessTitle;
  // 사업장 주소
  String? businessAddress;
  // 사업자 업종
  String? businessCategory;
  // 사업자 대표자명
  String? businessName;
  // 사업자등록증 사진
  String? businessImagePath;

  BusinessModel({
    this.userModelId,
    this.email,
    this.businessNumber,
    this.businessTitle,
    this.businessAddress,
    this.businessCategory,
    this.businessName,
    this.businessImagePath,
  });

  BusinessModel copyWith({
    String? userModelId, String? email,
    String? businessNumber, String? businessTitle, String? businessAddress, String? businessCategory, String? businessName, String? businessImagePath,
  }) {
    return BusinessModel(
      userModelId: userModelId ?? this.userModelId,
      email: email ?? this.email,
      businessNumber: businessNumber ?? this.businessNumber,
      businessTitle: businessTitle ?? this.businessTitle,
      businessAddress: businessAddress ?? this.businessAddress,
      businessCategory: businessCategory ?? this.businessCategory,
      businessName: businessName ?? this.businessName,
      businessImagePath: businessImagePath ?? this.businessImagePath,
    );
  }

}
