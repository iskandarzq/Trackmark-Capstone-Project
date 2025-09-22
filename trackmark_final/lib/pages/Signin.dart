import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Forgotpassword.dart';
import 'PhoneOTP.dart'; // ✅ Import PhoneOTP Page
import 'Signup.dart';

class SignInP extends StatefulWidget {
  SignInP({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<User?> signin() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  State<SignInP> createState() => _SignInPState();
}

class _SignInPState extends State<SignInP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                    child: _buildCircleAvatar(55, Colors.blue.shade300),
                  ),
                  Positioned(
                    top: 90,
                    left: 270,
                    child: _buildCircleAvatar(25, Colors.blue.shade100),
                  ),
                  Positioned(
                    top: 90,
                    right: 130,
                    child: _buildCircleAvatar(40, Colors.blue.shade800),
                  ),
                  Positioned(
                    top: 30,
                    right: 10,
                    child: _buildCircleAvatar(35, Colors.blue.shade400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 220),
                      Image.asset(
                        "images/Trackmark.png",
                        height: 220, // Increased size
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    User? user = await widget.signInWithGoogle();
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneAuthScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Google Sign-In canceled"),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Google Sign-In failed: ${e.toString()}"),
                      ),
                    );
                  }
                },
                icon: Image.asset("images/google_logo.png", height: 24),
                label: const Text("Continue With Google"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey.shade200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Email",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: widget.email,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 10),

              // Don't have an account
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Password Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Password",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: widget.password,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text("Forgot Password?",
                      style: TextStyle(color: Colors.blue, fontSize: 14)),
                ),
              ),

              const SizedBox(height: 30),

              // Sign-In Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.email.text.isEmpty ||
                          widget.password.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter email and password"),
                          ),
                        );
                        return;
                      }
                      try {
                        User? user = await widget.signin();
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneAuthScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Login failed: User is null"),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Login failed: ${e.toString()}"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.deepPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(Icons.arrow_right_alt,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

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

