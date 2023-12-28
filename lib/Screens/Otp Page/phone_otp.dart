

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import '../ConfirmationPage/confirm.dart';
import 'auth_service.dart';


class LoginPage extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;

  const LoginPage({
    Key? key, required this.selectedDate,
    required this.selectedTimeSlots,}):
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isButtonPressed = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);


  }
  void sendMessagesToEnteredNumber() async {
    String phoneNumber = '+91' + _phoneController.text.trim();
    String messageBody =
        'Your scissors saloon appointment is scheduled for  ${widget.selectedDate.toString()} at ${widget.selectedTimeSlots.join(", ")}. Name: ${_nameController.text}, Phone: ${_phoneController.text}';
    sendSMS(messageBody, phoneNumber);
  }

  void sendSMS(String messageBody, String phoneNumber) async {
    final accountSid = 'AC45d39b3d898206fef90d4ed67fb4a7bc'; // Replace with your Twilio Account SID
    final authToken = '2a51cc575335861d62065ad93ab47a67'; // Replace with your Twilio Auth Token
    final twilioNumber = '+12816168209'; // Replace with your Twilio phone number

    final Uri uri = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'From': twilioNumber,
        'To': phoneNumber,
        'Body': messageBody,
      },
    );

    if (response.statusCode == 201) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _saveData(int stylistId) {
    print("Attempting to save data...");
    String text1 = _nameController.text;
    String text2 = _phoneController.text;

    print("Name: $text1");
    print("Phone: $text2");
    setState(() {
      _isButtonPressed = true;
    });

    Timestamp timestamp = Timestamp.fromDate(widget.selectedDate);

    // Replace 'your_stylist_id' with the actual ID of the stylist
    void _saveDataWithStylistId() {
      // Stylist 1 is selected
      _saveData(1);
      // Stylist 2 is selected
       _saveData(2);
      // Stylist 3 is selected
       _saveData(3);
    }




    FirebaseFirestore.instance.collection('userData').add({
      'name': text1,
      'phoneNumber': text2,
      'selectedDate': timestamp,
      'selectedTimeSlots': widget.selectedTimeSlots,
      'stylistId': stylistId,
    }).then((value) {
      print("Data saved successfully!");
      // Once data is saved, enable the button
      setState(() {
        _isButtonPressed = false;
      });
      // After saving data, trigger OTP sending
      sendMessagesToEnteredNumber();
    }).catchError((error) {
      print("Failed to save data: $error");
      // Enable the button on error for retry
      setState(() {
        _isButtonPressed = false;
      });
    });
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        body: Stack(

            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child:Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                  ),
                  // Change the background color her

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                              Image.asset(
                                'assets/Scissors-image-remove.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 9)),
                                    Text("Scissor's",style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.brown[900],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),),
                                  ]),
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
                                child:Container(

                                  constraints: BoxConstraints(maxWidth: 430,maxHeight: 279), // Adjust the maximum width as needed
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                            children: [
                                              TextFormField(
                                                cursorColor: Colors.brown,
                                                controller: _nameController,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText: "Enter your name",
                                                  labelStyle: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                        color: Colors.brown[900],
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold),
                                                  ),

                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.brown, width: 1.0),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.brown, width: 1.0),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  // Adjust horizontal padding
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter your name";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                cursorColor: Colors.brown,
                                                controller: _phoneController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  prefixText: "+91 ",
                                                  labelText: "Enter your mobile  number",
                                                  labelStyle: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                        color: Colors.brown[900],
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.brown, width: 1.0),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.brown, width: 1.0),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  // Change the cursor color here
                                                  // Cursor color when the text field is focused
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.brown, width: 1.0),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  // Change the cursor color
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter your number";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              SizedBox(
                                                height: 50,
                                                width: 150,
                                                child:ElevatedButton(
                                                  onPressed: () {

                                                    setState(() {
                                                      _isButtonPressed = !_isButtonPressed;


                                                    });

                                                    if (_formKey.currentState!.validate()) {
                                                      AuthService.sentOtp(
                                                        phone: _phoneController.text,
                                                        errorStep: () {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Error in sending OTP",
                                                                style:  GoogleFonts.openSans(
                                                                  textStyle: TextStyle(
                                                                    color: Colors.brown[900],
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                              backgroundColor: Colors.red,
                                                            ),
                                                          );
                                                        },
                                                        nextStep: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              title: Text("OTP Verification"),
                                                              content: Column(
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
                                                                      controller: _otpController,
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
                                                                          sendMessagesToEnteredNumber();
                                                                          _saveData(1);  _saveData(2);  _saveData(3);
                                                                          if (_formKey1.currentState!.validate()) {
                                                                            AuthService.loginWithOtp(
                                                                              otp: _otpController.text,
                                                                            ).then((value) {
                                                                              if (value == "Success") {
                                                                                Navigator.pop(context); // Close the OTP verification dialog
                                                                                Navigator.pushReplacement(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) =>  ConfirmationScreen (name: _nameController.text,
                                                                                      phoneNumber: _phoneController.text, selectedDate:widget.selectedDate , selectedTimeSlots:widget.selectedTimeSlots ,), // Navigate to the next page on success
                                                                                  ),
                                                                                );
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(
                                                                                    content: Text(
                                                                                      value,
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                    backgroundColor: Colors.red,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                          "Submit",
                                                                          style: GoogleFonts.openSans(
                                                                            textStyle: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(150, 50),
                                                                          primary: Colors.brown[900],

                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    "Send OTP",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: _isButtonPressed ? Colors.brown[400] : Colors.brown[900],
                                                    onPrimary: Colors.black,
                                                    minimumSize: Size(0, 10),
                                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                ),

                                              )]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),

              ),
            ]
        )
    );
  }
}