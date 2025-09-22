// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProjectScreen(),
    );
  }
}

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<String> projects = ['PROJECT 1'];
  bool deleteMode = false;

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _renameProject(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                setState(() {
                  deleteMode = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _renameProject(int index) {
    TextEditingController controller = TextEditingController(text: projects[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Project'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new project name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  projects[index] = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProject(int index) {
    setState(() {
      projects.removeAt(index);
      deleteMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project successfully deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projects',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  projects[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'The BLiving Analysis',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                              ),
                              child: Text('View Details'),
                            ),
                          ],
                        ),
                      ),
                      if (deleteMode)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => _deleteProject(index),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: 'Upload'),
                BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Details'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
              showUnselectedLabels: true,
            ),
          ],
        ),
      ),
    );
  }
}

  