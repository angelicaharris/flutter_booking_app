class TutorReviews {
  String? studentId;
  String? studentName;
  String? studentEmail;
  String? studentMediaUrl;
  String? tutorName;
  String? tutorId;
  String? message;

  TutorReviews(this.studentId, this.studentName, this.studentEmail,
      this.studentMediaUrl, this.tutorName, this.tutorId, this.message);

  static TutorReviews fromJson(Map<String, dynamic> json) {
    return TutorReviews(
        json["studentId"],
        json["studentName"],
        json["studentEmail"],
        json["studentMediaUrl"],
        json["tutorName"],
        json["tutorId"],
        json["message"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["studentId"] = studentId;
    json["studentName"] = studentName;
    json["studentEmail"] = studentEmail;
    json["studentMediaUrl"] = studentMediaUrl;
    json["tutorName"] = tutorName;
    json["tutorId"] = tutorId;
    json["message"] = message;
    return json;
  }
}
