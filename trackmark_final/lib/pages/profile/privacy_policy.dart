import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  // Manage the expanded state of each section
  Map<String, bool> expandedItems = {
    "What personal data do we collect?": false,
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
    switch (title) {
      case "What personal data do we collect?":
        return "TrackMark collects your name, email address, phone number, location, contacts, device information, but it does not capture private company data.";
      case "What we do with the personal data collected?":
        return "The personal data collected is used to provide and improve our services, communicate with you, and ensure the security of our platform. We may also use the data for research and analysis to enhance user experience.";
      case "When do we disclose personal information?":
        return "We may disclose personal information to third parties only when it is necessary to provide our services, comply with legal obligations, or protect our rights and interests. We ensure that any third parties we share data with adhere to strict data protection standards.";
      case "Security":
        return "We implement robust security measures to protect your personal data from unauthorized access, disclosure, alteration, or destruction. Our security practices include encryption, access controls, and regular security audits.";
      default:
        return "";
    }
  }
}