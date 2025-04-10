import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/home_page.dart';
import 'package:myladmobile/views/otp_verification_screen.dart';
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
  bool isRegistered = true;

  // Function to verify parent number
  // Function to verify parent number

  Future<void> verifyParentNumber() async {
    logger.d('In the function');
    if (!_formKey.currentState!.validate()) return;

    logger.d("Verifying number.... ");
    setState(() => isLoading = true);

    final url = Uri.parse("${baseUrl}parents/verify");

    try {
      final response = await http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneController.text.trim()}),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw Exception("Connection timeout. Please try again.");
      });

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        if (data.containsKey("students") && data["students"] is List) {
          List<Student> students = (data["students"] as List)
              .map((studentJson) => Student.fromJson(studentJson))
              .toList();

          if (students.isNotEmpty) {
            Provider.of<ParentProvider>(context, listen: false)
                .setStudents(students);
            sendOTP();
            logger.d("Students stored in provider: ${students.length}");
          } else {
            logger.d("No students found.");

            _showMessage("No students found for this number.");
          }
        } else {
          logger.d(
              "Invalid response format. students is not a List or doesn't exist.");
          _showMessage("Invalid response from server.");
        }
      } else {
        logger.d("Unexpected response.");
        setState(() {
          isRegistered = false;
        });
        Timer(Duration(seconds: 8), () {
          setState(() {
            isRegistered = true;
          });
        });
        /* _showMessage("No message found for this phone number"); */
      }
    } catch (error) {
      logger.e("Error verifying parent number: $error");
      _showMessage("An error occurred. Please check your connection.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> sendOTP() async {
    logger.d("Sending OTP.....");
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final phoneNumber = phoneController.text.trim();
    final url = Uri.parse("${baseUrl}otp/send-otp");

    try {
      logger.d("Making POST request to: $url with phoneNumber: $phoneNumber");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneNumber}),
      );

      logger.d("Request completed. Status Code: ${response.statusCode}");

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        logger
            .d("OTP sent successfully. Navigating to OTPVerificationScreen...");

        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) =>
                OTPVerificationScreen(phoneNumber: phoneNumber),
          ),
        );
      } else {
        logger.e("Error Response: ${response.body}");
        _showMessage("Error: ${response.body}");
      }
    } catch (e, stacktrace) {
      setState(() => isLoading = false);
      logger.e("Exception caught: $e");
      logger.e("StackTrace: $stacktrace");
      _showMessage("An error occurred. Please try again.");
    }
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
            Container(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  Image(
                    image: AssetImage("assets/appLogo.png"),
                  ),
                ],
              ),
            ),
            MyTexts().regularText(
                "Enter the mobile number with which your child is registered"),
            10.0.vSpace,
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            20.0.vSpace,
            isLoading
                ? CircularProgressIndicator()
                : InkWell(
                    onTap: verifyParentNumber,
                    child: SubmitButton(label: "Verify"),
                  ),
            40.0.vSpace,
            MyTexts().regularText(
              isRegistered
                  ? ''
                  : 'Your mobile number is not registered with any account on our platform, Please contact the school of your ward.',
              textColor: AppColors().redColor,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
