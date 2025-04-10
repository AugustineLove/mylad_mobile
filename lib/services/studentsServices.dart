import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../provider/parentProvider.dart';

Future<void> fetchAndStoreStudents(
    BuildContext context, String phoneNumber) async {
  final url = Uri.parse("${baseUrl}parents/verify");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phoneNumber": phoneNumber}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey("students") && data["students"] is List) {
        List<Student> students = (data["students"] as List)
            .map((json) => Student.fromJson(json))
            .toList();

        logger.d("Students being sent to provider: ${students}");

        Provider.of<ParentProvider>(context, listen: false)
            .setStudents(students);
      }
    }
  } catch (e) {
    print("Error fetching students on home init: $e");
  }
}
