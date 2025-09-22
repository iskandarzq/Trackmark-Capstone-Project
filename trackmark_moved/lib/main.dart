import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trackmark/pages/WelcomeP3.dart';

import 'firebase_options.dart'; // Ensure this file exists



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 115, 230, 15),
        ),
        useMaterial3: true,
      ),
      home: WelcomePage3(), // ✅ Now starts on WelcomeP1
    );
  }
}
