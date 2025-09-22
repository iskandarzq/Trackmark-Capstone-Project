import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Signin.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email and Password are required");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print("User registered: ${userCredential.user?.uid}");

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': fullNameController.text,
        'phoneNumber': phoneNumberController.text,
      });

      print("User added to Firestore");

      // Redirect to SignIn page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInP()),
      );
    } catch (e) {
      print('Registration failed: $e');
      Get.snackbar("Registration Error", e.toString());
    }
  }

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
                  // Background Circles
                  Stack(clipBehavior: Clip.none, children: [
                    Positioned(
                      top: 20,
                      left: -40,
                      child: _buildCircleAvatar(55, Colors.blue.shade300),
                    ),
                    Positioned(
                      top: 90,
                      left: 340,
                      child: _buildCircleAvatar(25, Colors.blue.shade100),
                    ),
                    Positioned(
                      top: 90,
                      right: 180,
                      child: _buildCircleAvatar(40, Colors.blue.shade800),
                    ),
                    Positioned(
                      top: 30,
                      right: 80,
                      child: _buildCircleAvatar(35, Colors.blue.shade400),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 220),
                        Image.asset("images/Trackmark.png",
                            height: 220, fit: BoxFit.contain),
                        const SizedBox(height: 20),
                        _buildTextField("Full Name",
                            controller: fullNameController),
                        const SizedBox(height: 15),
                        _buildTextField("Email", controller: emailController),
                        const SizedBox(height: 15),
                        _buildTextField("Phone Number",
                            controller: phoneNumberController),
                        const SizedBox(height: 15),
                        _buildTextField("Password",
                            controller: passwordController, obscureText: true),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Register",
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.bold)),
                            GestureDetector(
                              onTap: () async {
                                await register(context);
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
                      ],
                    ),
                  ]),
                ]),
          ),
        ));
  }

  Widget _buildTextField(String hintText,
      {bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue),
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
