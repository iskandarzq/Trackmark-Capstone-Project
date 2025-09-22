import 'package:flutter/material.dart';

import 'faq_page.dart';
import 'manage_account.dart';
import 'privacy_policy.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes default back arrow
        backgroundColor: Colors.blue, // Blue AppBar
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            "< Back",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Profile Photo Section
          Container(
            color: Colors.blue,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30), // Adjusted padding
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage('images/profile.png'), // Ensure the image path is correct
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Buttons Section
          _buildProfileButton(context, 'Manage Profile', Icons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageAccountPage()),
            );
          }),
          _buildProfileButton(context, 'Settings', Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }),
          _buildProfileButton(context, 'FAQ', Icons.help_outline, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQPage()),
            );
          }),
          _buildProfileButton(context, 'Privacy Policy', Icons.privacy_tip, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
            );
          }),
        ],
      ),
    );
  }

  // Function to create buttons
  Widget _buildProfileButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spreads elements apart
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 15), // Space between icon and text
                Text(title, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.blue, size: 24), // Larger blue '>' icon
          ],
        ),
      ),
    );
  }
}
