class StudentBooking {
  String? tutorId;
  String? name;
  String? email;
  int startDateTime;
  String duration;
  String lessonType;
  List<String> subject;
  String lessonId;
  bool lessonConfirmed;

  StudentBooking(
      this.tutorId,
      this.name,
      this.email,
      this.startDateTime,
      this.duration,
      this.lessonType,
      this.subject,
      this.lessonId,
      this.lessonConfirmed);

  static StudentBooking fromJson(Map<String, dynamic> json) {
    return StudentBooking(
        json["tutorId"],
        json["name"],
        json["email"],
        json["startDateTime"],
        json["duration"],
        json['lessonType'],
        json["subjectNames"],
        json["lessonId"],
        json["lessonConfirmed"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["tutorId"] = tutorId;
    json["name"] = name;
    json["email"] = email;
    json["startDateTime"] = startDateTime;
    json["duration"] = duration;
    json["lessonType"] = lessonType;
    json["subjectNames"] = subject;
    json["lessonId"] = lessonId;
    json["lessonConfirmed"] = lessonConfirmed;
    return json;
  }
}
