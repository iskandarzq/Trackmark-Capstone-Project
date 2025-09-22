import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  OtpVerificationScreen({required this.verificationId});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyOTP() async {
    String otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid 6-digit OTP')),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP, try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            SizedBox(height: 200),

            // Title
            Text(
              'Verification Code',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            // Phone Number
            Text.rich(
              TextSpan(
                text: 'Code sent to ',
                children: [
                  TextSpan(
                    text: '+60 1234567890', // Replace dynamically
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 30),

            // OTP Input Field
            Text(
              'Enter your OTP code here',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, letterSpacing: 5),
              maxLength: 6,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Confirm Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            Spacer(),

            // Decorative Bottom Circles
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.blue.shade800, radius: 12),
                    SizedBox(width: 8),
                    CircleAvatar(
                        backgroundColor: Colors.blue.shade600, radius: 8),
                    SizedBox(width: 8),
                    CircleAvatar(
                        backgroundColor: Colors.blue.shade400, radius: 14),
                    SizedBox(width: 8),
                    CircleAvatar(
                        backgroundColor: Colors.blue.shade200, radius: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
