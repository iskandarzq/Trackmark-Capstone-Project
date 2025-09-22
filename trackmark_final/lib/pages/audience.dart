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
      home: AudiencePage(),
    );
  }
}

class AudiencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Selection
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text("1 month"),
                    selected: true,
                    onSelected: (value) {},
                    selectedColor: Colors.blue,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Viewer Insights
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Viewer Insight",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("Oct 1 - Oct 31",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),

                  // Gender Button
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Gender"),
                  ),
                  const SizedBox(height: 20),

                  // Circular Graph
                  Center(
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: 6.0,
                            child: CircularProgressIndicator(
                              value: 0.72,
                              strokeWidth: 5,
                              backgroundColor: Colors.blue[100],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ),
                          const Text("72%\nMale",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Age Button
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Age"),
                  ),
                  const SizedBox(height: 10),

                  // Age Distribution
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
