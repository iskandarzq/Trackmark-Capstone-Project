import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showDeleteIcons = false;
  List<String> projects = ['PROJECT 1 - The BLiving Analysis'];

  void toggleDeleteMode() {
    setState(() {
      showDeleteIcons = !showDeleteIcons;
    });
  }

  void deleteProject(int index) {
    setState(() {
      projects.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Project successfully deleted"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: toggleDeleteMode,
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton('Day', true),
              _buildFilterButton('Week', false),
              _buildFilterButton('Month', false),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDate('21 Oct', true),
              _buildDate('22 Oct', false),
              _buildDate('23 Oct', false),
              _buildDate('24 Oct', false),
              _buildDate('25 Oct', false),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                      color: Colors.blue,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          projects[index],
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Text('View Details'),
                        ),
                      ),
                    ),
                    if (showDeleteIcons)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => deleteProject(index),
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 12,
                            child: Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.blue), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_upload, color: Colors.black), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.details, color: Colors.black), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        ),
        onPressed: () {},
        child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _buildDate(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
    );
  }
}