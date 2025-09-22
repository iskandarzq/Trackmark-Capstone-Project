import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmark/pages/details.dart';
import 'package:trackmark/pages/profile/profile.dart'; // Import Profile page
import 'package:trackmark/pages/projects.dart';
import 'package:trackmark/pages/uploaddataset.dart'; // Import UploadCSV page
import 'package:trackmark/theme_notifier.dart'; // Import ThemeNotifier

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double top1 = 10;
  double left1 = 10;
  double top2 = 20;
  double right2 = 40;
  double top3 = 5;
  double right3 = 10;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        top1 = top1 == 10 ? 15 : 10;
        left1 = left1 == 10 ? 20 : 10;
        top2 = top2 == 20 ? 30 : 20;
        right2 = right2 == 40 ? 50 : 40;
        top3 = top3 == 5 ? 15 : 5;
        right3 = right3 == 10 ? 20 : 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: themeNotifier.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Circles and Title
            Stack(
              children: [
                Container(height: 100), // Space for the circles
                AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  top: top1,
                  left: left1,
                  child: _buildCircle(90, themeNotifier.isDarkMode ? Colors.grey[800]!.withOpacity(0.9) : Colors.blue[900]!.withOpacity(0.9)),
                ),
                AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  top: top2,
                  right: right2,
                  child: _buildCircle(75, themeNotifier.isDarkMode ? Colors.grey[700]!.withOpacity(0.9) : Colors.lightBlue[200]!.withOpacity(0.9)),
                ),
                AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  top: top3,
                  right: right3,
                  child: _buildCircle(45, themeNotifier.isDarkMode ? Colors.grey[600]!.withOpacity(0.9) : Colors.blue[700]!.withOpacity(0.9)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Image Carousel Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                ),
                items: [
                  'images/quote1.png',
                  'images/quote2.png',
                ].map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 40),

            // Project Button Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: themeNotifier.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.bar_chart, size: 32, color: themeNotifier.isDarkMode ? Colors.white : Colors.black),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to UploadCSV when button is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UploadCSV()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Add New Project",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Bottom Grid Section (Home, Upload, Details, Profile)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildDashboardButton(Icons.grid_view, "Home", context, ProjectScreen()), // Home navigates to ProjectScreen
                  _buildDashboardButton(Icons.cloud_upload, "Upload", context, UploadCSV()), // Upload navigates to UploadCSV
                  _buildDashboardButton(Icons.lightbulb, "Details", context, DetailsScreen()), // Details navigates to DetailsScreen
                  _buildDashboardButton(Icons.person, "Profile", context, ProfilePage()), // Profile navigates to ProfilePage
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method for Building Circle Widgets
  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // Method for Building Dashboard Buttons
  Widget _buildDashboardButton(IconData icon, String label, BuildContext context, Widget? targetPage) {
    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            SizedBox(height: 10),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Dashboard(),
      ),
    ),
  );
}