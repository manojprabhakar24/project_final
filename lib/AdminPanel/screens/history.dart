import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late BehaviorSubject<List<DocumentSnapshot>> _customersSubject;

  @override
  void initState() {
    super.initState();

    CollectionReference userDataCollection = FirebaseFirestore.instance.collection('userData');
    Stream<QuerySnapshot> customersStream = userDataCollection.snapshots();

    _customersSubject = BehaviorSubject<List<DocumentSnapshot>>.seeded([]);

    customersStream.listen((QuerySnapshot snapshot) {
      _customersSubject.add(snapshot.docs);
    });
  }

  @override
  void dispose() {
    _customersSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Customer List', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Divider(
              color: Colors.black45,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(height: 20),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: _customersSubject.stream,
              initialData: [],
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final List<DocumentSnapshot> documents = snapshot.data!;

                return Column(
                  children: documents.map((doc) {
                    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                    Timestamp? timestamp = data['selectedDate'] as Timestamp?;
                    DateTime? dateTime = timestamp?.toDate();
                    final formattedDate = dateTime != null ? DateFormat('yyyy-MM-dd').format(dateTime) : '';

                    CollectionReference subcollection = doc.reference.collection('usersData');

                    return FutureBuilder(
                      future: subcollection.get(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> subcollectionSnapshot) {
                        if (subcollectionSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (subcollectionSnapshot.hasError) {
                          return Text('Error: ${subcollectionSnapshot.error}');
                        }

                        final List<DocumentSnapshot> subcollectionDocuments = subcollectionSnapshot.data!.docs;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ListTile(
                            leading: Text('Time Slots: ${data['selectedTimeSlots']}'),
                            contentPadding: EdgeInsets.all(16),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer Name: ${data['name']}'),
                                Text('Phone Number: ${data['phoneNumber']}'),
                                Text(
                                    'Booking Slot: ${data['selectedTimeSlots']}'),

                              ],
                            ),
                            trailing: Text('Date: $formattedDate'),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}