import 'package:flutter/material.dart';

import 'Signin.dart'; // Import the SignInP page
void main() {
  runApp(Trackmark());
}

class Trackmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage3(),
    );
  }
}

class WelcomePage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5E9BCC),
      appBar: AppBar(
        backgroundColor: Color(0xFF5E9BCC),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset('images/icon2.png', width: 350),
              ),
            ),
          ),

          SizedBox(height: 70),

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF5E9BCC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Performance Insight',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Identify trends quickly and focus on areas of interest.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildArrowButton(Icons.arrow_back, () {
                        Navigator.pop(context);
                      }),
                      _buildArrowButton(Icons.arrow_forward, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInP()),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
