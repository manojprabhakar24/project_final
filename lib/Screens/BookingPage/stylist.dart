import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_final/Screens/BookingPage/stylist1.dart';
import 'package:project_final/Screens/BookingPage/stylist2.dart';
import 'package:project_final/Screens/BookingPage/stylist3.dart';

import '../../models/service_list.dart';
import '../../models/stylist_data.dart';

class MyApp1 extends StatelessWidget {
  final List<Services> selectedServices;
  final double totalAmount;
  final String stylistName; // New parameter
  final String description; // New parameter

  MyApp1({
    Key? key,
    required this.selectedServices,
    required this.totalAmount,
    required this.stylistName,
    required this.description, required String expertise,
  }) : super(key: key);
  late List<Services> stylist = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white54.withOpacity(0.9),
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration:
            BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.8)),
            child: ListView(
              children: [
                Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 30)),
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
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Hair Stylists',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            StylistCard(
                                stylistData[0],
                                Stylist1(
                                    stylistName: stylistData[0]['stylistName']
                                    as String,
                                    selectedServices:selectedServices,
                                    totalAmount:totalAmount)),
                            StylistCard(
                                stylistData[1],
                                Stylist2(
                                    stylistName: stylistData[1]['stylistName']
                                    as String,
                                    selectedServices:selectedServices,
                                    totalAmount:totalAmount)),
                            StylistCard(
                                stylistData[2],
                                Stylist3(
                                    stylistName: stylistData[2]['stylistName']
                                    as String,
                                    selectedServices:selectedServices,
                                    totalAmount:totalAmount)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StylistCard extends StatelessWidget {
  final Map<String, dynamic> stylist;
  final Widget stylistScreen;

  StylistCard(this.stylist, this.stylistScreen);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: stylist['bgColor'] as Color ?? Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 5, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                stylist['imgPth'] as String,
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    stylist['stylistName'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    stylist['Description'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Color(0xff4E295B),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        stylist['rating'] as String,
                        style: TextStyle(
                          color: Color(0xff4E295B),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => stylistScreen,
                        ),
                      );
                    },
                    color: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Book',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}