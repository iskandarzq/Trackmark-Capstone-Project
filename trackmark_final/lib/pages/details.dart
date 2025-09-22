import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recommendation.dart'; // Ensure AnalyticsScreen is properly imported

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Map<String, dynamic>> processedData = [];

  @override
  void initState() {
    super.initState();
    _loadProcessedData();
  }

  Future<void> _loadProcessedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedProcessedData = prefs.getStringList('processedData');

    setState(() {
      processedData = savedProcessedData != null
          ? savedProcessedData.map((item) => jsonDecode(item) as Map<String, dynamic>).toList()
          : [];
    });
  }

  void _navigateToAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyticsScreen(processedData: processedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Details',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tap to view analytics button
            GestureDetector(
              onTap: _navigateToAnalytics,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bar_chart, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text(
                          'Tap to view more analytics',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Target Demographic
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Main Target Demographic',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    _buildSummaryText('Men: 72%', Colors.blue,
                        fontWeight: FontWeight.bold),
                    _buildSummaryText('Women: 28%', Colors.blue,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Average Performance Metrics
            _buildSummaryCard('Average Performance Metrics', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryText('1440', Colors.white,
                      fontSize: 24, fontWeight: FontWeight.bold),
                  _buildSummaryText('970', Colors.white,
                      fontSize: 24, fontWeight: FontWeight.bold),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryText('Clicks', Colors.white, fontSize: 14),
                  _buildSummaryText('Impressions', Colors.white, fontSize: 14),
                ],
              ),
            ], bgColor: Colors.blue),

            const SizedBox(height: 20),

            // Average Budget Spend
            _buildSummaryCard('Average Budgets', [
              _buildSummaryText('RM 1050.00', Colors.white,
                  fontSize: 20, fontWeight: FontWeight.bold),
            ], bgGradient: const LinearGradient(colors: [Colors.black, Colors.grey])),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> children,
      {Color? bgColor, LinearGradient? bgGradient}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.grey[300],
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryText(String text, Color color,
      {double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return Text(text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight));
  }
}