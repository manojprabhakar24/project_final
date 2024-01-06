import 'dart:convert';
import 'package:http/http.dart' as http;
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
  Map<String, List<Map<String, dynamic>>> stylistAppointments = {};
  String selectedStylist = '';
  bool isLoading = true;
  Future<void> updateAppointmentStatus(String stylistName, String status) async {
    try {
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

      // Query for appointments with the matching stylist name and 'pending' status
      QuerySnapshot querySnapshot = await usersCollection
          .where('stylistName', isEqualTo: stylistName)
          .where('status', isEqualTo: 'pending')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot appointmentDoc = querySnapshot.docs.first;

        await appointmentDoc.reference.update({'status': status});

        print(
            'Appointment status updated successfully to $status for stylist $stylistName');
      } else {
        print('No pending appointment found for stylist $stylistName');
      }
    } catch (error) {
      print('Error updating appointment status: $error');
    }
  }

  void fetchAppointmentsByStylist(String stylistName) {
    print('Fetching appointments for $stylistName');
    setState(() {
      selectedStylist = stylistName;
    });
  }

  Future<void> sendTwilioSMS({
    required String to,
    required String body,
    required String stylistName,
  }) async {
    try {
      final accountSid = 'AC8032394725a51f80a26427f0ecd06af6';
      final authToken = 'c77948c1e2e06069b9b09d4abce4005b';
      final twilioNumber = '+16508648721';

      // Fetch the latest appointment details from Firestore based on stylist name
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('stylistName', isEqualTo: stylistName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final appointmentDetails =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Construct Twilio API endpoint
        final apiUrl =
            'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json';

        // Construct message body with appointment details
        final formattedBody = '$body\n\nAppointment Details:\n'
            'Customer Name: ${appointmentDetails['name']}\n'
            'Phone Number: ${appointmentDetails['phoneNumber']}\n'
            'Booking Slot: ${appointmentDetails['selectedTimeSlots']}\n'
            'Date: ${DateFormat('yyyy-MM-dd').format(appointmentDetails['selectedDate']?.toDate() ?? DateTime.now())}';

        // Make an HTTP POST request to Twilio API
        final response = await http.post(
          Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json'),
          headers: {
            'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
          },
          body: {
            'From': twilioNumber,
            'To': to,
            'Body': formattedBody,
          },
        );

        // Check the response status
        if (response.statusCode == 201) {
          print('SMS sent successfully');
        } else {
          print('Failed to send SMS. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } else {
        print('No appointment found for stylist $stylistName');
      }
    } catch (error) {
      print('Error sending SMS: $error');
    }
  }

  Future<void> updateAppointmentStatusAndSendTwilio(
      String stylistName, String status, Map<String, dynamic> appointment) async {
    try {
      // Perform the update in Firestore
      await updateAppointmentStatus(stylistName, status);

      // Fetch the user's phone number from Firestore
      String userPhoneNumber ='+91' + appointment['phoneNumber'];

      // Send Twilio SMS
      String message = status == 'accepted'
          ? 'Your appointment with $stylistName has been accepted.'
          : 'Your appointment with $stylistName has been declined.';

      await sendTwilioSMS(
        to: userPhoneNumber,
        body: message,
        stylistName: stylistName,
      );

      // Fetch updated appointments after the update
      fetchAppointmentsByStylist(stylistName);
    } catch (error) {
      print('Error updating appointment status and sending SMS: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _customersStream = FirebaseFirestore.instance.collection('Users').snapshots();

    fetchAllAppointments();
  }

  void fetchAllAppointments() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();

      setState(() {
        stylistAppointments = {};
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String stylistName = doc['stylistName'];
          if (!stylistAppointments.containsKey(stylistName)) {
            stylistAppointments[stylistName] = [];
          }
          stylistAppointments[stylistName]!.add(
            doc.data() as Map<String, dynamic>,
          );
        }
        isLoading = false; // Data fetched, set loading flag to false
      });
    } catch (error) {
      print("Error fetching appointments: $error");
      setState(() {
        isLoading = false;
        // Update loading flag even if an error occurs
      });
    }
  }

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
                children: stylistAppointments.keys.map((stylistName) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    // Adjust the horizontal padding as needed
                    child: ElevatedButton(
                      onPressed: () => fetchAppointmentsByStylist(stylistName),
                      child: Text(stylistName),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          stylistName == selectedStylist
                              ? Colors.brown
                              : Colors.blue, // Change color based on selection
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading) // Display loading indicator while fetching data
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading &&
                selectedStylist.isNotEmpty &&
                stylistAppointments.containsKey(selectedStylist))
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  color: Colors.deepOrange[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Appointments for $selectedStylist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: stylistAppointments[selectedStylist]!.map(
                            (appointment) {
                          DateTime date = DateTime.now(); // Default date or handle null
                          if (appointment['selectedDate'] != null &&
                              appointment['selectedDate'] is Timestamp) {
                            date = (appointment['selectedDate'] as Timestamp)
                                .toDate();
                          }
                          List<dynamic> selectedServicesAppointment =
                              appointment['selectedServices'] ?? [];
                          List<String> selectedServices =
                          selectedServicesAppointment
                              .map((service) =>
                          '${service['name']}-${service['price']}')
                              .toList();

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Customer Name: ${appointment['name']}'),
                                  Text('Phone Number: ${appointment['phoneNumber']}'),
                                  Text('Booking Slot: ${appointment['selectedTimeSlots']}'),
                                  Text('Selected Services: ${selectedServices.join(', ')}'),
                                  Text('Total Amount: ${appointment['totalAmount']}'),
                                  Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Accept the appointment and send Twilio SMS
                                            await updateAppointmentStatusAndSendTwilio(
                                              selectedStylist,
                                              'accepted',
                                              appointment,
                                            );
                                          },
                                          child: Text('Accept'),
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Decline the appointment and send Twilio SMS
                                            await updateAppointmentStatusAndSendTwilio(
                                              selectedStylist,
                                              'declined',
                                              appointment,
                                            );
                                          },
                                          child: Text('Decline'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {

                                          },
                                          child: Text('Service Done'),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () async {

                                          },
                                          icon: Icon(Icons.check, color: Colors.red),
                                          label: Text("Not Done"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Rest of your code...



  Future<void> markServiceDone(
      String documentID, bool isServiceDone, Function(Map<String, dynamic> appointmentData) onServiceDone) async {
    try {
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentID)
          .get();
      final appointmentData = appointmentSnapshot.data() as Map<String, dynamic>;

      // Move appointment to history by copying it to the 'History' collection
      await FirebaseFirestore.instance
          .collection('History')
          .doc(documentID)
          .set({
        ...appointmentData,
        'completed': isServiceDone,
      });

      // Mark the appointment as completed or not done in the 'Users' collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentID)
          .update({
        'completed': isServiceDone,
      });

      // Call the callback function to pass the appointment data
      onServiceDone(appointmentData);
    } catch (error) {
      print("Error marking service done: $error");
    }
  }
}