import 'package:flutter/material.dart';
import 'dart:async';

import 'package:testapp/screens/main_home_page.dart';
import 'package:testapp/screens/unverified_page.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late String otpCode = '';
  late int _remainingTime = 120;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _verifyOtp() {
    // Handle OTP verification logic
    if (otpCode.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified: $otpCode')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }

  void _redirectToMainHomePage() {
    // Navigate to Main Home Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainHomePage(title: 'verified')),
    );
  }

  void _redirectToUnverifiedPage() {
    // Navigate to Unverified Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UnverifiedPage(title: 'unverified')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'We have sent a unique OTP number to your mobile ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 40,
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          otpCode += value;
                          if (index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                        }
                      },
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              '${_remainingTime ~/ 60}:${_remainingTime % 60}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Resend OTP logic
              },
              child: const Text(
                'SEND AGAIN',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            // "Verified" button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _redirectToMainHomePage, // Redirect to MainHomePage
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'VERIFIED',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // "Unverified" button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _redirectToUnverifiedPage, // Redirect to UnverifiedPage
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'UNVERIFIED',
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
