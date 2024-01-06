import 'package:flutter/material.dart';
import '../../AdminLogin/admin_login.dart';
import '../screens/Dashboard.dart';
import '../screens/history.dart';
import '../screens/settings.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  bool isDashboardSelected = true;
  bool isHistorySelected = false;
  bool isSettingsSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                DrawerHeader(
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
                          color: Colors.black, // Set the text color
                        ),
                      ),
                    ],
                  ),

                ),
                buildDrawerTile(
                    "DASHBOARD", Icons.home_outlined, isDashboardSelected, () {
                  updateSelected(true, false, false);
                }),
                buildDrawerTile("HISTORY", Icons.history, isHistorySelected,
                        () {
                      updateSelected(false, true, false);
                    }),
                buildDrawerTile("SETTINGS", Icons.settings, isSettingsSelected,
                        () {
                      updateSelected(false, false, true);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.brown),
                            ),
                            labelText: 'Search Bar',
                            hintText: 'Type here',
                            prefixIcon: Icon(Icons.search_rounded),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
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
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          if (isDashboardSelected) Expanded(child: Dashboard()),
                          if (isHistorySelected)
                            Expanded(child: HistoryScreen()),
                          if (isSettingsSelected) Expanded(child: Setting())
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile(
      String title, IconData icon, bool isSelected, VoidCallback onTap) {
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
