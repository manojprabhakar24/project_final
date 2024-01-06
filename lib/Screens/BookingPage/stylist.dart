import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_final/Screens/BookingPage/stylist1.dart';
import 'package:project_final/models/service_list.dart';

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
  late List<Map<String, dynamic>> stylistData = [];

  @override
  void initState() {
    super.initState();
    fetchStylistData();
  }

  Future<void> fetchStylistData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('stylistProfile').get();
      setState(() {
        stylistData = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
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
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white54.withOpacity(0.9),
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(12,10,10,0),
                          child: Image.asset(
                            'assets/Scissors-image-remove.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 15.0)),
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
                  ],
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView.builder(
                itemCount: stylistData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0), // Adjust the vertical spacing as needed
                    child: StylistCard(
                      stylist: stylistData[index],
                      onSelect: (selectedStylist) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Stylist1(
                              stylistName: selectedStylist['stylistName'] as String? ?? '',
                              stylistImage: selectedStylist['imageLink'] as String? ?? '',
                              selectedServices: widget.selectedServices,
                              totalAmount: widget.totalAmount,
                              expertise: selectedStylist['expertise'] as String? ?? '',
                              stylist: selectedStylist,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
class StylistCard extends StatelessWidget {
  final Map<String, dynamic> stylist;
  final Function(Map<String, dynamic> selectedStylist) onSelect;

  StylistCard({
    required this.stylist,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  stylist['imageLink'] as String? ?? '',
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'Select Stylist', // Tooltip message
                          child: ElevatedButton.icon(
                            onPressed: () {
                              onSelect(stylist);
                            },
                            icon: Icon(Icons.arrow_forward),
                            label: Text(''), // Empty label
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


