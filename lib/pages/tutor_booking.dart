class TutorBooking {
  String? studentId;
  String? name;
  String? email;
  int startDateTime;
  //List<int> recurringDates;
  String duration;
  String lessonType;
  List<String> subject;
  String lessonId;
  bool lessonConfirmed;

  TutorBooking(
      this.studentId,
      this.name,
      this.email,
      this.startDateTime,
      //this.recurringDates,
      this.duration,
      this.lessonType,
      this.subject,
      this.lessonId,
      this.lessonConfirmed);

  static TutorBooking fromJson(Map<String, dynamic> json) {
    return TutorBooking(
        json["studentId"],
        json["name"],
        json["email"],
        json["startDateTime"],
        // json["recurringDates"],
        json["duration"],
        json['lessonType'],
        json["subjectNames"],
        json["lessonId"],
        json["lessonConfirmed"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["studentId"] = studentId;
    json["name"] = name;
    json["email"] = email;
    json["startDateTime"] = startDateTime;
//    json["recurringDates"] = recurringDates;
    json["duration"] = duration;
    json["lessonType"] = lessonType;
    json["subjectNames"] = subject;
    json["lessonId"] = lessonId;
    json["lessonConfirmed"] = lessonConfirmed;
    return json;
  }
}
