import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/stylist_data.dart';






class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedStylist = 0;
  ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue, // Default color for unselected buttons
  );

  ButtonStyle getStylistButtonStyle(int stylistId) {
    return selectedStylist == stylistId
        ? ElevatedButton.styleFrom(
      primary: Colors.red, // Change to red when selected
    )
        : selectedButtonStyle;
  }
  Map<String, dynamic>? getSelectedStylistDetails() {
    if (selectedStylist > 0 && selectedStylist <= stylistData.length) {
      return stylistData[selectedStylist - 1];
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total Customers',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Divider(color: Colors.black12),
                        Text(
                          '1000',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 100,
                    width: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Appointments',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Divider(color: Colors.black12),
                        Text(
                          '0',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Appointments',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          children:[
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedStylist = 1;
                                                });
                                              },
                                              child: Text('Stylist 1'),
                                              style: getStylistButtonStyle(1),
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedStylist = 2;
                                                });
                                              },
                                              child: Text('Stylist 2'),
                                              style: getStylistButtonStyle(2),
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedStylist = 3;
                                                });
                                              },
                                              child: Text('Stylist 3'),
                                              style: getStylistButtonStyle(3),
                                            ),
                                          ]
                                      ),
                                      SizedBox(width: 40),

                                      if (selectedStylist != 0)
                                        Column(
                                          children: [
                                            Center(
                                              child: Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          if (getSelectedStylistDetails() != null)
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Stylist $selectedStylist Details:',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8),
                                                                Image.asset(
                                                                  getSelectedStylistDetails()!['imgPth'],
                                                                  width: 100,
                                                                  height: 100,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                                Text(
                                                                  'Name: ${getSelectedStylistDetails()!['stylistName']}',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                Text(
                                                                  'Mobile Number: ${getSelectedStylistDetails()!['Phone number']}',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                Text(
                                                                  'Rating: ${getSelectedStylistDetails()!['rating']}',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                Text(
                                                                  'Rate Amount: ${getSelectedStylistDetails()!['rateAmount']}',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    )],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ]))]))]));
  }
}