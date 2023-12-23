import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {

  final String name;
  final String phoneNumber;
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;

  const ConfirmationScreen({
    required this.name,
    required this.phoneNumber,
    required this.selectedDate,
    required this.selectedTimeSlots,});

  String formattedDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

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
            decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.8)),
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
              SizedBox(height: 50),

              Container(
                width: 350,
                height:290,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white54.withOpacity(0.5),
                      spreadRadius: 8,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 2)),
                        Image.asset(
                          'assets/tick.png',
                          width: 85,
                          height: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Booking is Confirmed ",
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Name : $name",
                              style: GoogleFonts.openSans(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Mobile Number : $phoneNumber",
                              style: GoogleFonts.openSans(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black54,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Column(
                          children: [
                            Text(
                              "Scissor's",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
                            ),
                            Icon(
                              Icons.calendar_month_sharp,
                              size: 30,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              'Selected Time Slots: ${selectedTimeSlots.join(",")}',
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Selected Date: ${formattedDate(selectedDate)}',
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5,),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}