import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/home_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyOTP() async {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the code sent to you")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("${baseUrl}otp/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": widget.phoneNumber,
          "code": otpController.text.trim(),
        }),
      );

      setState(() => isLoading = false);

      print("Response body: ${response.body}");
      logger.d("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['message'] == 'Successful') {
          var box = await Hive.openBox('user');
          await box.put('phoneNumber', widget.phoneNumber);
          await box.put('isVerified', true);

          logger.d("Stored user info: ${box.toMap()}");

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid OTP. Please try again.")),
          );
        }
      } else {
        print("Error Status Code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred. Please try again.")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColors();

    return Scaffold(
      backgroundColor: colorScheme.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  "assets/otp.png",
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Verify Your Phone Number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the OTP sent to ${widget.phoneNumber}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: "OTP Code",
                  hintText: "Enter 6-digit code",
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: verifyOTP,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors().whiteColor,
                          backgroundColor: colorScheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: MyTexts().titleText("Verify OTP"),
                      ),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // You can add resend OTP logic here
                },
                child: MyTexts().regularText(
                  "Didn't receive the code? Resend",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
