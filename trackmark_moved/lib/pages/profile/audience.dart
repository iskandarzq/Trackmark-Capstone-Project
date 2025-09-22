import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnalyticsPage(),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () {},
          child: const Text("Back", style: TextStyle(color: Colors.blue)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Analytics", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recommendation", style: TextStyle(color: Colors.grey)),
                Text("Overview", style: TextStyle(color: Colors.grey)),
                Text("Audience", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Budget", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: [
                  FilterChip(
                  label: const Text("7 days"),
                  selected: true,
                  onSelected: (value) {},
                  selectedColor: Colors.blue,
                  labelStyle: const TextStyle(color: Colors.white),
                  ),
                const SizedBox(width: 5),
                  ...["1 month", "3 months", "6 months", "1 year"].map((filter) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FilterChip(
                  label: Text(filter),
                  selected: false,
                  onSelected: (value) {},
                  ),
                ))
              ],
            ),
          ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Viewer Insight", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("Oct 18 - Oct 24", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Gender"),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      height: 180, // Increased size
                      width: 180,  // Increased size
                      child: Stack( 
                        alignment: Alignment.center,
                        children: [
                           Transform.scale(
                           scale: 6.0, // Increase this value to make it bigger
                            child: CircularProgressIndicator(
                            value: 0.72,
                            strokeWidth: 5, // Thicker stroke for better visibility
                            backgroundColor: Colors.blue[100],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                          const Text("72%\nMale", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Larger text
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Age"),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      _buildAgeRow("18-24", 1.0),
                      _buildAgeRow("25-34", 0.0),
                      _buildAgeRow("35-44", 0.0),
                      _buildAgeRow("45-54", 0.0),
                      _buildAgeRow("55+", 0.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeRow(String ageGroup, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(ageGroup)),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(width: 50, child: Text("${(percentage * 100).toInt()}%")),
        ],
      ),
    );
  }
}
