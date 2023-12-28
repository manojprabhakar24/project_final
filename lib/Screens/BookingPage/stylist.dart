import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_final/Screens/BookingPage/stylist1.dart';
import 'package:project_final/Screens/BookingPage/stylist2.dart';
import 'package:project_final/Screens/BookingPage/stylist3.dart';

import '../../models/stylist_data.dart';


class MyApp1 extends StatelessWidget {
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
                                  "assets/Scissors-image-remove.png",
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(padding: EdgeInsets.only(left: 24)),
                              Text(
                                "Scissor's",
                                style: GoogleFonts.openSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ]
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
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold,fontSize: 25),
                            ),
                            StylistCard(stylistData[0], Stylist1()),
                            StylistCard(stylistData[1], Stylist2()),
                            StylistCard(stylistData[2], Stylist3()),
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
  final stylist;
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
        color: stylist['bgColor'] ?? Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 5, bottom: 10), // Adjust padding values as needed
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                stylist['imgPth'],
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10,left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    stylist['stylistName'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    stylist['Description'],
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
                        stylist['rating'],
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
                    child: const Text(
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


