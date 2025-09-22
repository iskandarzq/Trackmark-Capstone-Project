import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Needed for compute()
import 'package:flutter/material.dart';
import 'processingpage.dart';

class UploadCSV extends StatefulWidget {
  @override
  _UploadCSVState createState() => _UploadCSVState();
}

class _UploadCSVState extends State<UploadCSV> {
  String? fileName;
  Uint8List? fileBytes;
  bool isProcessing = false;

  Future<void> pickCSVFile() async {
    setState(() {
      isProcessing = true; // Show loading indicator
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      fileName = result.files.single.name;
      String filePath = result.files.single.path!;

      try {
        fileBytes = await compute(readFile, filePath); // ✅ Offload to background thread

        setState(() {
          isProcessing = false;
        });

        print("File selected: $fileName");
        print("File size: ${fileBytes?.length} bytes");

        if (fileBytes != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessingPage(inputData: fileBytes!),
            ),
          );
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload CSV")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickCSVFile,
              child: Text("Browse CSV File"),
            ),
            SizedBox(height: 20),
            fileName != null ? Text("Selected File: $fileName") : Text("No file selected"),
            SizedBox(height: 20),
            if (isProcessing) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ✅ Move file reading to a separate thread
Future<Uint8List> readFile(String filePath) async {
  return await File(filePath).readAsBytes();
}