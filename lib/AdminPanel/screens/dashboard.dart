import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  late Stream<QuerySnapshot> _customersStream;
  int selectedStylist = 0;
  bool showNameAndPhone = false;
  List<Map<String, dynamic>> stylist1Appointments = [];
  List<Map<String, dynamic>> stylist2Appointments = [];
  List<Map<String, dynamic>> stylist3Appointments = [];

  bool showStylist1Appointments = false;
  bool showStylist2Appointments = false;
  bool showStylist3Appointments = false;

  @override
  void initState() {
    super.initState();
    _customersStream =
        FirebaseFirestore.instance.collection('userData').snapshots();
    addStylistIdToAppointments(); // Call the function to add stylistId
  }
// Add this method inside _DashboardState

// Method to refresh the appointments list after deletion


  ButtonStyle getStylistButtonStyle(int stylistId) {
    return selectedStylist == stylistId
        ? ElevatedButton.styleFrom(
      primary: Colors.red, // Change to red when selected
    )
        : ElevatedButton.styleFrom(
      primary: Colors.blue, // Default color for unselected buttons
    );
  }

  // Function to add stylistId to appointments
  void addStylistIdToAppointments() async {
    // Fetch appointments collection
    CollectionReference appointments = FirebaseFirestore.instance.collection(
        'userData');

    // Fetch all documents
    QuerySnapshot querySnapshot = await appointments.get();

    // Update each document with stylistId
    querySnapshot.docs.forEach((doc) {
      appointments.doc(doc.id).update(
          {'stylistId': 1}); // Set stylistId as needed
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Previous code remains unchanged)
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        selectedStylist = 1;
                        showStylist1Appointments = true;
                        showStylist2Appointments =
                        false; // Hide appointments for other stylists
                        showStylist3Appointments = false;
                      });

                      final stylist1Docs = await FirebaseFirestore.instance
                          .collection('userData')
                          .where('stylistId',
                          isEqualTo: 1) // Fetch appointments for Stylist 1
                          .get();

                      setState(() {
                        stylist1Appointments = stylist1Docs.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();
                      });
                    },
                    child: Text('Stylist 1'),
                    style: getStylistButtonStyle(1),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        selectedStylist = 2;
                        showStylist1Appointments = false;
                        showStylist2Appointments = true;
                        showStylist3Appointments = false;
                      });

                      final stylist2Docs = await FirebaseFirestore.instance
                          .collection('userData')
                          .where('stylistId',
                          isEqualTo: 2) // Fetch appointments for Stylist 2
                          .get();

                      setState(() {
                        stylist2Appointments = stylist2Docs.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();
                      });
                    },
                    child: Text('Stylist 2'),
                    style: getStylistButtonStyle(2),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        selectedStylist = 3;
                        showStylist1Appointments = false;
                        showStylist2Appointments = false;
                        showStylist3Appointments = true;
                      });

                      final stylist3Docs = await FirebaseFirestore.instance
                          .collection('userData')
                          .where('stylistId',
                          isEqualTo: 3) // Fetch appointments for Stylist 3
                          .get();

                      setState(() {
                        stylist3Appointments = stylist3Docs.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();
                      });
                    },
                    child: Text('Stylist 3'),
                    style: getStylistButtonStyle(3),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (showStylist1Appointments && stylist1Appointments.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Appointments',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: stylist1Appointments.map((appointment) {
                        // Convert Firestore timestamp to DateTime
                        DateTime date = (appointment['selectedDate'] as Timestamp)
                            .toDate();

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer Name: ${appointment['name']}'),
                                Text(
                                    'Phone Number: ${appointment['phoneNumber']}'),
                                Text(
                                    'Booking Slot: ${appointment['selectedTimeSlots']}'),
                                Text('Date: ${DateFormat('yyyy-MM-dd').format(
                                    date)}'),

                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            if (showStylist1Appointments && stylist1Appointments.isEmpty)
              Text(
                'No appointments for Stylist 1',
                style: TextStyle(fontSize: 16),
              ),
            if (showStylist2Appointments && stylist2Appointments.isEmpty)
              Text(
                'No appointments for Stylist 2',
                style: TextStyle(fontSize: 16),
              ),
            if (showStylist3Appointments && stylist3Appointments.isEmpty)
              Text(
                'No appointments for Stylist 3',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}