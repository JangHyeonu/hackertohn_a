
class CommonMessage {
  static const String _DEBUG_SCREEN_BUILD = "DEBUG SCREEN BUILD LOG : '_screenName'";
  static String DEBUG_SCREEN_BUILD({required String screenName}) {
    return _DEBUG_SCREEN_BUILD.replaceAll("_screenName", screenName);
  }

  static const String _DEBUG_REPOSITORY_READ_LIST = "DEBUG REPOSITORY READ LIST LOG : "
      "\n searchText : '_searchText'"
      "\n limitCount : '_limitCount'"
      "\n needInit : '_needInit'";
  static String DEBUG_REPOSITORY_READ_LIST({String? searchText, int? limitCount, required bool needInit}) {
    return _DEBUG_SCREEN_BUILD
        .replaceAll("_searchText", searchText ?? "-NULL-")
        .replaceAll("_limitCount", limitCount?.toString() ?? "-NULL-")
        .replaceAll("_needInit", needInit.toString());
  }
}