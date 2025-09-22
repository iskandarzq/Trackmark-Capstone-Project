import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // Manage the expanded state of each FAQ item
  Map<String, bool> expandedItems = {
    "What is TrackMark?": false,
    "How to upload CSV file?": false,
    "How to view account activity & permission?": false,
    "How to change language?": false,
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
          "FAQ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FAQ Sections
            Expanded(
              child: ListView(
                children: expandedItems.keys.map((String title) {
                  return _buildFAQItem(title);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each FAQ item
  Widget _buildFAQItem(String title) {
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
                _getFAQContent(title),
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  // FAQ content mapping
  String _getFAQContent(String title) {
    switch (title) {
      case "What is TrackMark?":
        return "TrackMark is an app that collects, analyzes, and interprets data from marketing campaigns across various channels to assess their effectiveness, identify areas for improvement, and ultimately optimize future campaigns by understanding which strategies are performing well and which are not.";
      case "How to upload CSV file?":
        return "To upload a CSV file, navigate to the 'Upload' section from the dashboard. Click on the 'Upload CSV' button, select the CSV file from your device, and confirm the upload. The data will be processed and analyzed accordingly.";
      case "How to view account activity & permission?":
        return "To view account activity and permissions, go to the 'Account' section in the settings. Here you can see a detailed log of your account activities and manage permissions for different features and integrations.";
      case "How to change language?":
        return "To change the language, go to the 'Settings' section and select 'Language'. Choose your preferred language from the list of available options. The app will update to display content in the selected language.";
      default:
        return "";
    }
  }
}