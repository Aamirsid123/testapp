import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'verification_page.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneController = TextEditingController();
  bool isPhoneSelected = true; // Tracks which tab is selected

  void _submitPhoneNumber() async {
    String phoneNumber = _phoneController.text.trim();
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = "";
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? '';
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
     }

    // Regular expression to validate phone number (adjust it based on your country's phone format)
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$'); // For a 10-digit phone number

    if (phoneNumber.isNotEmpty && phoneRegex.hasMatch(phoneNumber)) {
      // If phone number is valid, make a POST request to the OTP API
      try {
        // Define the API endpoint
        var url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp');

        // Define the JSON body to send in the POST request
        var requestBody = jsonEncode({
          "mobileNumber": '9011470243',
          "deviceId": '62b341aeb0ab5ebe28a758a3',
        });

        // Send POST request
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json', // Set content type to JSON
          },
          body: requestBody,
        );

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Parse the response if necessary
          var responseData = jsonDecode(response.body);
          print('Successfully send details  ${response.statusCode}');
          // Handle success (e.g., navigate to OTP verification screen)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                phoneNumber: phoneNumber,
              ),
            ),
          );
        } else {
          // Handle error if the response was not successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP. Please try again.')),
          );
        }
      } catch (e) {
        // Handle any errors that occur during the request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
    } else {
      // Show an error message if the phone number is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab selector (Phone or Email)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Phone'),
                  selected: isPhoneSelected,
                  onSelected: (selected) {
                    setState(() {
                      isPhoneSelected = true;
                    });
                  },
                  selectedColor: Colors.redAccent,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Email'),
                  selected: !isPhoneSelected,
                  onSelected: (selected) {
                    setState(() {
                      isPhoneSelected = false;
                    });
                  },
                  selectedColor: Colors.redAccent,
                  backgroundColor: Colors.grey.shade200,
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Glad to see you!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              isPhoneSelected
                  ? 'Please provide your phone number'
                  : 'Please provide your email address',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Input field for phone or email
            TextField(
              controller: _phoneController,
              keyboardType: isPhoneSelected
                  ? TextInputType.phone
                  : TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: isPhoneSelected ? 'Phone' : 'Email',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            // "Send Code" button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'SEND CODE',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
