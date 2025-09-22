import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VerificationScreen(PhoneNumber: '', email: '',),
    );
  }
}


class VerificationScreen extends StatefulWidget {
  final String email;
  final String PhoneNumber;
  const VerificationScreen({required this.PhoneNumber, required this.email, Key? key}) : super(key: key);
  

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(4, (index) => FocusNode());

  void _onKeyPressed(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification Code',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Code sent to ${widget.PhoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _onKeyPressed(value, index),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text('Resend code', style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text('Try other methods here.', style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('Confirm', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 5, backgroundColor: Colors.blue),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.lightBlue),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.blue.shade900),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
