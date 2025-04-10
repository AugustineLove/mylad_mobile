import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
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
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyOTP() async {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the code sent to you")),
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

      // Log the response body for debugging
      print("Response body: ${response.body}");
      logger.d("Response status: ${response.statusCode}");

      // Check if response code is 200
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);

        // Ensure the response message matches "Successful"
        if (responseJson['message'] == 'Successful') {
          var box = await Hive.openBox('user'); // Open the box
          await box.put(
              'phoneNumber', widget.phoneNumber); // Store the phone number
          await box.put(
              'isVerified', true); // Optionally store verification status

          logger.d("Stored user info: ${box.toMap()}");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          // Handle unexpected response message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid OTP. Please try again.")),
          );
        }
      } else {
        // Log the error status code for debugging
        print("Error Status Code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred. Please try again.")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e"); // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
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
            Text(
              "Enter OTP Sent to ${widget.phoneNumber}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: verifyOTP,
                    child: Text("Verify OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
