import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnalyticsScreen(),
  ));
}

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Analytics', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tabButton("Recommendation"),
                _tabButton("Overview", selected: true),
                _tabButton("Audience"),
                _tabButton("Budget"),
              ],
            ),
            SizedBox(height: 16),
            _timeToggleButtons(),
            SizedBox(height: 16),
            _metricsCard(),
            SizedBox(height: 16),
            _buildCustomChart(),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, {bool selected = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: selected ? Colors.black : Colors.grey,
      ),
    );
  }

  Widget _timeToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _toggleButton("7 days", selected: true),
        _toggleButton("1 month"),
        _toggleButton("3 months"),
        _toggleButton("6 months"),
        _toggleButton("1 year"),
      ],
    );
  }

  Widget _toggleButton(String text, {bool selected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _metricsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Key Metrics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Oct 18 - Oct 24", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _metricBox("Profile Visits", "12"),
              _metricBox("Click Through Rate", "20"),
              _metricBox("Likes", "56"),
              _metricBox("Comments", "34"),
              _metricBox("Shares", "42", large: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricBox(String title, String value, {bool large = false}) {
    return Container(
      width: large ? 120 : 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCustomChart() {
    return Container(
      height: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: CustomPaint(
        painter: ChartPainter(),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint dotPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    final double spacing = size.width / 6;
    final double maxHeight = size.height - 20;

    final List<Offset> points = [
      Offset(spacing * 1, maxHeight - 20),
      Offset(spacing * 2, maxHeight - 50),
      Offset(spacing * 3, maxHeight - 10),
      Offset(spacing * 4, maxHeight - 40),
      Offset(spacing * 5, maxHeight - 30),
    ];

    // Draw the line
    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw the dots
    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
