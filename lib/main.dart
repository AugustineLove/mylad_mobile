import 'package:flutter/material.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/provider/schoolsProvider.dart';
import 'package:myladmobile/views/search_for_school.dart';
import 'package:myladmobile/views/verify_number.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SchoolProvider()),
        ChangeNotifierProvider(create: (context) => ParentProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VerifyNumber(),
    );
  }
}
