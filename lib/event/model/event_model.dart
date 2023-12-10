class EventModel {

  String? eventId;
  String? title;
  String? content;
  String? location;
  DateTime? startDatetime;
  DateTime? endDatetime;
  String? caution;

  String? register;
  DateTime? regDatetime;

  EventModel({
    this.eventId,
    this.title,
    this.content,
    this.location,
    this.startDatetime,
    this.endDatetime,
    this.caution,
    this.register,
    this.regDatetime,
  });

  // ignore: non_constant_identifier_names
  EventModel.Empty();

  Map<String, dynamic> toMap() {
    return {
      "title" : title,
      "content" : content,
      "location" : location,
      "startDatetime" : startDatetime,
      "endDatetime" : endDatetime,
      "caution" : caution,
      "register" : register,
      "regDatetime" : regDatetime
    };
  }
  Map<String, dynamic> toMapAllData() {
    return {
      "eventId" : eventId,
      "title" : title,
      "content" : content,
      "location" : location,
      "startDatetime" : startDatetime,
      "endDatetime" : endDatetime,
      "caution" : caution,
      "register" : register,
      "regDatetime" : regDatetime
    };
  }

  static EventModel of(Map<String, dynamic> map) {
    return EventModel(
      eventId: map["eventId"],
      title: map["title"],
      content: map["content"],
      location: map["location"],
      startDatetime: map["startDatetime"],
      endDatetime: map["endDatetime"],
      caution: map["caution"],
      register: map["register"],
      regDatetime: map["regDate"],
    );
  }

  static List<EventModel> listOf(List<Map<String, dynamic>> list) {
    return list.map((e) => (e != null) ? of(e) : EventModel()).toList();
  }

}