import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnverifiedPage extends StatefulWidget {
  final String title;

  const UnverifiedPage({super.key, required this.title});

  @override
  _UnverifiedPageState createState() => _UnverifiedPageState();
}

class _UnverifiedPageState extends State<UnverifiedPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  // Function to handle the API call
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String? referralCode = _referralController.text.isNotEmpty
          ? _referralController.text // Use the entered referral code
          : null; // If not entered, set referralCode to null

      // Constructing the request body
      final Map<String, dynamic> requestBody = {
        "email": email, // Use entered email
        "password": password, // Use entered password
        "referralCode": referralCode, // If null, it won't be included in the JSON
        "userId": "62a833766ec5dafd6780fc85" // Assuming userId remains the same
      };

      const String apiUrl = "http://devapiv4.dealsdray.com/api/v2/user/email/referral"; // New API URL

      try {
        // Sending POST request
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        // Check for different response codes
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print("Success: $responseData"); // Handle successful response
          // Show success dialog or move to next screen
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Success"),
              content: Text("Account verified successfully!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        } else if (response.statusCode == 409) {
          print("Error 409: Conflict");
          _showErrorDialog("Conflict: It seems the user or referral code already exists.");
        } else if (response.statusCode == 400) {
          print("Error 400: Bad Request");
          _showErrorDialog("Bad request: Please check your input.");
        } else {
          print("Error: ${response.statusCode}");
          _showErrorDialog("Something went wrong. Please try again later.");
        }
      } catch (e) {
        print("Exception: $e"); // Handle exceptions
        _showErrorDialog("An error occurred. Please check your connection.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Assign form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Let's Begin!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Please enter your credentials to proceed",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Password input field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Create Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Referral Code input field (optional)
              TextFormField(
                controller: _referralController,
                decoration: InputDecoration(
                  labelText: 'Referral Code (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Spacer(), // Pushes the button to the bottom
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm, // Handle form submission
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Rounded button
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
