

// Future<void> sendOTP() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);
//     final url = Uri.parse("http://192.168.227.29:3000/api/otp/send-otp");

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "phoneNumber": phoneController.text.trim(),
//         }),
//       );

//       setState(() => isLoading = false);

//       if (response.statusCode == 200) {
//         Navigator.of(context).push(
//           CupertinoPageRoute(
//             builder: (context) => OTPVerificationScreen(
//               phoneNumber: phoneController.text.trim(),
         
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred. Please try again.")),
//       );
//     }
//   }