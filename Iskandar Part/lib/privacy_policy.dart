import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  // Manage the expanded state of each section
  Map<String, bool> expandedItems = {
    "What personal data we collect?": false,
    "What we do with the personal data collected?": false,
    "When do we disclose personal information?": false,
    "Security": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Privacy Policy Sections
            Expanded(
              child: ListView(
                children: expandedItems.keys.map((String title) {
                  return _buildPrivacyItem(title);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each section
  Widget _buildPrivacyItem(String title) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              expandedItems[title]!
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
            onTap: () {
              setState(() {
                expandedItems[title] = !expandedItems[title]!;
              });
            },
          ),
          if (expandedItems[title]!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _getPrivacyContent(title),
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  // Privacy content mapping
  String _getPrivacyContent(String title) {
    if (title == "What personal data we collect?") {
      return "TrackMark collects your name, email address, phone number, location, contacts, device information, usage patterns, and even sensitive data like microphone recordings or camera images.";
    }
    return ""; // Other sections can be filled in later
  }
}
