import 'package:flutter/material.dart';

class ManageAccountPage extends StatefulWidget {
  final String name;

  const ManageAccountPage({super.key, required this.name});

  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blue Background Extends Lower
          Container(
            height: 270, // Increased height to stop above "Name"
            color: Colors.blue,
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom App Bar with Centered Title
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Text(
                        "Manage Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Profile Picture
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('images/profile.png'),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 2),

              // Name Below Profile Picture (Now Fully Visible)
              Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30), // Move white section lower

              // White Section Starts Below Name
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Name", _nameController),
                      _buildTextField("Phone Number"),
                      _buildTextField("Email"),
                      _buildTextField("Password"),
                      _buildTextField("Organization"),

                      const SizedBox(height: 16),

                      // Update Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, _nameController.text);
                          },
                          child: const Text("Update Profile", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Text Field Builder
  Widget _buildTextField(String label, [TextEditingController? controller]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}