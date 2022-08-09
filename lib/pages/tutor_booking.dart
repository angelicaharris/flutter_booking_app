class TutorBooking {
  String? studentId;
  String? name;
  String? email;
  int startDateTime;
  String duration;
  String lessonType;

  TutorBooking(this.studentId, this.name, this.email, this.startDateTime,
      this.duration, this.lessonType);

  static TutorBooking fromJson(Map<String, dynamic> json) {
    return TutorBooking(json["studentId"], json["name"], json["email"],
        json["startDateTime"], json["duration"], json['lessonType']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["studentId"] = studentId;
    json["name"] = name;
    json["email"] = email;
    json["startDateTime"] = startDateTime;
    json["duration"] = duration;
    json["lessonType"] = lessonType;
    return json;
  }
}
