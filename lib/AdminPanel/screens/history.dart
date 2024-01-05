import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    _historyStream = FirebaseFirestore.instance.collection('History').snapshots();
  }

  Color getStatusColor(bool completed) {
    return completed ? Colors.white : Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _historyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final historyAppointments = snapshot.data?.docs ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Appointment History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: historyAppointments.length,
                  itemBuilder: (context, index) {
                    final historyAppointment = historyAppointments[index];
                    final customerName = historyAppointment['name'];
                    final customerPhoneNumber = historyAppointment['phoneNumber'];
                    final bookingSlot = historyAppointment['selectedTimeSlots'];
                    final totalAmount = historyAppointment['totalAmount'];
                    final selectedServices = historyAppointment['selectedServices'];
                    final stylistName = historyAppointment['stylistName'];
                    final selectedDate =
                    (historyAppointment['selectedDate'] as Timestamp).toDate();
                    final formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm').format(selectedDate);
                    final completed = historyAppointment['completed'];

                    return Card(
                      color: getStatusColor(completed),
                      child: ListTile(
                        title: Text(
                          customerName,
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stylist: $stylistName',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Phone Number: $customerPhoneNumber',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Booking Slot: $bookingSlot',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Total Amount: $totalAmount',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Date: $formattedDate',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Services: $selectedServices',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Status: ${completed ? 'Completed' : 'Not Completed'}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
