
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUtil {

  // 'Datetime' 또는 'Timestamp'를 'Datetime' 타입으로 반환
  static DateTime? toDatetime(dynamic datetime) {
    return (datetime.runtimeType == DateTime) ? datetime
        : (datetime.runtimeType == Timestamp) ? (datetime as Timestamp).toDate()
        : null;
  }
}