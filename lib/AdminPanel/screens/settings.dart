import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Settings', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
            ]
        ),
      ),
    );
  }
}