import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Stream<QuerySnapshot> _historyStream;

  @override
  void initState() {
    super.initState();
    _historyStream = FirebaseFirestore.instance
        .collection('Users')
        .where('completed', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _historyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final completedAppointments = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: completedAppointments.length,
            itemBuilder: (context, index) {
              final completedAppointment = completedAppointments[index];
              final customerName = completedAppointment['name'];
              final customerPhoneNumber = completedAppointment['phoneNumber'];
              final bookingSlot = completedAppointment['selectedTimeSlots'];
              final totalAmount = completedAppointment['totalAmount'];
              final selectedServices = completedAppointment['selectedServices'];
              final stylistName =
              completedAppointment['stylistName']; // Assuming stylistName is a field in your document
              final selectedDate =
              completedAppointment['selectedDate']; // Date field from Firestore

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(customerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stylist: $stylistName'),
                      Text('Phone Number: $customerPhoneNumber'),
                      Text('Booking Slot: $bookingSlot'),
                      Text('Total Amount: $totalAmount'),
                      Text('Date: $selectedDate'), // Display the date
                      Text('Services: $selectedServices'), // Update based on your data structure
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
