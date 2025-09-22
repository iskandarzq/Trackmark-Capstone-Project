import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'Recommendation.dart'; // Import Analytics Page

class ProcessingPage extends StatefulWidget {
  final Uint8List inputData;

  ProcessingPage({required this.inputData});

  @override
  _ProcessingPageState createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    startProcessing();
  }

  void startProcessing() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (progress >= 1.0) {
          timer.cancel();
          // Navigate to the Analytics Page without passing results
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AnalyticsScreen()),
          );
        } else {
          progress += 0.2; // Increment progress
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Processing Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Processing your data..."),
            SizedBox(height: 20),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}