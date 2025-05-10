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
import 'package:myladmobile/views/otp_verification_screen.dart';
import 'package:myladmobile/widget/submit_button.dart';
import 'package:provider/provider.dart';

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
  Timer? _resetTimer;
  String? textNumber;

  @override
  void dispose() {
    _resetTimer?.cancel();
    phoneController.dispose();
    super.dispose();
  }

  List<Student> textStudents = [
    Student(
      studentSurname: 'Augustine Love',
      studentClassName: 'Class 1',
      studentId: '1234567890',
      schoolId: '1234567890',
      studentFirstName: 'Austin',
      schoolName: 'Google Developer School',
      studentAddress: 'Ghana',
      schoolEmail: 'googledeveloperschool@gmail.com',
      studentParentFirstName: "Augustine",
      studentParentSurname: "Love",
      studentParentNumber: "9999999",
      schoolSubAccountCode: "accountcode",
      fees: <Fee>[],
    ),
  ];

  Future<void> verifyParentNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final url = Uri.parse("${baseUrl}parents/verify");

    try {
      if (phoneController.text.trim() == '9999999') {
        Provider.of<ParentProvider>(context, listen: false)
            .setStudents(textStudents);
        sendOTP();
      }
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"phoneNumber": phoneController.text.trim()}),
          )
          .timeout(const Duration(seconds: 20));

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
          } else {
            _showMessage("No students found for this number.");
          }
        } else {
          _showMessage("Invalid response from server.");
        }
      } else {
        setState(() => isRegistered = false);
        _resetTimer = Timer(const Duration(seconds: 8), () {
          if (mounted) setState(() => isRegistered = true);
        });
      }
    } catch (error) {
      _showMessage("An error occurred. Please check your connection.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    if (phoneController.text.trim() == '9999999') {
      textNumber = phoneController.text.trim();
    }
    setState(() => isLoading = true);
    final phoneNumber = phoneController.text.trim();
    final url = Uri.parse("${baseUrl}otp/send-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneNumber}),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => OTPVerificationScreen(
                phoneNumber: phoneNumber, textNumber: textNumber),
          ),
        );
      } else {
        _showMessage("Error: ${response.body}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage("An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/appLogo.png", width: 100),
                            50.0.vSpace,
                            MyTexts()
                                .titleText("Verify Your Number", fontSize: 20),
                            5.0.vSpace,
                            MyTexts().regularText(
                              "Enter the phone number registered with your child's school.",
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              textColor: Colors.grey.shade600,
                            ),
                            30.0.vSpace,
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                controller: phoneController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter your number'
                                        : null,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_android_rounded,
                                      color: AppColors().primaryColor),
                                  hintText: "e.g. 024XXXXXXX",
                                  hintStyle: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.grey.shade400,
                                  ),
                                  filled: true,
                                  fillColor: AppColors().lightGrey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            25.0.vSpace,
                            InkWell(
                              onTap: () {
                                verifyParentNumber();
                              },
                              child: SubmitButton(
                                label: "Verify",
                              ),
                            ),
                            40.0.vSpace,
                            if (!isRegistered)
                              MyTexts().regularText(
                                'Your mobile number is not registered with any account on our platform. Please contact the school of your ward.',
                                textColor: AppColors().redColor,
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
