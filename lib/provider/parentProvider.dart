import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/utils/constants.dart';

class ParentProvider with ChangeNotifier {
  List<Student> _students = [];
  List<Student> get students => _students;

  /* Future<void> fetchChildren(String parentNumber) async {
    final url = Uri.parse("http://192.168.227.29:3000/api/parents/$parentNumber");
    
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data is List) {
          setStudents(data);
        } else {
          logger.e("Unexpected response format: $data");
        }
      } else {
        logger.e("Error ${response.statusCode}: ${data['message'] ?? 'Unknown error'}");
      }
    } catch (error) {
      logger.e("Failed to fetch children: $error");
    }
  } */

  void setStudents(List<Student> students) {
    _students = students;
    notifyListeners();
  }

}
