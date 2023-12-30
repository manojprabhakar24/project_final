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
  bool isLoading = true; // Flag to track loading status

  @override
  void initState() {
    super.initState();
    _customersStream =
        FirebaseFirestore.instance.collection('Users').snapshots();
    // Fetch appointments for all stylists initially
    fetchAllAppointments();
  }

  void fetchAllAppointments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
          'Users').get();

      setState(() {
        stylistAppointments = {};
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String stylistName = doc['stylistName'];
          if (!stylistAppointments.containsKey(stylistName)) {
            stylistAppointments[stylistName] = [];
          }
          stylistAppointments[stylistName]!.add(
              doc.data() as Map<String, dynamic>);
        }
        isLoading = false; // Data fetched, set loading flag to false
      });
    } catch (error) {
      print("Error fetching appointments: $error");
      setState(() {
        isLoading = false; // Update loading flag even if an error occurs
      });
    }
  }

  void fetchAppointmentsByStylist(String stylistName) {
    print('Fetching appointments for $stylistName');
    setState(() {
      selectedStylist = stylistName;
    });
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
                        onPressed: () =>
                            fetchAppointmentsByStylist(stylistName),
                        child: Text(stylistName),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            stylistName == selectedStylist
                                ? Colors.brown
                                : Colors
                                .blue, // Change color based on selection
                          ),

                        ),
                      ));
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading) // Display loading indicator while fetching data
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading && selectedStylist.isNotEmpty &&
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
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: stylistAppointments[selectedStylist]!.map((
                          appointment) {
                        DateTime date = DateTime
                            .now(); // Default date or handle null
                        if (appointment['selectedDate'] != null &&
                            appointment['selectedDate'] is Timestamp) {
                          date = (appointment['selectedDate'] as Timestamp)
                              .toDate();
                        }
                        List<
                            dynamic> selectedServicesAppointment = appointment['selectedServices'] ??
                            [];
                        List<
                            String> selectedServices = selectedServicesAppointment
                            .map((
                            service) => '${service['name']}-${service['price']}')
                            .toList();


                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8)),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Customer Name: ${appointment['name']}'),
                                  Text(
                                      'Phone Number: ${appointment['phoneNumber']}'),
                                  Text(
                                      'Booking Slot: ${appointment['selectedTimeSlots']}'),
                                  Text(
                                      'Selected Services: ${selectedServices.join(', ')}'),
                                  Text(
                                      'Total Amount: ${appointment['totalAmount']}'),
                                  Text('Date: ${DateFormat('yyyy-MM-dd')
                                      .format(date)}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.check, color: Colors.green),
                                    label: Text("Service Done"),
                                  ),
                                  SizedBox(height: 10), // Adjust the height for spacing between buttons
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.dangerous_outlined, color: Colors.red),
                                    label: Text("Not Done"),
                                  ),
                                ],
                              ),
                            )
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}