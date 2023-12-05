import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>((ref) {
  return UserStateNotifier();
});

class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(UserModel(userModelId: "", email: "", displayName: "", phoneNumber: "", photoUrl: ""));

  void login({
    required UserCredential userCredential
  }) {
    if(userCredential == null) {
      return;
    }

    User user = userCredential.user!;

    UserModel loginUser = UserModel(
      userModelId: user.uid,
      email: user.email ?? "",
      displayName: user.displayName ?? "",
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL
    );

    state = loginUser;
  }

  void logout() {
    state = null;
  }

  bool isLogin() {
    if(state!.email == "") {
      return false;
    } else {
      return true;
    }
  }


}