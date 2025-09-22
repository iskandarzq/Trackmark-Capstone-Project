import 'package:flutter/material.dart';
import 'Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController emailController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInP()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: 20,
                    left: -120,
                    child: _buildCircleAvatar(55, Colors.blue.shade300)),
                Positioned(
                    top: 90,
                    left: 270,
                    child: _buildCircleAvatar(25, Colors.blue.shade100)),
                Positioned(
                    top: 90,
                    right: 130,
                    child: _buildCircleAvatar(40, Colors.blue.shade800)),
                Positioned(
                    top: 30,
                    right: 10,
                    child: _buildCircleAvatar(35, Colors.blue.shade400)),
                Column(
                  children: [
                    const SizedBox(height: 220),
                    Image.asset("images/Trackmark.png",
                        height: 220, fit: BoxFit.contain),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Forgot Password Text
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Instructions
            const Text(
              "Enter the email associated with your account and we’ll send you password email instructions",
              style: TextStyle(fontSize: 19),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),

            // Email Input Field
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await resetPassword(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Return to Sign In
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInP()));
              },
              child: const Text(
                "Return to Sign In",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create background circles with gradient and shadow
  Widget _buildCircleAvatar(double radius, Color color) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
    );
  }
}
