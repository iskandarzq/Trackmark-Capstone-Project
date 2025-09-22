import 'dart:convert'; // For JSON encoding
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackmark/pages/processingpage.dart';

class UploadCSV extends StatefulWidget {
  @override
  _UploadCSVState createState() => _UploadCSVState();
}

class _UploadCSVState extends State<UploadCSV> {
  String? fileName;
  Uint8List? fileBytes;
  bool isProcessing = false;
  final _formKey = GlobalKey<FormBuilderState>();

  /// Saves the project details to SharedPreferences
  Future<void> saveProject(String name, String description) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> projects = prefs.getStringList('projects') ?? [];

      Map<String, String> projectData = {
        "name": name,
        "description": description,
      };

      projects.add(jsonEncode(projectData));
      await prefs.setStringList('projects', projects);
    } catch (e) {
      print("Error saving project: $e");
    }
  }

  Future<void> pickCSVFile() async {
    setState(() {
      isProcessing = true;
      fileName = null;
      fileBytes = null;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      fileName = result.files.single.name;
      String filePath = result.files.single.path!;

      try {
        fileBytes = await compute(readFile, filePath);
        setState(() {
          isProcessing = false;
        });
      } catch (e) {
        print("Error reading file: $e");
        setState(() {
          isProcessing = false;
        });
      }
    } else {
      print("No file selected.");
      setState(() {
        isProcessing = false;
      });
    }
  }

  void proceedToProcessing() async {
  final formState = _formKey.currentState;
  if (formState != null && formState.validate()) {
    formState.save();
    String? projectName = formState.value["project_name"];
    String? description = formState.value["description"];

    if (projectName != null && projectName.isNotEmpty) {
      await saveProject(projectName, description ?? "");

      if (!mounted) return; // Prevent errors if widget was removed

      // Navigate to ProcessingPage after saving the project
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessingPage(inputData: fileBytes!),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 16),

              // Project Name Field
              FormBuilderTextField(
                name: "project_name",
                decoration: InputDecoration(
                  labelText: "Project Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Project name is required" : null,
              ),
              SizedBox(height: 16),

              // Description Field
              FormBuilderTextField(
                name: "description",
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Upload Box
              GestureDetector(
                onTap: pickCSVFile,
                child: DottedBorderBox(fileName: fileName),
              ),
              SizedBox(height: 16),

              // Loading Indicator
              if (isProcessing) Center(child: CircularProgressIndicator()),

              Spacer(),

              // Proceed Button (Only visible when a file is selected)
              if (fileBytes != null)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: proceedToProcessing,
                    icon: Icon(Icons.arrow_forward),
                    label: Text("Proceed"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                  ),
                ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for dotted border file upload box
class DottedBorderBox extends StatelessWidget {
  final String? fileName;

  const DottedBorderBox({Key? key, this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload, size: 50, color: Colors.blue),
          SizedBox(height: 8),
          Text("Upload Your CSV File"),
          if (fileName != null)
            Text("Selected File: $fileName", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// Reads the file bytes
Future<Uint8List> readFile(String filePath) async {
  return await File(filePath).readAsBytes();
}
