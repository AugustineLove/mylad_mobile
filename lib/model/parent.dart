import 'package:myladmobile/model/student.dart';

class Parent {
  final String parentId;
  final String parentName;
  final String phoneNumber;
  final List<Student> children;

  Parent({
    required this.parentId,
    required this.parentName,
    required this.phoneNumber,
    required this.children,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    var childrenList = json['children'] as List;
    List<Student> students = childrenList.map((child) => Student.fromJson(child)).toList();
    return Parent(
      parentId: json['parentId'],
      parentName: json['parentName'],
      phoneNumber: json['phoneNumber'],
      children: students,
    );
  }
}