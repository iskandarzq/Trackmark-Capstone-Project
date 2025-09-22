import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // ✅ This centers the title!
      ),
      
      body: Column(
        children: [
          _buildSectionTitle("Account"),
          _buildSettingsItem(context, "Security", Icons.lock),
          _buildSettingsItem(context, "Privacy", Icons.shield),
          _buildSettingsItem(context, "Devices", Icons.group),

          _buildSectionTitle("Preferences"),
          _buildSettingsItem(context, "Language", Icons.language, "English"),
          _buildSettingsItem(context, "Notifications", Icons.notifications, "Enabled"),
          _buildSettingsItem(context, "Theme", Icons.brightness_6, "Light"),
          _buildSettingsItem(context, "Text Size", Icons.text_fields, "Moderate"),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle logout logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, [String? value]) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      trailing: value != null 
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: TextStyle(color: Colors.grey[600])),
                const Icon(Icons.chevron_right, size: 24),
              ],
            )
          : const Icon(Icons.chevron_right, size: 24),
      onTap: () {
        // Add navigation to respective pages if needed
      },
    );
  }
}
