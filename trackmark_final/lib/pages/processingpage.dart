import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'recommendation.dart' as recommendation;

class ProcessingPage extends StatefulWidget {
  final Uint8List inputData;

  ProcessingPage({required this.inputData});

  @override
  _ProcessingPageState createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  double progress = 0.0;
  List<Map<String, dynamic>>? processedData;
  List<String> codeLines = [];
  int currentLineIndex = 0;
  Interpreter? _interpreter;

  final List<String> allCodeSnippets = [
    "📂 Reading CSV file...",
    "📅 Extracting date features...",
    "🔍 Identifying column headers...",
    "📊 Grouping data by campaign type...",
    "📈 Calculating column averages...",
    "⚙️ Computing performance scores...",
    "🤖 Running TFLite model for predictions...",
    "✅ Processing complete!"
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("✅ TFLite model loaded successfully.");

      if (mounted) {
        startProcessing();
      }
    } catch (e) {
      print("❌ Error loading TFLite model: $e");
    }
  }

  void startProcessing() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        return;
      }

      setState(() {
        progress = (progress + 0.1).clamp(0.0, 1.0);
        if (currentLineIndex < allCodeSnippets.length) {
          codeLines.add(allCodeSnippets[currentLineIndex]);
          currentLineIndex++;
        }
      });
    });

    Future.delayed(Duration(seconds: 5), () async {
      List<Map<String, dynamic>> result = await preprocessCSV(widget.inputData);

      setState(() {
        processedData = result;
        progress = 1.0;
      });

      print("📊 Processed Data: $processedData");

      if (processedData != null && processedData!.isNotEmpty) {
        await saveProcessedData(processedData!);
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    recommendation.AnalyticsScreen(processedData: processedData!),
              ),
            );
          }
        });
      } else {
        print("❌ Error: Processed data is empty, not navigating!");
      }
    });
  }

  Future<void> saveProcessedData(List<Map<String, dynamic>> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedData = data.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('processedData', encodedData);
    print("✅ Processed data saved successfully.");
  }

  Future<List<Map<String, dynamic>>> preprocessCSV(Uint8List inputData) async {
    String csvString = utf8.decode(inputData);
    List<List<dynamic>> csvTable = const CsvToListConverter(eol: "\n").convert(csvString);

    if (csvTable.isEmpty) {
      print("❌ CSV file is empty.");
      return [];
    }

    List<String> headers = csvTable[0].map((e) => e.toString().trim()).toList();
    csvTable.removeAt(0);

    if (csvTable.isEmpty) {
      print("❌ No data rows found in CSV.");
      return [];
    }

    return preprocessData(csvTable, headers);
  }

  Future<List<Map<String, dynamic>>> preprocessData(
      List<List<dynamic>> data, List<String> headers) async {
    if (data.isEmpty) return [];

    List<String> lowerCaseHeaders = headers.map((h) => h.toLowerCase()).toList();
    double epsilon = 1e-6;

    // Identify column indices
    int campaignTypeIndex = lowerCaseHeaders.indexOf("campaign type");
    int dateIndex = lowerCaseHeaders.indexOf("date");
    int clickThroughRateIndex = lowerCaseHeaders.indexOf("clickthrough rate");


    if (campaignTypeIndex == -1 || dateIndex == -1) {
      print("❌ Missing necessary columns.");
      return [];
    }

    // Extract Date Features
    List<String> newHeaders = [...headers, "Year", "Month", "Day", "DayOfWeek", "WeekOfYear", "ElapsedDays"];
    DateFormat dateFormat = DateFormat('M/d/yyyy');

    for (var row in data) {
      DateTime parsedDate;
      try {
        parsedDate = dateFormat.parse(row[dateIndex]);
      } catch (e) {
        print("❌ Error parsing date: ${row[dateIndex]}");
        continue;
      }
      row.add(parsedDate.year);
      row.add(parsedDate.month);
      row.add(parsedDate.day);
      row.add(parsedDate.weekday);
      row.add((parsedDate.difference(DateTime(parsedDate.year, 1, 1)).inDays / 7).ceil());
      row.add(parsedDate.difference(DateTime(2000, 1, 1)).inDays);
    }

    List<int> featureIndices = newHeaders.map((h) => lowerCaseHeaders.indexOf(h.toLowerCase())).toList();

    Map<String, List<List<dynamic>>> campaignGroups = {};
    for (var row in data) {
      String campaignType = row[campaignTypeIndex].toString();
      campaignGroups.putIfAbsent(campaignType, () => []).add(row);
    }

    List<Map<String, dynamic>> campaignResults = [];

    for (var entry in campaignGroups.entries) {
      String campaignType = entry.key;
      List<List<dynamic>> campaignRows = entry.value;

      double avgClickthroughRate = _calculateAverage(campaignRows, clickThroughRateIndex);
      double avgConversionRate = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("conversion rate"));
      double avgCostPerConversion = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("cost per conversion (rm)"));
      double avgCPM = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("cpm (rm)"));
      double avgProfileVisits = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("profile views (tiktok)"));
      double avgLikes = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("likes"));
      double avgComments = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("comments"));
      double avgShares = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("shares"));
      double avgBudgetSpend = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("budget spend"));
      double avgImpressions = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("impressions"));
      double avgClicks = _calculateAverage(campaignRows, lowerCaseHeaders.indexOf("clicks"));


      // Performance Score Calculation
      double performanceScore = (0.4 * avgClickthroughRate) +
          (0.3 * avgConversionRate) +
          (0.15 * (1 / (avgCostPerConversion + epsilon))) +
          (0.15 * (1 / (avgCPM + epsilon)));

      double transformedScore = sqrt(performanceScore);

      List<double> inputFeatures = featureIndices.map((index) {
        return _calculateAverage(campaignRows, index);
      }).toList();

      // Ensure only 24 columns are input into the machine learning model
      if (inputFeatures.length > 24) {
        inputFeatures = inputFeatures.sublist(0, 24);
      }

      double predictedScore = await runModel(inputFeatures);

      campaignResults.add({
        "Campaign Type": campaignType,
        "Performance Score": transformedScore.toStringAsFixed(4),
        "Predicted Score": predictedScore.toStringAsFixed(4),
        "Conversion Rate": avgConversionRate.toStringAsFixed(4),
        "Clickthrough Rate": avgClickthroughRate.toStringAsFixed(4),
        "CPM": avgCPM.toStringAsFixed(4),
        "Profile Visits (Avg)": avgProfileVisits.toStringAsFixed(2),
        "Likes (Avg)": avgLikes.toStringAsFixed(2),
        "Comments (Avg)": avgComments.toStringAsFixed(2),
        "Shares (Avg)": avgShares.toStringAsFixed(2),
        "Budget Spend (Avg)": avgBudgetSpend.toStringAsFixed(2),
        "Impressions": avgImpressions.toStringAsFixed(2),
        "Clicks": avgClicks.toStringAsFixed(2),
      });
    }

    return campaignResults;
  }

  double _calculateAverage(List<List<dynamic>> data, int columnIndex) {
    if (data.isEmpty || columnIndex == -1) return 0.0;

    double sum = 0.0;
    int count = 0;

    for (var row in data) {
      double value = _convertToDouble(row[columnIndex], 0.0);
      sum += value;
      count++;
    }

    return count > 0 ? sum / count : 0.0;
  }

  double _convertToDouble(dynamic value, double defaultValue) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      value = value.replaceAll('%', '').trim();
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  Future<double> runModel(List<double> input) async {
    if (_interpreter == null) {
      print("❌ Error: TFLite interpreter is not initialized.");
      return 0.0;
    }

    if (input.length != 24) {
      print("❌ Error: Model expects 24 features but got ${input.length}.");
      return 0.0;
    }

    try {
      var inputTensor = Float32List.fromList(input).reshape([1, 24]);
      var outputTensor = Float32List(1).reshape([1, 1]); // Adjust the shape to [1, 1]

      _interpreter!.run(inputTensor, outputTensor);

      return outputTensor[0][0]; // Access the first element of the 2D array
    } catch (e) {
      print("❌ Error running TFLite model: $e");
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: codeLines.map((line) => Text(line, style: TextStyle(fontSize: 16))).toList(),
              ),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            SizedBox(height: 10),
            Text("${(progress * 100).toInt()}%", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}