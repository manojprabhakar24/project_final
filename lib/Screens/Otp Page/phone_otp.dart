import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../ConfirmationPage/confirm.dart';



class Service {
  final String name;
  final double price;

  Service({
    required this.name,
    required this.price,
    // Other properties of the Service class can be added here
  });
}

class MyHomePage extends StatefulWidget {
  final DateTime selectedDate;

  final List<String> selectedTimeSlots;
  final List<Service> selectedServices;
  const MyHomePage ({
    Key? key, required this.selectedDate,
    required this.selectedTimeSlots,
    required this.selectedServices,}):
        super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showOTPDialog = false;
  static const String countryCode = '+91';
  String errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController =
  TextEditingController(text: countryCode);
  final TextEditingController otpController = TextEditingController();
  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC45d39b3d898206fef90d4ed67fb4a7bc',
    authToken: '2a51cc575335861d62065ad93ab47a67',
    twilioNumber: '+12816168209',
  );

  String generatedOTP = '';

  String generateOTP() {
    int otpLength = 6;
    String otp = '';
    for (int i = 0; i < otpLength; i++) {
      otp += Random().nextInt(9).toString();
    }
    return otp;
  }


  void sendOTP() {
    String name = nameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    generatedOTP = generateOTP(); // Save the generated OTP

    try {
      twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: 'Hi $name, your OTP for verification is: $generatedOTP',
      );
      print('OTP sent successfully!');

      // Show OTP verification dialog after sending OTP
      showOTPDialog();
    } catch (e) {
      print('Failed to send OTP: $e');
    }
  }

  Future<void> verifyOTPInDialog() async {
    String enteredOTP = otpController.text.trim();
    if (enteredOTP == generatedOTP) {
      String enteredName = nameController.text.trim();
      String enteredPhoneNumber = phoneNumberController.text.trim();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a reference to a collection
      CollectionReference bookings = firestore.collection('bookings');

      try {
        // Add data to Firestore
        await bookings.add({
          'name': enteredName,
          'phoneNumber': enteredPhoneNumber,
          'selectedDate': widget.selectedDate,
          'selectedTimeSlots': widget.selectedTimeSlots,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              name: enteredName,
              phoneNumber: enteredPhoneNumber,
              selectedDate: widget.selectedDate,
              selectedTimeSlots: widget.selectedTimeSlots,
            ),
          ),
        );
      } catch (e) {
        // Handle Firestore errors
        print('Failed to store data in Firestore: $e');
      }
    } else {
      setState(() {
        // Update UI to display incorrect OTP message
        errorMessage = 'Incorrect OTP!';
        _showOTPDialog = false;
      });
      print('Incorrect OTP!');
    }
  }

  void showOTPDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: verifyOTPInDialog,
                child: Text('Verify'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Enter Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        } else if (!value.startsWith('+91')) {
                          return 'Please enter a valid Indian phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, perform actions here
                        sendOTP();
                      }
                    },
                    child: Text('Send OTP'),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}