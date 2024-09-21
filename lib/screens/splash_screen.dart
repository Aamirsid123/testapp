import 'dart:convert'; // For encoding JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'my_home_page.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Device info package to get device details
import 'dart:io'; // For platform check

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    postDeviceInfo().then((_) {
      // Delay before navigating to the HomePage
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const MyHomePage(title: 'Enter Info Page')),
        );
      });
    });
  }

  // Function to post device information
  Future<void> postDeviceInfo() async {
    final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add');

    // Collect device information
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    String deviceName = '';
    String osVersion = '';

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? '';
      deviceName = androidInfo.model ?? 'Unknown';
      osVersion = androidInfo.version.release ?? '';
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      deviceName = iosInfo.name ?? 'Unknown';
      osVersion = iosInfo.systemVersion ?? '';
    }

    // Static IP address for demo (you can use a package to get actual IP)
    String deviceIPAddress = '11.433.445.66';

    // JSON payload with required data
    final data = {
      "deviceType": Platform.isAndroid ? "android" : "ios",
      "deviceId": deviceId,
      "deviceName": deviceName,
      "deviceOSVersion": osVersion,
      "deviceIPAddress": deviceIPAddress,
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    };

    try {
      // Making the HTTP POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response
        print('Device information posted successfully!');
        print(data);
      } else {
        // If the server returns a failed response
        print('Failed to post device information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error posting device information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Displaying a loading animation
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(), // Loading spinner
            SizedBox(height: 20),
            Text("Loading, please wait..."), // Text below the spinner
          ],
        ),
      ),
    );
  }
}
