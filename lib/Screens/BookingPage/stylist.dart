import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_final/Screens/BookingPage/stylist1.dart';
import 'package:project_final/Screens/BookingPage/stylist2.dart';
import 'package:project_final/Screens/BookingPage/stylist3.dart';

import '../../models/service_list.dart';


class MyApp1 extends StatefulWidget {
  final List<Services> selectedServices;
  final double totalAmount;
  final String stylistName; // New parameter
  final String expertise; // New parameter

  MyApp1({
    Key? key,
    required this.selectedServices,
    required this.totalAmount,
    required this.stylistName,
    required this.expertise, required String description,
  }) : super(key: key);

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {

  late List<Map<String, dynamic>> stylistData = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchStylistData();
  }

  Future<void> fetchStylistData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('stylistProfile').get();
      setState(() {
        stylistData = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // ... (other properties)
        body: Container(
          // ... (your existing code)
          child: ListView.builder(
            itemCount: stylistData.length,
            itemBuilder: (context, index) {
              return StylistCard(
                stylist: stylistData[index],
                stylistScreen:  Stylist1 (stylist: stylistData[index], stylistName: '', selectedServices: [], totalAmount: 0,), // Replace with your stylist screen widget
              );

            },
          ),
        ),
      ),
    );
  }
}

class StylistCard extends StatelessWidget {
  final Map<String, dynamic> stylist;
  final Widget stylistScreen;

  StylistCard({
    required this.stylist,
    required this.stylistScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... (your existing code)
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 5, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                stylist['imageLink'] as String? ?? '', // Replace 'imgPth' with your image URL field
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
                    stylist['stylistName'] as String? ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    stylist['expertise'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  // ... (rest of your existing code)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}