class TutorBooking {
  String? studentId;

  TutorBooking(this.studentId);

  static TutorBooking fromJson(Map<String, dynamic> json) {
    return TutorBooking(json["studentId"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["json"] = studentId;
    return json;
  }
}
