import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myladmobile/views/home_page.dart';
import 'package:myladmobile/views/verify_number.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('user'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          var box = Hive.box('user');
          final phoneNumber = box.get('phoneNumber');
          final isVerified = box.get('isVerified', defaultValue: false);

          if (phoneNumber != null && isVerified == true) {
            return const HomePage(); // Assuming HomePage is already implemented
          } else {
            return const VerifyNumber(); // Takes user to enter phone number
          }
        }
      },
    );
  }
}
