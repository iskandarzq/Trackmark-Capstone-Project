import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> processedData;

  OverviewScreen({required this.processedData});

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  String selectedCampaign = "Hashtag Challenge"; // Default selection
  Map<String, dynamic> metrics = {};

  @override
  void initState() {
    super.initState();
    _updateMetrics();
  }

  void _updateMetrics() {
    List<Map<String, dynamic>> filteredData = widget.processedData
        .where((data) => data["Campaign Type"] == selectedCampaign)
        .toList();

    int dataCount = filteredData.isNotEmpty ? filteredData.length : 1;

    setState(() {
      metrics = {
        "avgImpressions": filteredData.fold(0.0, (sum, data) => sum + _convertToDouble(data['Impressions'])) / dataCount,
        "avgClicks": filteredData.fold(0.0, (sum, data) => sum + _convertToDouble(data['Clicks'])) / dataCount,
        "avgLikes": filteredData.fold(0.0, (sum, data) => sum + _convertToDouble(data['Likes (Avg)'])) / dataCount,
        "avgComments": filteredData.fold(0.0, (sum, data) => sum + _convertToDouble(data['Comments (Avg)'])) / dataCount,
        "avgShares": filteredData.fold(0.0, (sum, data) => sum + _convertToDouble(data['Shares (Avg)'])) / dataCount,
      };
    });
  }

  double _convertToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0), // Move everything higher
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _campaignDropdown(), // Dropdown placed higher
            SizedBox(height: 24), // Space before metrics card
            _metricsCard(), // Static sized card
          ],
        ),
      ),
    );
  }

  Widget _campaignDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
      ),
      child: DropdownButton<String>(
        value: selectedCampaign,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedCampaign = newValue;
              _updateMetrics();
            });
          }
        },
        underline: SizedBox(), // Remove default line
        items: widget.processedData
            .map((data) => data["Campaign Type"])
            .toSet()
            .map<DropdownMenuItem<String>>((campaign) {
          return DropdownMenuItem<String>(
            value: campaign,
            child: Text(campaign),
          );
        }).toList(),
      ),
    );
  }

  Widget _metricsCard() {
    return Container(
      width: double.infinity,
      height: 345, // Fixed height to prevent resizing
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 93, 144, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Key Metrics for $selectedCampaign",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _metricBox("Impressions (Avg)", metrics["avgImpressions"]?.toStringAsFixed(0) ?? "N/A"),
                _metricBox("Clicks (Avg)", metrics["avgClicks"]?.toStringAsFixed(0) ?? "N/A"),
                _metricBox("Likes (Avg)", metrics["avgLikes"]?.toStringAsFixed(0) ?? "N/A"),
                _metricBox("Comments (Avg)", metrics["avgComments"]?.toStringAsFixed(0) ?? "N/A"),
                _metricBox("Shares (Avg)", metrics["avgShares"]?.toStringAsFixed(0) ?? "N/A", large: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricBox(String title, String value, {bool large = false}) {
    return Container(
      width: large ? 140 : 120,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.black)), // Changed color to black
        ],
      ),
    );
  }
}