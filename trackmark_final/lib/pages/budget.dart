import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  final List<Map<String, dynamic>> processedData;

  const BudgetScreen({Key? key, required this.processedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> budgetData = _calculateBudgetDistribution();
    double totalBudget = budgetData.values.fold(0, (sum, item) => sum + item);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "October",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            Text(
              "RM ${totalBudget.toStringAsFixed(0)}",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildBudgetChart(budgetData),
            SizedBox(height: 20),
            _buildLegend(budgetData),
            SizedBox(height: 20),
            _buildBudgetBreakdown(budgetData, totalBudget),
            SizedBox(height: 20),
            _buildRecommendation(totalBudget),
          ],
        ),
      ),
    );
  }

  // Calculate budget distribution per campaign type using "Budget Spend (Avg)"
  Map<String, double> _calculateBudgetDistribution() {
    Map<String, double> budgetMap = {};

    for (var data in processedData) {
      String campaignType = data['Campaign Type'];
      double budget = double.tryParse(data['Budget Spend (Avg)'].toString()) ?? 0.0;
      budgetMap[campaignType] = budget;
    }

    return budgetMap;
  }

  // Pie Chart Widget
  Widget _buildBudgetChart(Map<String, double> budgetData) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: budgetData.entries.map((entry) {
            return PieChartSectionData(
              value: entry.value,
              title: "",
              color: _getColorForCampaign(entry.key),
              radius: 50,
              titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Legend Widget
  Widget _buildLegend(Map<String, double> budgetData) {
    return Column(
      children: budgetData.entries.map((entry) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 16,
              color: _getColorForCampaign(entry.key),
            ),
            SizedBox(width: 8),
            Text(entry.key, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        );
      }).toList(),
    );
  }

  // Budget Breakdown Widget
  Widget _buildBudgetBreakdown(Map<String, double> budgetData, double totalBudget) {
    return Column(
      children: budgetData.entries.map((entry) {
        double percentage = (entry.value / totalBudget) * 100;
        return Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("RM ${entry.value.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${entry.key} (${percentage.toStringAsFixed(0)}%)", style: TextStyle(color: Colors.black54)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Recommendation Widget
  Widget _buildRecommendation(double totalBudget) {
    String recommendation;

    if (totalBudget < 1000) {
      recommendation = "Consider increasing your budget to improve campaign reach.";
    } else if (totalBudget < 5000) {
      recommendation = "Your budget is moderate. Optimize spending for better ROI.";
    } else {
      recommendation = "Great budget allocation! Ensure you track campaign performance.";
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        recommendation,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Assign unique colors to different campaigns
  Color _getColorForCampaign(String campaignType) {
    switch (campaignType) {
      case 'Hashtag Challenge':
        return Colors.blue;
      case 'Influencer Campaign':
        return Colors.red;
      case 'Livestream':
        return Colors.green;
      case 'Paid Ads':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}