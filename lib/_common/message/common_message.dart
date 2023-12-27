
import 'package:flutter/cupertino.dart';

class CommonMessage {

  static String _getDefualtLogginMessage({
    required String messageFormat,
    required String className,
    required String functionName,
    Map<String, dynamic>? logData
  }) {
    // 필터 내용 정리
    String filterStr = "";
    if(logData != null) {
      for(MapEntry<String, dynamic> filter in logData.entries) {
        if(filter.value != null) {
          filterStr += "${filter.key} : '${filter.value}' \n";
        }
      }
      filterStr = filterStr.substring(0, filterStr.length - 3);
    }

    debugPrint(StackTrace.current.toString());

    return messageFormat
        .replaceAll("_className", className)
        .replaceAll("_filter", filterStr);
  }

  /// 화면 빌드 로그
  static const String _LOG_SCREEN_BUILD = "SCREEN BUILD LOG : '_className'";
  static String LOG_SCREEN_BUILD({required String className}) {
    return _LOG_SCREEN_BUILD.replaceAll("_className", className);
  }

  /// 레파지토리 기본 로그
  static const String _LOG_REPOSITORY = "REPOSITORY LOG : '_className' : _functionName"
      "\n_filter";
  static String LOG_REPOSITORY({required String className, required String functionName, Map<String, dynamic>? logData}) {
    return _getDefualtLogginMessage(messageFormat: _LOG_REPOSITORY, className: className, functionName: functionName, logData: logData);
  }

  /// 프로바이터 기본 로그
  static const String _LOG_PROVIDER = "PROVIDER LOG : _className : _functionName";
  static String LOG_PROVIDER({required String className, required String functionName, Map<String, dynamic>? logData}) {
    return _getDefualtLogginMessage(messageFormat: _LOG_PROVIDER, className: className, functionName: functionName, logData: logData);
  }
}