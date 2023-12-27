import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'AdminPanel/Responsive/desktop.dart';
import 'AdminPanel/Responsive/mobile.dart';
import 'AdminPanel/Responsive/responsive_layout.dart';
import 'AdminPanel/Responsive/tablet.dart';
import 'Screens/LandingScreen/user.dart';

import 'SplashScreen/splash.dart';
import 'models/firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAdminView = false; // Track the view mode (User/Admin)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(


        body: CustomSplashScreen(),


      ),

    );}
}