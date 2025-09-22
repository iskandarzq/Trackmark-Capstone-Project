import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  final String campaignType;
  final double engagementScore;
  final double conversionRate;
  final double roi;

  AnalyticsPage({
    required this.campaignType,
    required this.engagementScore,
    required this.conversionRate,
    required this.roi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Analytics")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Recommended Campaign Type:"),
            Chip(label: Text(campaignType)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text("Key Performance Indicators", style: TextStyle(color: Colors.white)),
                  Text("Engagement Score: $engagementScore"),
                  Text("Conversion Rate: $conversionRate"),
                  Text("Return on Investment: $roi"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
