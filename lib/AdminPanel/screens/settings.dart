import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adminscreen.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}
class _SettingState extends State<Setting> {
  int selectedStylist = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Service Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 2.0,
            color: Colors.black,
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStylist = 1;
                          });
                        },
                        child: Text(
                          "Add Services",
                          style: TextStyle(
                            color: selectedStylist == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: selectedStylist == 1
                              ? Colors.indigo
                              : Colors.white,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0, // Adjusted padding
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStylist = 2;
                          });
                        },
                        child: Text(
                          "Add Stylist",
                          style: TextStyle(
                            color: selectedStylist == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: selectedStylist == 2
                              ? Colors.indigo
                              : Colors.white,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0, // Adjusted padding
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: selectedStylist == 1
                      ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ServiceForm(
                      addServiceToListScreen: (Services) {},
                    ),
                  )
                      : selectedStylist == 2
                      ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StylistForm(
                      addServiceToListScreen: (Services) {},
                    ),
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
