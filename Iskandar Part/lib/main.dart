import 'package:flutter/material.dart';
import 'package:flutter_application_twyy/profile.dart';

void main() {
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
      home: const ProfilePage(), // This is the entry point of your app
    );
  }
}
