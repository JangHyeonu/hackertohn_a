import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    // 유저가 버튼 클릭 시 구글 로그인 팝업 창 뜨고 로그인 하는 부분
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    // 받아온 정보를 저장
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    // firebase에 로그인 하기위해 credential을 불러와서 저장
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    // firebase에서 로그인
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}