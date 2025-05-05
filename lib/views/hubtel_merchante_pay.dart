import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/hubtel_merchant_checkout_sdk.dart';
import 'package:myladmobile/utils/constants.dart';

class HubtelCheckoutPage extends StatelessWidget {
  HubtelCheckoutPage({super.key});
  final configuration = HubtelCheckoutConfiguration(
    merchantID: "11624",
    callbackUrl: "https://yourdomain.com/payment-callback",
    merchantApiKey: "Base64EncodedApiKeyHere",
  );

  final purchaseInfo = PurchaseInfo(
    amount: 10.50,
    customerPhoneNumber: "0551234567",
    purchaseDescription: "Purchase of Shoes",
    clientReference: "TXN-${DateTime.now().millisecondsSinceEpoch}",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hubtel Payment')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Pay with Hubtel'),
          onPressed: () async {
            final onCheckoutCompleted = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  purchaseInfo: purchaseInfo,
                  configuration: configuration,
                  themeConfig: ThemeConfig(primaryColor: Colors.blue),
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
        ),
      ),
    );
  }
}
