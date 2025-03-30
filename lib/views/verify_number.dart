import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/views/home_page.dart';
import 'package:myladmobile/widget/submit_button.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({super.key});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Function to verify parent number
  // Function to verify parent number

  Future<void> verifyParentNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final url = Uri.parse("http://192.168.227.29:3000/api/parents/verify");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneController.text.trim()}),
      );

      final data = jsonDecode(response.body);
      logger.d("Response Status: ${response.statusCode}");
      logger.d("Full Response Data: ${response.body}");

      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        if (data.containsKey("students") && data["students"] is List) {
          List<Student> students = (data["students"] as List)
              .map((studentJson) => Student.fromJson(studentJson))
              .toList();

          if (students.isNotEmpty) {
            // Store students in Provider
            Provider.of<ParentProvider>(context, listen: false)
                .setStudents(students);

            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (context) => HomePage()));

            // Save Parent Number in SharedPreferences
            // final prefs = await SharedPreferences.getInstance();
            // await prefs.setString("parentNumber", phoneController.text.trim());

            logger.d("Students stored in provider: ${students.length}");
          } else {
            logger.d("No students found for this parent number.");
          }
        } else {
          logger.d("Invalid students data format.");
        }
      } else {
        logger.d("Unexpected response structure.");
      }
    } catch (error) {
      logger.e("Error verifying parent number: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            10.0.vSpace,
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors().strokeColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors().greyColor),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    color: AppColors().strokeColor,
                  ),
                  hintText: "Enter your phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            50.0.vSpace,
            isLoading
                ? CircularProgressIndicator()
                : InkWell(
                    onTap: verifyParentNumber,
                    child: SubmitButton(label: "Verify"),
                  ),
          ],
        ),
      ),
    );
  }
}
