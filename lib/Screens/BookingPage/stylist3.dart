import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Otp Page/phone_otp.dart';




class Stylist3 extends StatefulWidget {

  final String stylistName;

  Stylist3({required this.stylistName});

  @override
  _Stylist3State createState() => _Stylist3State();
}

class _Stylist3State extends State<Stylist3> {
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

  Map<String, DateTime> buttonSelectionTimes = {
    '10-11AM': DateTime.now(),
    '2-3PM': DateTime.now(),
    '6-7PM': DateTime.now(),
    '11-12PM': DateTime.now(),
    '3-4PM': DateTime.now(),
    '7-8PM': DateTime.now(),
    '12-1PM': DateTime.now(),
    '4-5PM': DateTime.now(),
    '8-9PM': DateTime.now(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.8),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 30)),
                  ClipRRect(
                    child: Image.asset(
                      "assets/scissors1removebg.png",
                      height: 80,
                      width: 80,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 30)),
                  Text(
                    "Scissor's",
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: 630,
                    width: 400,
                    child: Card(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Shaving Specialist",
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  // Adjust the radius as needed
                                  child: Image.asset(
                                    "assets/shaving.jpeg",
                                    height: 100,
                                    width: 130,
                                  ),
                                ),
                                Text(
                                  "Stylist: ${widget.stylistName}",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  color: Colors.brown,
                                  thickness: 2,
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "CHOOSE YOUR DATE",
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(150, 35),
                                backgroundColor: Colors.brown,
                              ),
                              child: Text(
                                'SELECT DATE',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: HorizontalWeekCalendarPackage(
                              selectedDate: selectedDate,
                              buttonColors: buttonColors,
                              onToggleColor: toggleButtonColor,
                              stylistName: widget.stylistName,
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
        ),
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

  String selectedTimeSlot = '';

  void toggleButtonColor(String time) {
    DateTime now = DateTime.now();
    if (buttonColors[time] == Colors.red &&
        (now.difference(buttonSelectionTimes[time]!) < Duration(hours: 1) ||
            now.hour < 12)) {
      setState(() {
        buttonColors[time] = Colors.green;
        selectedTimeSlot = '';
      });
    } else {
      setState(() {
        buttonColors[time] = Colors.red;
        if (selectedTimeSlot.isNotEmpty) {
          buttonColors[selectedTimeSlot] = Colors.green;
        }
        buttonSelectionTimes[time] = now;
        selectedTimeSlot = time;
      });
    }
  }
}

class HorizontalWeekCalendarPackage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, Color> buttonColors;
  final Function(String) onToggleColor;
  final String stylistName;

  const HorizontalWeekCalendarPackage({
    required Key key,
    required this.selectedDate,
    required this.buttonColors,
    required this.onToggleColor,
    required this.stylistName,
  }) : super(key: key);

  @override
  State<HorizontalWeekCalendarPackage> createState() =>
      _HorizontalWeekCalendarPackageState();
}

class _HorizontalWeekCalendarPackageState
    extends State<HorizontalWeekCalendarPackage> {
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
            style:
            GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          buildTimeSlotsColumn(),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (hasSelectedSlot()) {
                navigateToConfirmationScreen(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PLEASE SELECT A DATE AND TIME BEFORE BOOKING..'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.brown),
            child: Text(
              'BOOK YOUR APPOINTMENT',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                fixedSize: Size(100, 35),
              ),
              onPressed: () {
                widget.onToggleColor(time);
              },
              child: Text(time),
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
        builder: (context) => LoginPage(
          selectedDate: widget.selectedDate,
          selectedTimeSlots: selectedTimeSlots,
          stylistName: widget.stylistName,
        ),
      ),
    );
  }

  String formattedDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  bool hasSelectedSlot() {
    return widget.buttonColors.containsValue(Colors.red);
  }
}