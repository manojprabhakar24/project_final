import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Stream<QuerySnapshot> _customersStream;

  @override
  void initState() {
    super.initState();
    _customersStream =
        FirebaseFirestore.instance.collection('Users').snapshots();
  }

  Future<void> markServiceDone(String documentID) async {
    try {
      // Move appointment to history by marking it completed in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentID)
          .update({
        'completed': true,
      });
    } catch (error) {
      print("Error marking service done: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _customersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data?.docs ?? [];
          final pendingAppointments = appointments.where((appointment) {
            final data = appointment.data() as Map<String, dynamic>;
            return !(data.containsKey('completed') && data['completed']);
          }).toList();

          return pendingAppointments.isEmpty
              ? Center(
            child: Text(
              'No upcoming appointments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
              : ListView.builder(
            itemCount: pendingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = pendingAppointments[index];
              final documentID = appointment.id;
              final customerName = appointment['name'];
              final customerPhoneNumber = appointment['phoneNumber'];
              final bookingSlot = appointment['selectedTimeSlots'];
              final totalAmount = appointment['totalAmount'];
              final selectedServices = appointment['selectedServices'];
              final stylistName =
              appointment['stylistName']; // Assuming stylistName is a field in your document
              final selectedDate =
              appointment['selectedDate']; // Date field from Firestore

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
                      Text('Services: $selectedServices'),
                      // Update based on your data structure
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => markServiceDone(documentID),
                    child: Text('Service Done'),
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
