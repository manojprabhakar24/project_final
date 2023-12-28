import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Stream<QuerySnapshot> _customersStream;
  int selectedStylist = 0;
  List<Map<String, dynamic>> stylist1Appointments = [];
  List<Map<String, dynamic>> stylist2Appointments = [];
  List<Map<String, dynamic>> stylist3Appointments = [];

  bool showStylist1Appointments = false;
  bool showStylist2Appointments = false;
  bool showStylist3Appointments = false;

  @override
  void initState() {
    super.initState();
    _customersStream = FirebaseFirestore.instance.collection('userData').snapshots();
  }

  ButtonStyle getStylistButtonStyle(int stylistId) {
    return selectedStylist == stylistId
        ? ElevatedButton.styleFrom(primary: Colors.red)
        : ElevatedButton.styleFrom(primary: Colors.blue);
  }
  void bookAppointment(Map<String, dynamic> appointmentData) async {
    // Check if a stylist is selected before booking the appointment
    if (selectedStylist != 0) {
      // Set the stylistId based on the selected stylist
      appointmentData['stylistId'] = selectedStylist; // Use the selectedStylist
      await FirebaseFirestore.instance.collection('userData').add(appointmentData);
    } else {
      // Handle the case where no stylist is selected
      print('Please select a stylist before booking the appointment.');
    }
  }

  void fetchAppointments(int stylistId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .where('stylistId', isEqualTo: stylistId)
        .get();

    if (stylistId == 1) {
      setState(() {
        stylist1Appointments = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        showStylist1Appointments = true;
        showStylist2Appointments = false;
        showStylist3Appointments = false;
      });
    } else if (stylistId == 2) {
      setState(() {
        stylist2Appointments = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        showStylist1Appointments = false;
        showStylist2Appointments = true;
        showStylist3Appointments = false;
      });
    } else if (stylistId == 3) {
      setState(() {
        stylist3Appointments = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        showStylist1Appointments = false;
        showStylist2Appointments = false;
        showStylist3Appointments = true;
      });
    }
  }

  // Inside the _DashboardState class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => fetchAppointments(1),
                  child: Text('Stylist 1'),
                  style: getStylistButtonStyle(1),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchAppointments(2),
                  child: Text('Stylist 2'),
                  style: getStylistButtonStyle(2),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchAppointments(3),
                  child: Text('Stylist 3'),
                  style: getStylistButtonStyle(3),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // UI for Stylist 1
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
            'Upcoming Appointments for Stylist 1',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Column(
            children: stylist1Appointments.map((appointment) {
              DateTime date = DateTime.now(); // Default date or handle null
              if (appointment['selectedDate'] != null &&
                  appointment['selectedDate'] is Timestamp) {
                date = (appointment['selectedDate'] as Timestamp).toDate();
              }

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
                      Text('Phone Number: ${appointment['phoneNumber']}'),
                      Text('Booking Slot: ${appointment['selectedTimeSlots']}'),
                      Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
    // UI for Stylist 2
    if (showStylist2Appointments && stylist2Appointments.isNotEmpty)
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
    'Upcoming Appointments for Stylist 2',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    Column(
    children: stylist2Appointments.map((appointment) {
    DateTime date = DateTime.now(); // Default date or handle null
    if (appointment['selectedDate'] != null &&
    appointment['selectedDate'] is Timestamp) {
    date = (appointment['selectedDate'] as Timestamp).toDate();
    }

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
    Text('Phone Number: ${appointment['phoneNumber']}'),
    Text('Booking Slot: ${appointment['selectedTimeSlots']}'),
    Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
    ],
    ),
    ),
    );
    }).toList(),
    ),
    ],
    ),
    ),
    // UI for Stylist 3
    if (showStylist3Appointments && stylist3Appointments.isNotEmpty)
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
    'Upcoming Appointments for Stylist 3',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    Column(
    children: stylist3Appointments.map((appointment) {
    DateTime date = DateTime.now(); // Default date or handle null
    if (appointment['selectedDate'] != null &&
    appointment['selectedDate'] is Timestamp) {
    date = (appointment['selectedDate'] as Timestamp).toDate();
    }

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
    Text('Phone Number: ${appointment['phoneNumber']}'),
    Text('Booking Slot: ${appointment['selectedTimeSlots']}'),
    Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
    ],
    ),
    ),
    );
    }).toList(),
    ),
    ],
    ),
    ),
    // Display messages when there are no appointments for Stylist 1, Stylist 2, or Stylist 3
                if (showStylist1Appointments && stylist1Appointments.isEmpty)
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Appointments for Stylist 1',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                if (showStylist2Appointments && stylist2Appointments.isEmpty)
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Appointments for Stylist 2',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                if (showStylist3Appointments && stylist3Appointments.isEmpty)
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Appointments for Stylist 3',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                // Similar sections for other stylists
              ],
          ),
      ),
    );
  }
}

