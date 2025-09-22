import 'package:flutter/material.dart';

void main() {
  runApp(TrackMarkApp());
}

class TrackMarkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(), // Start from WelcomePage1
    );
  }
}

// Welcome Page 1
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bottom Circles
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircle(Colors.blue[800]!, 100), // Large
                  _buildCircle(Colors.blue[300]!, 30), // Medium
                  _buildCircle(Colors.blue, 50), // Largest
                  _buildCircle(Colors.blue[200]!, 20), // Small
                  _buildCircle(Colors.blue[600]!, 75), // Medium
                ],
              ),
            ),
          ),

          // Main Content
          Center(
            child: Container(
              width: 300,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'TrackMark',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Image.asset(
                    'images/Trackmark.png', // Ensure this image exists in assets
                    width: 300,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Empowering Your Campaign Strategy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 60, vertical: 20), // Increased size
                      backgroundColor: Colors.blue, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Slightly rounded corners
                      ),
                      minimumSize: Size(250,
                          60), // Set a fixed minimum size for width and height
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WelcomePage2()), // Navigates to WelcomePage2
                      );
                    },
                    child: Text(
                      'Get Started', // Button text
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), // Bigger text
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Welcome Page 2
class Trackmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage2(),
    );
  }
}

class WelcomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAEBFC),
      appBar: AppBar(
        backgroundColor: Color(0xFFAAEBFC),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset('images/icon1.png', width: 350),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFAAEBFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Monitor on the move',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'While on the move, keep track of topics, download articles and share them. Every action is synchronized across all devices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildArrowButton(Icons.arrow_back, () {
                      print("Left button pressed");
                    }),
                    _buildArrowButton(Icons.arrow_forward, () {
                      print("Right button pressed");
                    }),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
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
        onPressed: onPressed, // Button does nothing except print a message
      ),
    );
  }
}
