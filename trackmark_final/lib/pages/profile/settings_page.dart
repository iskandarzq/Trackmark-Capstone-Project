import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme_notifier.dart';
import 'logout_success.dart'; // Import the LogoutSuccessPage
import 'security_page.dart'; // Import the SecurityPage

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = "English"; // Default language

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
          _buildSettingsItem(context, "Security", Icons.lock, null, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecurityPage()),
            );
          }),

          _buildSectionTitle("Preferences"),
          _buildSettingsItem(context, "Language", Icons.language, selectedLanguage, _changeLanguage),
          _buildSettingsItem(context, "Theme", Icons.brightness_6, themeNotifier.isDarkMode ? "Dark" : "Light", themeNotifier.toggleTheme),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to LogoutSuccessPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogoutSuccessPage()),
              );
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

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, [String? value, VoidCallback? onTap]) {
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
      onTap: onTap,
    );
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("English"),
                  onTap: () {
                    setState(() {
                      selectedLanguage = "English";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: const Text("Malay"),
                  onTap: () {
                    setState(() {
                      selectedLanguage = "Malay";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                
              ],
            ),
          ),
        );
      },
    );
  }
}