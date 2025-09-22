import 'package:fl_chart/fl_chart.dart'; // 📊 Import for Bar Chart
import 'package:flutter/material.dart';
import 'package:trackmark/pages/audience.dart';
import 'package:trackmark/pages/budget.dart';

import 'Overview.dart';

class AnalyticsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> processedData;

  AnalyticsScreen({required this.processedData});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.processedData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Analytics")),
        body: Center(child: Text("No data available")),
      );
    }

    // Sort campaigns by performance score (highest first)
    widget.processedData.sort((a, b) => (_convertToDouble(b['Performance Score']) ?? 0).compareTo(_convertToDouble(a['Performance Score']) ?? 0));

    var topCampaign = widget.processedData.first;
    var otherCampaigns = widget.processedData.skip(1).take(3).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Analytics"),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Recommendation"),
              Tab(text: "Overview"),
              Tab(text: "Audience"),
              Tab(text: "Budget"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRecommendationTab(topCampaign, otherCampaigns),
            OverviewScreen(processedData: widget.processedData), // Pass processedData here
            AudiencePage(),
            BudgetScreen(processedData: widget.processedData)
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTab(Map<String, dynamic> topCampaign, List<Map<String, dynamic>> otherCampaigns) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Recommended Campaign Type", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 168, 73),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                topCampaign['Campaign Type'] ?? "N/A",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Performance Score: ${_toStringAsFixed(_convertToDouble(topCampaign['Performance Score']))}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // 📊 KPI Box
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(25, 118, 210, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text("Key Performance Indicators", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildKpiColumn("Conversion Rate", _convertToDouble(topCampaign['Conversion Rate'])),
                      _buildKpiColumn("Clickthrough Rate", _convertToDouble(topCampaign['Clickthrough Rate'])),
                      _buildKpiColumn("CPM", _convertToDouble(topCampaign['CPM'])),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Text("Other Campaigns", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Column(
              children: otherCampaigns.map((campaign) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          campaign['Campaign Type'] ?? "N/A",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _toStringAsFixed(_convertToDouble(campaign['Performance Score'])),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),

            // 📊 Performance Chart
            Text("Campaign Performance Comparison", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            _buildLineChart(widget.processedData),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiColumn(String title, dynamic value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _toStringAsFixed(_convertToDouble(value)),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
        ),
      ],
    );
  }

  String _toStringAsFixed(double? value) {
    if (value != null) {
      return value.toStringAsFixed(2);
    }
    return "N/A";
  }

  double? _convertToDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      value = value.replaceAll('%', '').trim();
      return double.tryParse(value);
    }
    return null;
  }

  Widget _buildLineChart(List<Map<String, dynamic>> campaigns) {
    // Get unique campaign types
    List<String> uniqueCampaignTypes = campaigns.map((campaign) => campaign['Campaign Type'] ?? "").toSet().toList().cast<String>();

    return SizedBox(
      width: 300, // Square size
      height: 300, // Square size
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (uniqueCampaignTypes.length - 1).toDouble(),
          minY: 0,
          maxY: 1.0,
          lineBarsData: [
            LineChartBarData(
              spots: campaigns.map((campaign) {
                int index = uniqueCampaignTypes.indexOf(campaign['Campaign Type']);
                double score = _convertToDouble(campaign['Performance Score']) ?? 0.0;
                return FlSpot(index.toDouble(), score);
              }).toList(),
              isCurved: true, // Makes the line smoother
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true), // Show data points
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 12));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < uniqueCampaignTypes.length) {
                    String campaignType = uniqueCampaignTypes[index];
                    String abbreviatedName = _abbreviateCampaignName(campaignType);
                    return Transform.rotate(
                      angle: -0.5, // Rotate the text slightly
                      child: Text(
                        abbreviatedName,
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return Text("");
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }

  String _abbreviateCampaignName(String campaignName) {
    switch (campaignName.toLowerCase()) {
      case 'hashtag challenge':
        return 'HC';
      case 'paid ads':
        return 'PA';
      case 'livestream':
        return 'LS';
      case 'influencer campaign':
        return 'IC';
      default:
        return campaignName;
    }
  }
}