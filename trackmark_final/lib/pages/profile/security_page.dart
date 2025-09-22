import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Security"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Account Security"),
            _buildSecurityItem(context, "Change Password", Icons.lock, () {
              // Navigate to Change Password Page
            }),
            _buildSecurityItem(context, "Two-Factor Authentication", Icons.security, () {
              // Navigate to Two-Factor Authentication Page
            }),
            _buildSecurityItem(context, "Manage Devices", Icons.devices, () {
              // Navigate to Manage Devices Page
            }),
            _buildSecurityItem(context, "Security Questions", Icons.question_answer, () {
              // Navigate to Security Questions Page
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSecurityItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 24),
      onTap: onTap,
    );
  }
}