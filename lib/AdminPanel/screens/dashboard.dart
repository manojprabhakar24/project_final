import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/dasboard_stylist.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedStylist = 0;
  ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.white,
  );

  ButtonStyle getStylistButtonStyle(int stylistId) {
    return selectedStylist == stylistId
        ? ElevatedButton.styleFrom(
      primary: Colors.red, // Change to red when selected
    )
        : selectedButtonStyle;
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
                width: 187,
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
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.black12),
                    Text(
                      '1000',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Container(
                height: 100,
                width: 187,
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
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.black12),
                    Text(
                      '0',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
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
                          ]),
                          if (selectedStylist != 0)
                            Column(
                              children: [
                                Center(
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: StylistDetails(
                                            id: selectedStylist == 1
                                                ? '1'
                                                : selectedStylist == 2
                                                ? '2'
                                                : '3',
                                            name: selectedStylist == 1
                                                ? 'manoj'
                                                : selectedStylist == 2
                                                ? 'harish'
                                                : 'abi',
                                            phoneNumber: selectedStylist == 1
                                                ? '6385793702'
                                                : selectedStylist == 2
                                                ? '9500663203'
                                                : '6363252889',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ]),
                  ])
            ]),
          )
        ],
      ),
    );
  }
}