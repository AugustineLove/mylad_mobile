import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/hubtel_merchant_checkout_sdk.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';

class HubtelCheckoutPage extends StatefulWidget {
  final Student student;
  final Student parent;
  final String feeType;

  const HubtelCheckoutPage({
    super.key,
    required this.student,
    required this.parent,
    required this.feeType,
  });

  @override
  State<HubtelCheckoutPage> createState() => _HubtelCheckoutPageState();
}

class _HubtelCheckoutPageState extends State<HubtelCheckoutPage> {
  final amountController = TextEditingController();
  String? selectedFeeType;

  final configuration = HubtelCheckoutConfiguration(
    merchantID: "2029967",
    callbackUrl: "https://myward.space/",
    merchantApiKey: "TTFEeHJsQTpjMzliMjgyZGQ1NmY0OWNhYTViNWNlYzExZTYyMTlhNw==",
  );

  final List<String> feeTypes = [
    "Tuition",
    "PTA Dues",
    "Feeding Fee",
    "Boarding Fee",
  ];

  @override
  void initState() {
    super.initState();
    selectedFeeType = widget.feeType;
  }

  @override
  Widget build(BuildContext context) {
    final feeTypes =
        widget.student.fees.map((fee) => fee.feeType).toSet().toList();
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      appBar: AppBar(
        title: const Text("Fee Payment"),
        backgroundColor: AppColors().whiteColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    Icon(Icons.school_rounded,
                        size: 50, color: AppColors().primaryColor),
                    const SizedBox(height: 10),
                    MyTexts().titleText("Pay Fees", fontSize: 22),
                    MyTexts().regularText(
                      "Complete your child’s fee payment securely.",
                      textColor: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Parent & Student Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTexts().regularText(
                      "Parent: ${widget.parent.studentParentFirstName} ${widget.parent.studentParentSurname}",
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    MyTexts().regularText(
                        "Phone: ${widget.parent.studentParentNumber}"),
                    const SizedBox(height: 6),
                    MyTexts().regularText(
                      "Student: ${widget.student.studentFirstName} ${widget.student.studentSurname}",
                    ),
                    const SizedBox(height: 6),
                    MyTexts().regularText(
                        "Class: ${widget.student.studentClassName}"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Fee Type Selection
              MyTexts().regularText("Select Fee Type"),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value:
                    feeTypes.contains(selectedFeeType) ? selectedFeeType : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: feeTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedFeeType = value);
                },
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down_rounded),
              ),

              const SizedBox(height: 20),

              // Amount Input
              MyTexts().regularText("Enter Amount"),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter amount (e.g., 100.00)",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Pay Button
              ElevatedButton.icon(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text.trim());

                  if (selectedFeeType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a fee type.")),
                    );
                    return;
                  } else if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter a valid amount.")),
                    );
                    return;
                  }

                  final purchaseInfo = PurchaseInfo(
                    amount: amount,
                    customerPhoneNumber: widget.parent.studentParentNumber,
                    purchaseDescription:
                        "Payment of $amount from ${widget.parent.studentParentSurname} for ${widget.student.studentFirstName} ${widget.student.studentSurname}'${selectedFeeType!}",
                    clientReference:
                        "TXN-${DateTime.now().millisecondsSinceEpoch}",
                  );

                  final onCheckoutCompleted = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        purchaseInfo: purchaseInfo,
                        configuration: configuration,
                        themeConfig:
                            ThemeConfig(primaryColor: AppColors().primaryColor),
                      ),
                    ),
                  );

                  if (onCheckoutCompleted is CheckoutCompletionStatus) {
                    switch (onCheckoutCompleted.status) {
                      case UnifiedCheckoutPaymentStatus.paymentSuccess:
                        logger.d("✅ Payment successful");
                        break;
                      case UnifiedCheckoutPaymentStatus.paymentFailed:
                        logger.d("❌ Payment failed");
                        break;
                      case UnifiedCheckoutPaymentStatus.userCancelledPayment:
                        logger.d("🚫 User cancelled");
                        break;
                      case UnifiedCheckoutPaymentStatus.pending:
                        logger.d("⏳ Payment is pending");
                        break;
                      case UnifiedCheckoutPaymentStatus.unknown:
                        logger.d("❓ Unknown payment status");
                        break;
                    }
                  }
                },
                icon: const Icon(Icons.payment),
                label: const Text("Proceed to Pay"),
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      AppColors().whiteColor, // <-- Text and icon color
                  backgroundColor: AppColors().primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
