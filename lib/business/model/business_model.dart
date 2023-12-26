class BusinessModel {
  // 유저 정보
  String? userUid;
  String? email;

  // todo: businessModielId 추가하기

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

  // 계정의 사업자 권한 인증 상태
  String? applyState;  // apply, approve, reject

  BusinessModel({
    this.userUid,
    this.email,
    this.businessNumber,
    this.businessTitle,
    this.businessAddress,
    this.businessCategory,
    this.businessName,
    this.businessImagePath,
    this.applyState,
  });

  BusinessModel copyWith({
    String? userUid, String? email,
    String? businessNumber, String? businessTitle, String? businessAddress, String? businessCategory, String? businessName, String? businessImagePath, String? applyState,
  }) {
    return BusinessModel(
      userUid: userUid ?? this.userUid,
      email: email ?? this.email,
      businessNumber: businessNumber ?? this.businessNumber,
      businessTitle: businessTitle ?? this.businessTitle,
      businessAddress: businessAddress ?? this.businessAddress,
      businessCategory: businessCategory ?? this.businessCategory,
      businessName: businessName ?? this.businessName,
      businessImagePath: businessImagePath ?? this.businessImagePath,
      applyState: applyState ?? this.applyState,
    );
  }

  factory BusinessModel.fromJson(Map<String, dynamic>? json) {
    return BusinessModel(
      userUid: json?['userUid'],
      email: json?['email'],
      businessNumber: json?['businessNumber'],
      businessTitle: json?['businessTitle'],
      businessAddress: json?['businessAddress'],
      businessCategory: json?['businessCategory'],
      businessName: json?['businessName'],
      businessImagePath: json?['businessImagePath'],
      applyState: json?['applyState'],
    );

  }

  Map<String, dynamic> toJson() {
    return {
      // "userUid" : userUid,
      // "email" : email,
      "businessNumber" : businessNumber,
      "businessTitle" : businessTitle,
      "businessAddress" : businessAddress,
      "businessCategory" : businessCategory,
      "businessName" : businessName,
      "businessImagePath" : businessImagePath,
      "applyState" : applyState,
    };
  }

  BusinessModel update(String? applyState) {
    this.applyState = applyState;
    return this;
  }
}
