import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../models/service_list.dart';
import '../ConfirmationPage/confirm.dart';

class LoginPage extends StatefulWidget {
  static const String countryCode = '+91';
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;
  final List<Services> selectedServices;
  final double totalAmount;
  final String stylistName;

  const LoginPage({
    Key? key,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.selectedServices,
    required this.totalAmount,
    required this.stylistName,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool _isButtonPressed = false;

  String errorMessage = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController =
      TextEditingController(text: LoginPage.countryCode);
  final TextEditingController otpController = TextEditingController();
  late bool isPhoneNumberEmpty;
  bool _otpSent = false; // Track whether OTP has been sent
  @override
  void initState() {
    super.initState();
    isPhoneNumberEmpty = true;
    phoneNumberController.addListener(() {
      setState(() {
        isPhoneNumberEmpty = phoneNumberController.text.isEmpty;
      });
    });
  }

  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'ACe4cb64943355f783e3126cdbdce9e9ee',
    authToken: '6c21697465541a1885c679242542f328',
    twilioNumber: '+14108461447',
  );

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Validate the phone number field
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Check if the phone number doesn't contain the country code '+91'
    if (!value.startsWith(LoginPage.countryCode)) {
      return 'Please enter a valid phone number with country code ${LoginPage.countryCode}';
    }

    // You can add more complex validation logic here if needed
    return null;
  }

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
    setState(() {
      _otpSent = true;
    });
    try {
      twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: 'Hi $name, your OTP for verification is: $generatedOTP',
      );
      print('OTP sent successfully!');

      // Show OTP verification dialog after sending OTP
    } catch (e) {
      print('Failed to send OTP: $e');
    }
  }

  void verifyOTPInDialog(BuildContext context) {
    String enteredOTP = otpController.text.trim();
    if (enteredOTP == generatedOTP) {
      String enteredName = nameController.text.trim();
      String enteredPhoneNumber = phoneNumberController.text.trim();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            name: enteredName,
            phoneNumber: enteredPhoneNumber,
          ),
        ),
      );
    } else {
      setState(() {
        // Update UI to display incorrect OTP message
        errorMessage = 'Incorrect OTP!';
      });
      print('Incorrect OTP!');
    }
  }


  void showOTPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("OTP Verification"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter 6 digit OTP"),
                  SizedBox(height: 12),
                  Form(
                    key: _formKey1,
                    child: TextFormField(
                      cursorColor: Colors.brown,
                      keyboardType: TextInputType.number,
                      controller: otpController,
                      style: TextStyle(color: Colors.brown),
                      decoration: InputDecoration(
                        labelText: "Enter OTP",
                        labelStyle: TextStyle(color: Colors.brown),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown, width: 1.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown, width: 1.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value!.length != 6) {
                          return "Invalid OTP";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          verifyOTPInDialog(context);
                          _saveData();// Verify the OTP
                        },
                        child: Text('Verify'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((value) {
      // When returning from the dialog, reset _otpSent to false
      setState(() {
        _otpSent = false;
      });
    });
  }


  void _saveData() {
    String text1 = nameController.text; // Use the validated name
    String text2 = phoneNumberController.text; // Use the validated phone number

    Timestamp timestamp = Timestamp.fromDate(widget.selectedDate);
    List<Map<String, dynamic>> servicesList =
        widget.selectedServices.map((service) => service.toMap()).toList();

    FirebaseFirestore.instance.collection('Users').add({
      'name': text1,
      'phoneNumber': text2,
      'selectedDate': timestamp,
      'selectedTimeSlots': widget.selectedTimeSlots,
      'selectedServices': servicesList,
      'totalAmount': widget.totalAmount,
      'stylistName': widget.stylistName,
    }).then((value) {
      print("Data saved successfully!");
    }).catchError((error) {
      print("Failed to save data: $error");
    });
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.7),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30)),
                              Image.asset(
                                'assets/Scissors-image-remove.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 9)),
                                  Text(
                                    "Scissor's",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.brown[900],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter your Details",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.brown[900],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                  child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 430, maxHeight: 279),
                                      // Adjust the maximum width as needed
                                      child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  TextFormField(
                                                    cursorColor: Colors.brown,
                                                    controller: nameController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Enter your name",
                                                      labelStyle:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                            color: Colors
                                                                .brown[900],
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .brown,
                                                                width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .brown,
                                                                width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please enter your name";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(height: 20.0),
                                                  TextFormField(
                                                    cursorColor: Colors.brown,
                                                    controller:
                                                        phoneNumberController,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Enter your mobile number",
                                                      labelStyle:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color:
                                                              Colors.brown[900],
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.brown,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.brown,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    validator:
                                                        validatePhoneNumber,
                                                  ),
                                                  SizedBox(height: 20.0),
                                              SizedBox(
                                                height: 50,
                                                width: 150,
                                                child:
                                                  ElevatedButton(
                                                    onPressed:
                                                        isPhoneNumberEmpty
                                                            ? null
                                                            : () {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  sendOTP();
                                                                  showOTPDialog(
                                                                      context);
                                                                }
                                                              },
                                                    child: Text(
                                                      "Send OTP",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      maximumSize:
                                                          Size(200, 200),
                                                      primary: _isButtonPressed
                                                          ? Colors.brown[400]
                                                          : Colors.brown[900],
                                                      onPrimary: Colors.black,
                                                      minimumSize: Size(0, 10),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 20),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                  )
                                              )],
                                              ),
                                            ),
                                          ))))
                            ]))
                  ])))
    ]));
  }
}
