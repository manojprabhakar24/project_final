import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../AdminLogin/admin_login.dart';
import '../screens/Dashboard.dart';
import '../screens/history.dart';

import '../screens/settings.dart';


class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

  bool showHistory = false;
  bool showDashboard = false;
  bool showSettings = false;

  bool isDashboardSelected = false;
  bool isHistorySelected = false;
  bool isSettingsSelected = false;

  void closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scissor's Salon",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontWeight:FontWeight.bold ,
              fontSize: 25,
            ),
          ),
        ),
        actions: <Widget>[
          Icon(Icons.account_circle, size: 35),
          SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EmailLogin()),
              );
            },
            label: Text(
              "LOGOUT",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[300],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                width: double.infinity,
                color: Colors.brown[200],
                child: Column(
                  children: [
                    Image.asset(
                      "assets/Scissors-image-remove.png",
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Scissors",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buildDrawerTile("DASHBOARD", Icons.home_outlined, isDashboardSelected, () {
              updateSelected(true, false, false);
              closeDrawer();
            }),
            buildDrawerTile("HISTORY", Icons.history, isHistorySelected, () {
              updateSelected(false, true, false);
              closeDrawer();
            }),
            buildDrawerTile("SETTINGS", Icons.settings, isSettingsSelected, () {
              updateSelected(false, false, true);
              closeDrawer();
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if (isDashboardSelected) Expanded(child: Dashboard()),
                    if (isHistorySelected) Expanded(child: HistoryScreen()),
                    if (isSettingsSelected) Expanded(child: Setting())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerTile(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: isSelected ? Colors.white : Colors.black),
          label: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            primary: isSelected ? Colors.brown[300] : null,
            onPrimary: Colors.white,
          ),
        ),
      ),
    );
  }

  void updateSelected(bool dashboard, bool history, bool settings) {
    setState(() {
      isDashboardSelected = dashboard;
      isHistorySelected = history;
      isSettingsSelected = settings;
    });
  }
}