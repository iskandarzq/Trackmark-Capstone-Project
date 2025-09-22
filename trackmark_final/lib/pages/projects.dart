import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recommendation.dart'; // Ensure AnalyticsScreen is properly imported

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedProjects = prefs.getStringList('projects') ?? [];

    setState(() {
      projects = savedProjects
          .map((proj) => Map<String, dynamic>.from(jsonDecode(proj)))
          .toList();

      // Check if processedData exists in any project
      for (var project in projects) {
        if (!project.containsKey('processedData')) {
          project['processedData'] = []; // Ensure processedData is initialized
        } else {
          // Ensure processedData is decoded correctly
          project['processedData'] = (project['processedData'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
      }
    });
  }

  Future<void> _renameProject(int index) async {
    TextEditingController controller =
        TextEditingController(text: projects[index]["name"]);

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
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            TextButton(
              onPressed: () async {
                setState(() {
                  projects[index]["name"] = controller.text;
                });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> updatedProjects =
                    projects.map((proj) => jsonEncode(proj)).toList();
                await prefs.setStringList('projects', updatedProjects);

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProject(int index) async {
    setState(() {
      projects.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedProjects =
        projects.map((proj) => jsonEncode(proj)).toList();
    await prefs.setStringList('projects', updatedProjects);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project deleted')),
    );
  }

  void _navigateToAnalytics(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedProcessedData = prefs.getStringList('processedData');

    List<Map<String, dynamic>> processedData = savedProcessedData != null
        ? savedProcessedData.map((item) => jsonDecode(item) as Map<String, dynamic>).toList()
        : [];

    if (processedData.isEmpty) {
      print("No processed data found for project at index $index");
    } else {
      print("Navigating with processedData: ${processedData.length} items");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AnalyticsScreen(processedData: processedData), // Pass processedData
      ),
    );
  }

  void _showProjectOptions(int index) {
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
                _renameProject(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                _deleteProject(index);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
      ),
      body: projects.isEmpty
          ? Center(child: Text('No projects available'))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(projects[index]["name"] ?? ""),
                    subtitle: Text(projects[index]["description"] ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () => _showProjectOptions(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward, color: Colors.blue),
                          onPressed: () => _navigateToAnalytics(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}