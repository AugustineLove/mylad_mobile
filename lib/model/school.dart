class School {
  final String schoolName;
  final String schoolId;
  final String schoolAddress;
  final String schoolWebsite;

  School({
    required this.schoolName,
    required this.schoolId,
    required this.schoolAddress,
    required this.schoolWebsite,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolName: json['schoolName'] ?? '', // Ensure this matches the API response
      schoolId: json['_id'] ?? '', // Ensure this key exists in your API response
      schoolAddress:
          json['schoolAddress'] ?? '', // Corrected key from 'schoolAddress'
      schoolWebsite: json['schoolWebsite'] ?? '', // Corrected key from 'schoolPhone'
    );
  }
}
