import 'package:flutter/material.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class FeeToPay extends StatefulWidget {
  final String studentName;
  const FeeToPay({super.key, required this.studentName});

  @override
  State<FeeToPay> createState() => _FeeToPayState();
}

class _FeeToPayState extends State<FeeToPay> {
  List<Fee> unpaidFees = [];
  Fee? selectedFee;
  TextEditingController amountController = TextEditingController();

  void fetchUnpaidFees() {
    final parentProvider = Provider.of<ParentProvider>(context, listen: false);
    final students = parentProvider.students;

    final selectedStudent = students.firstWhere(
      (student) => student.studentFirstName == widget.studentName,
      orElse: () => Student(
        studentId: '',
        studentSurname: '',
        studentClassName: '',
        schoolName: '',
        studentAddress: '',
        studentParentFirstName: '',
        studentParentSurname: '',
        studentParentNumber: '',
        studentFirstName: '',
        fees: [],
      ),
    );

    unpaidFees = selectedStudent.fees.where((fee) => fee.amount > 0).toList();
    logger.d("Unpaid fees: $unpaidFees");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUnpaidFees();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void payFees() async {
    logger.d('Initializing......');
    if (selectedFee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a fee to pay.")),
      );
      return;
    }

    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the amount to pay.")),
      );
      return;
    }

    final double amount = double.tryParse(amountController.text) ?? 0;
    logger.d(amount);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount.")),
      );
      return;
    }

    // dummy email — replace with parent's email from provider if available
    final email = "parent@example.com";
    final studentId = "abc123"; // replace with actual studentId
    final feeType = selectedFee!.feeType;

    final url = Uri.parse('${baseUrl}paystack/initialize');

    final body = jsonEncode({
      "email": email,
      "amount": amount, 
      "studentId": studentId,
      "feeType": feeType,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        final authUrl = data['data']['authorization_url'];
        final reference = data['data']['reference'];

        // ✅ Launch Paystack checkout page in browser
        if (await canLaunchUrl(Uri.parse(authUrl))) {
          await _launchUrl("${Uri.parse(authUrl)}");
        } else {
          throw 'Could not launch Paystack URL';
        }

        // Optionally store reference to verify later
        print("Payment reference: $reference");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to initiate payment: ${data}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      appBar: AppBar(
        title: MyTexts().regularText("Select Fee to Pay"),
        backgroundColor: AppColors().whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTexts().regularText(
              "You have selected to pay for ${widget.studentName}",
            ),
            const SizedBox(height: 16),

            // Dropdown for unpaid fees
            DropdownButton<Fee>(
              dropdownColor: AppColors().whiteColor,
              value: selectedFee,
              hint: MyTexts().regularText("Select a fee to pay"),
              isExpanded: true,
              onChanged: (Fee? newValue) {
                setState(() {
                  selectedFee = newValue;
                });
              },
              items: unpaidFees.map((fee) {
                return DropdownMenuItem<Fee>(
                  value: fee,
                  child: MyTexts().regularText("${fee.feeType}"),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Amount field
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                labelText: 'Amount to Pay (GHS)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: payFees,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: MyTexts().regularText("Proceed to Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
