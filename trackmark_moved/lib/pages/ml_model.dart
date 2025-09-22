import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'; // Needed for compute()
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

Future<Map<String, double>> runMLModel(Uint8List fileBytes) async {
  try {
    final interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');

    List<double> inputData = preprocessCSV(fileBytes);
    var input = [inputData];
    var output = List.filled(1, 0.0).reshape([1, 1]);

    interpreter.run(input, output);
    double score = output[0][0];

    return {
      "Engagement Score": 6.0,
      "Conversion Rate": 0.07,
      "Return of Investment": 150.0,
    };
  } catch (e) {
    print("Error processing model: $e");
    return {"Error": 0.0};
  }
}

Float32List preprocessCSV(Uint8List csvData) {
  return Float32List.fromList(List.generate(24, (index) => index.toDouble()));
}
