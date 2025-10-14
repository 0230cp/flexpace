import 'package:get/get.dart';

/// 데이터 서비스
class UserDataService extends GetxService {
  static UserDataService get to => Get.find();

  // Variable ▼ ========================================

  /// 유저 데이터
  Rx<UserModel> userData = UserModel().obs;
  var user;

  // Functions ▼ ========================================

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}

// * 유저 정보 모델
class UserModel {
  String? docId;
  String? email;
  String? name;
  String? nickName;
  String? phoneNumber;
  bool? isAdmin;
  Map? fcmToken;
  Map? marketing;
  Map? profileImage;


  UserModel({
    this.docId,
    this.email,
    this.name,
    this.nickName,
    this.phoneNumber,
    this.isAdmin,
    this.fcmToken,
    this.marketing,
    this.profileImage,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> data,
  ) {
    return UserModel(
      docId: data['docId'] as String?,
      email: data['email'] as String?,
      name: data['name'] as String?,
      nickName: data['nickName'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      isAdmin: data['isAdmin'] as bool?,
      fcmToken: data['fcmToken'] as Map?,
      marketing: data['marketing'] as Map?,
      profileImage: data['profileImage'] as Map?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'email': email,
      'name': name,
      'nickName': nickName,
      'phoneNumber': phoneNumber,
      'isAdmin': isAdmin,
      'fcmToken': fcmToken,
      'marketing': marketing,
      'profileImage': profileImage,
    };
  }
}
