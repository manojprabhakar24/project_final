
import 'package:flutter/material.dart';
import 'adminscreen.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int selectedStylist = 0;
  ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.white,
  );

  ButtonStyle getStylistButtonStyle(int stylistId) {
    return selectedStylist == stylistId
        ? ElevatedButton.styleFrom(
      primary: Colors.blueAccent,
    )
        : selectedButtonStyle;
  }
  TextEditingController _oldPriceController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();
  TextEditingController _confirmPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Setting',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: Text('Add Service'),
                                      ),
                                      body: ServiceForm(
                                        addServiceToListScreen: (Services) {}, // Pass necessary parameters here
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text('Add Service'),
                              style: getStylistButtonStyle(1),
                            ),


                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStylist = 2;
                                });
                              },
                              child: Text('Add Profile'),
                              style: getStylistButtonStyle(2),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStylist = 3;
                                });
                              },
                              child: Text('Update Price'),
                              style: getStylistButtonStyle(3),
                            ),

                            Divider(
                              thickness: 2.0,
                              color: Colors.black,
                            ),

                          ],
                        ),
                        if (selectedStylist == 1)
                          SizedBox(width: 20),
                        if (selectedStylist == 1)
                          Expanded(
                            child: ServiceForm(addServiceToListScreen: (Services ) {  },),
                          ),
                        if (selectedStylist == 2)
                          SizedBox(width: 20),

                        if (selectedStylist == 3)
                          SizedBox(width: 20),
                        if (selectedStylist == 3)
                          Expanded(
                            child:  PriceUpdateForm(
                              oldPriceController: _oldPriceController,
                              newPriceController1: _newPriceController,
                              confirmPriceController2: _confirmPriceController,


                            ),
                          ),

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
