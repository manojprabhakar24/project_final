import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../AdminPanel/Responsive/desktop.dart';
import '../AdminPanel/Responsive/mobile.dart';
import '../AdminPanel/Responsive/responsive_layout.dart';
import '../AdminPanel/Responsive/tablet.dart';

import 'forget_password.dart';


class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  State<EmailLogin> createState() => _EmailLoginState();
  void navigateToEmailLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>EmailLogin()));
  }
}

class _EmailLoginState extends State<EmailLogin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String assetsPath = "assets/Scissors-image-remove.png";
    Color assetsColor = Colors.white;
    return Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/first.jpg", // Replace with your image asset path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child:ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          assetsColor,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          assetsPath,
                          width: 100.0, // Adjust the width as needed
                          height: 100.0, // Adjust the height as needed
                        ),
                      ) ,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'SCISSOR\'S ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child:Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autofocus: false,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email,color: Colors.red,),
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 20,color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        obscureText: true,
                        autofocus: false,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password,color: Colors.white,),
                            suffixIcon: Icon(Icons.visibility,color: Colors.white,),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 20,color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                    .then((value) {
                                  Navigator.push(
                                      context,MaterialPageRoute(
                                      builder: (context)=>ResponsiveLayout(
                                        mobileBody: MobileScaffold(),
                                        tabletBody: TabletScaffold(),
                                        desktopBody: DesktopScaffold(),
                                      ))
                                  );
                                  Fluttertoast.showToast(
                                      msg: "Sign in successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.blueGrey,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }).onError((error, stackTrace) {
                                  print("Error: ${error.toString()}");
                                });
                              },
                              child: const Text("Login",
                                  style: TextStyle(fontSize: 18.0,color: Colors.black))),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ResetPassword()));
                            },
                            child: const Text(
                              'Forget Password ?',
                              style: TextStyle(fontSize: 14,color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
