import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Themes/theme.dart';


import '../Otp Page/phone_otp.dart';




class BookingSlotScreen extends StatefulWidget {
  @override
  _BookingSlotScreenState createState() => _BookingSlotScreenState();
}

class _BookingSlotScreenState extends State<BookingSlotScreen> {

  DateTime selectedDate = DateTime.now();
  Map<String, Color> buttonColors = {
    '10-11AM': Colors.green,
    '2-3PM': Colors.green,
    '6-7PM': Colors.green,
    '11-12PM': Colors.green,
    '3-4PM': Colors.green,
    '7-8PM': Colors.green,
    '12-1PM': Colors.green,
    '4-5PM': Colors.green,
    '8-9PM': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 35.0)),
                  ClipRRect(
                    child: Image.asset(
                      'assets/Scissors-image-remove.png',
                      height: 80,
                      width: 80,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Text(
                    "Scissor's",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Text("CHOOSE YOUR SLOT",
                      style: AppFonts.getSubHeadingStyle()),
                ],
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                height: 380,
                width: 500,
                child: Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 35),
                          backgroundColor: Colors.brown,
                        ),
                        child: Text(
                          'SELECT DATE',
                          style: AppFonts.getDescriptionStyle(),
                        ),
                      ),
                      Expanded(
                        child: HorizontalWeekCalendarPackage(
                          selectedDate: selectedDate,
                          buttonColors: buttonColors,
                          onToggleColor: toggleButtonColor,
                          key: GlobalKey(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void toggleButtonColor(String time) {
    setState(() {
      buttonColors.forEach((key, value) {
        buttonColors[key] = Colors.green;
      });
      buttonColors[time] =
      (buttonColors[time] == Colors.green) ? Colors.red : Colors.green;
    });
  }


}

class HorizontalWeekCalendarPackage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, Color> buttonColors;
  final Function(String) onToggleColor;

  const HorizontalWeekCalendarPackage({
    required Key key,
    required this.selectedDate,
    required this.buttonColors,
    required this.onToggleColor,
  }) : super(key: key);

  @override
  State<HorizontalWeekCalendarPackage> createState() =>
      _HorizontalWeekCalendarPackageState();
}

class _HorizontalWeekCalendarPackageState extends State<HorizontalWeekCalendarPackage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.redAccent,
                  width: 2.0,
                ),
              ),
            ),
            child: Text(
              formattedDate(widget.selectedDate),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "PICK YOUR SLOT",
            style: AppFonts.getSubHeadingStyle(),
          ),
          SizedBox(height: 10),
          buildTimeSlotsColumn(),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              navigateToConfirmationScreen(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.brown),
            child: Text(
                'BOOK YOUR APPOINTMENT',
                style:AppFonts.getDescriptionStyle()
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeSlotsColumn() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTimeSlotColumn([
            '10-11AM',
            '2-3PM',
            '6-7PM',
          ]),
          SizedBox(width: 5),
          buildTimeSlotColumn([
            '11-12PM',
            '3-4PM',
            '7-8PM',
          ]),
          SizedBox(width: 5),
          buildTimeSlotColumn([
            '12-1PM',
            '4-5PM',
            '8-9PM',
          ]),
        ],
      ),
    );
  }

  Widget buildTimeSlotColumn(List<String> timeSlots) {
    return Column(
      children: timeSlots
          .map(
            (time) => Column(
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: widget.buttonColors[time],
                fixedSize: Size(120, 35),
              ),
              onPressed: () {
                widget.onToggleColor(time);
              },
              child: Text(formatTime(time),
                style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      )
          .toList(),
    );
  }

  void navigateToConfirmationScreen(BuildContext context) {
    List<String> selectedTimeSlots = [];

    widget.buttonColors.forEach((key, value) {
      if (value == Colors.red) {
        selectedTimeSlots.add(key);
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          selectedDate: widget.selectedDate,
          selectedTimeSlots: selectedTimeSlots, selectedServices: [],
        ),
      ),
    );
  }

  String formattedDate(DateTime date) {
    return DateFormat.yMMMMd().format(date).replaceAllMapped(RegExp(r'^0*'), (match) => '');
  }
  String formatTime(String time){
    return time.replaceAllMapped(RegExp(r'^0*'), (match) =>'');
  }

}