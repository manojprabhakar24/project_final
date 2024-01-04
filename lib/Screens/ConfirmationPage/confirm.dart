import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmationScreen extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const ConfirmationScreen({
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
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
          ),
          Container(
            decoration:
                BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.8)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 35)),
              Center(
                child: Image.asset(
                  "assets/Scissors-image-remove.png",
                  width: 120,
                  height: 120,
                ),
              ),
              Text(
                "Scissor's",
                style: GoogleFonts.openSans(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "The Booking is Confirmed for $name and +91 $phoneNumber"
                "Please Wait For The Message From Saloon",
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // You can add more widgets for additional details here
            ],
          ),
        ],
      ),
    );
  }
}
