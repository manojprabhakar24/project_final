import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Stream<QuerySnapshot> _customersStream;
  late Map<String, List<DocumentSnapshot>> stylistAppointments;
  String selectedStylist = '';

  @override
  void initState() {
    super.initState();
    _customersStream = FirebaseFirestore.instance.collection('Users').snapshots();
  }

  // Callback function to update the state
  void updateDashboardState() {
    setState(() {});
  }

  Future<void> markServiceDone(
      String documentID,
      bool isServiceDone,
      Function(Map<String, dynamic> appointmentData) onServiceDone,
      ) async {
    try {
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentID)
          .get();
      final appointmentData = appointmentSnapshot.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance.collection('History').doc(documentID).set({
        ...appointmentData,
        'completed': isServiceDone,
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentID)
          .update({
        'completed': isServiceDone,
      });

      // Call the callback function to trigger the state update
      onServiceDone(appointmentData);

      // Stay on the same page by refreshing the UI
      setState(() {});
    } catch (error) {
      print("Error marking service done: $error");
    }
  }

  Future<void> markServiceNotDone(
      String documentID,
      Function(Map<String, dynamic> appointmentData) onServiceNotDone,
      ) async {
    try {
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentID)
          .get();
      final appointmentData = appointmentSnapshot.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance
          .collection('History')
          .doc(documentID)
          .set({
        ...appointmentData,
        'completed': false,
      });

      await FirebaseFirestore.instance.collection('Users').doc(documentID).delete();

      // Call the callback function to pass the appointment data
      onServiceNotDone(appointmentData);

      // Stay on the same page by refreshing the UI
      setState(() {});
    } catch (error) {
      print("Error marking service not done: $error");
    }
  }

  Map<String, List<DocumentSnapshot>> groupAppointmentsByStylist(
      List<DocumentSnapshot> appointments,
      ) {
    Map<String, List<DocumentSnapshot>> stylistAppointments = {};

    for (var appointment in appointments) {
      final data = appointment.data() as Map<String, dynamic>;
      final stylistName = data['stylistName'];

      if (!stylistAppointments.containsKey(stylistName)) {
        stylistAppointments[stylistName] = [];
      }

      stylistAppointments[stylistName]!.add(appointment);
    }

    return stylistAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _customersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data?.docs ?? [];
          stylistAppointments = groupAppointmentsByStylist(appointments);

          return SingleChildScrollView(
              child: Column(
              children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var stylistName in stylistAppointments.keys)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedStylist = stylistName;
                        });
                      },
                      child: Text(
                        stylistName,
                        style: TextStyle(
                          color: selectedStylist == stylistName ? Colors.white : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: selectedStylist == stylistName ? Colors.brown[300] : null,
                        onPrimary: Colors.white, // Change this color as needed
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              if (selectedStylist.isNotEmpty &&
                  (stylistAppointments[selectedStylist] == null ||
                      stylistAppointments[selectedStylist]!.isEmpty))
                Center(
                  child: Text('No Appointments'),
                )
              else if (selectedStylist.isNotEmpty)
                Container(
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Upcoming Appointments - $selectedStylist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: stylistAppointments[selectedStylist]!.length,
                        itemBuilder: (context, index) {
                          final appointment = stylistAppointments[selectedStylist]![index];

                          // Check if the 'completed' field exists
                          final isCompleted =
                              appointment.data() is Map<String, dynamic> &&
                                  (appointment.data() as Map<String, dynamic>)
                                      .containsKey('completed') &&
                                  (appointment.data() as Map<String, dynamic>)
                                  ['completed'];

                          return isCompleted
                              ? Container()
                              : Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(appointment['name']),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Booking Slot: ${appointment['selectedTimeSlots']}',
                                  ),
                                  Text(
                                    'Total Amount: ${appointment['totalAmount']}',
                                  ),
                                  Text(
                                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format((appointment['selectedDate'] as Timestamp).toDate())}',
                                  ),
                                  Text(
                                    'Status: ${isCompleted ? 'Completed' : 'Not Completed'}',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      markServiceDone(
                                        appointment.id,
                                        true,
                                            (appointmentData) {
                                          // Do anything you need with the data when marked as done
                                          updateDashboardState(); // Update the state
                                        },
                                      );
                                    },
                                    child: Text('Service Done'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      markServiceNotDone(
                                        appointment.id,
                                            (appointmentData) {
                                          // Do anything you need with the data when marked as not done
                                          updateDashboardState(); // Update the state
                                        },
                                      );
                                    },
                                    child: Text('Service not Done'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ));
        },
      ),
    );
  }
}
