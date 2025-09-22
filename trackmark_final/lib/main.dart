import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmark/pages/WelcomeP1.dart';
import 'package:trackmark/theme_notifier.dart'; // Import the ThemeNotifier

import 'firebase_options.dart'; // Ensure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: WelcomeScreen(), // ✅ Now starts on WelcomeP1
        );
      },
    );
  }
}