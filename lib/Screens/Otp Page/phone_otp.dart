import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ConfirmationPage/confirm.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;
  final String stylistName;

  const LoginPage({
    Key? key, required this.selectedDate,
    required this.selectedTimeSlots,
    required this.stylistName,
  }):
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
bool _isButtonPressed = false;
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 200,
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
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
                              'assets/scissors1removebg.png',
                              height: 80,
                              width: 80,
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
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  ),
                                ]
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
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Center(
                              child:Container(

                                constraints: BoxConstraints(maxWidth: 430,maxHeight: 279),
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
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),

                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.brown, width: 1.0
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.brown, width: 1.0),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please enter your name";
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 15),
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
                                                      fontWeight: FontWeight.bold
                                                  ),
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
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.brown, width: 1.0),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
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
                                                    AuthService authService = AuthService();
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
                                                                        if (_formKey1.currentState!.validate()) {
                                                                          AuthService.loginWithOtp(
                                                                            otp: _otpController.text,
                                                                          ).then((value) {
                                                                            if (value == "Success") {
                                                                              authService.saveUserData(
                                                                                name: _nameController.text,
                                                                                phoneNumber: _phoneController.text,
                                                                                selectedDate: widget.selectedDate,
                                                                                selectedTimeSlots: widget.selectedTimeSlots,
                                                                                stylistName: widget.stylistName,
                                                                              );
                                                                              Navigator.pop(context);
                                                                              Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) =>  ConfirmationScreen (
                                                                                    name: _nameController.text,
                                                                                    phoneNumber: _phoneController.text,
                                                                                    selectedDate:widget.selectedDate ,
                                                                                    selectedTimeSlots:widget.selectedTimeSlots,
                                                                                    stylistName: widget.stylistName,
                                                                                  ),
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
                                            )
                                          ]
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }
}