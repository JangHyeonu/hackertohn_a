import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {

  String? eventId;
  String? title;
  String? content;
  String? postcode;
  String? location;
  String? locationDetail;
  double? latitude;
  double? longitude;
  DateTime? startDatetime;
  DateTime? endDatetime;
  String? caution;

  String? register;
  DateTime? regDatetime;

  String? businessName;

  EventModel({
    this.eventId,
    this.title,
    this.content,
    this.postcode,
    this.location,
    this.locationDetail,
    this.latitude,
    this.longitude,
    this.startDatetime,
    this.endDatetime,
    this.caution,
    this.register,
    this.regDatetime,
    this.businessName,
  });

  // ignore: non_constant_identifier_names
  EventModel.Empty();

  //  Model -> Map
  Map<String, dynamic> toMap() {
    return {
      "title" : title,
      "content" : content,
      "postcode" : postcode,
      "location" : location,
      "locationDetail" : locationDetail,
      "latitude" : latitude,
      "longitude" : longitude,
      "startDatetime" : startDatetime,
      "endDatetime" : endDatetime,
      "caution" : caution,
      "register" : register,
      "regDatetime" : regDatetime,
      "businessName" : businessName,
    };
  }

  //  Model -> Map :: All Data
  Map<String, dynamic> toMapAllData() {
    Map<String, dynamic> result = toMap();
    result["eventId"] = eventId;

    return result;
  }

  // Map -> Model
  static EventModel of(Map<String, dynamic> map) {
    return EventModel(
      eventId: map["eventId"],
      title: map["title"],
      content: map["content"],
      postcode: map["postcode"],
      location: map["location"],
      locationDetail: map["locationDetail"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      startDatetime: (map["startDatetime"].runtimeType == DateTime) ? map["startDatetime"]
          : (map["startDatetime"].runtimeType == Timestamp) ? (map["startDatetime"] as Timestamp).toDate()
          : null,
      endDatetime: (map["endDatetime"].runtimeType == DateTime) ? map["endDatetime"]
          : (map["endDatetime"].runtimeType == Timestamp) ? (map["endDatetime"] as Timestamp).toDate()
          : null,
      caution: map["caution"],
      register: map["register"],
      regDatetime: (map["regDatetime"].runtimeType == DateTime) ? map["regDatetime"]
          : (map["regDatetime"].runtimeType == Timestamp) ? (map["regDatetime"] as Timestamp).toDate()
          : null,
      businessName: map["businessName"],
    );
  }

  // List<Map> -> List<Model>
  static List<EventModel> listOf(List<Map<String, dynamic>> list) {
    return list.map((e) => (e != null) ? of(e) : EventModel()).toList();
  }

}