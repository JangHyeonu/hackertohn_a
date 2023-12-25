
class CommonMessage {
  static const String _DEBUG_SCREEN_BUILD = "DEBUG SCREEN BUILD LOG : '_screenName'";
  static String DEBUG_SCREEN_BUILD({required String screenName}) {
    return _DEBUG_SCREEN_BUILD.replaceAll("_screenName", screenName);
  }

}