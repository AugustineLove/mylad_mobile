class School {
  final String schoolName;
  final String schoolMoto;
  final String schoolLogo;

  School({
    required this.schoolName,
    required this.schoolMoto,
    required this.schoolLogo,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolName: json['schoolName'],
      schoolMoto: json['schoolAddress'],
      schoolLogo: json['schoolPhone'],
    );
  }

}
