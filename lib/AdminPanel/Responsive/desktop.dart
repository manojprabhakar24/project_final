
import 'package:flutter/material.dart';
import '../screens/Dashboard.dart';
import '../screens/history.dart';

import '../screens/settings.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

  bool showHistory = false;
  bool showDashboard = false;
  bool showSettings = false;

  bool isDashboardSelected = false;
  bool isHistorySelected = false;
  bool isSettingsSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset(
            'assets/Scissors-image-remove.png',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Text(
            "Scissor's",
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
          ),
        ]),
        actions: <Widget>[
          Icon(Icons.account_circle,size: 35),
          SizedBox(
            width: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {},
            label: Text("LOGOUT",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.exit_to_app,color:Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Drawer(
            backgroundColor: Colors.white,
            elevation: 10,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                //Icon(Icons.admin_panel_settings),
                Text(
                  "WELCOME ADMIN",
                  style: TextStyle(fontSize: 25),
                ),
                Divider(
                  thickness: 3,
                  indent: 15,
                  endIndent: 15,
                ),
                Padding(
                  padding: tilePadding,
                  child: ListTile(
                    title: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showDashboard = true;
                          showHistory = false;
                          showSettings = false;
                          isDashboardSelected = true;
                          isHistorySelected = false;
                          isSettingsSelected = false;
                        });
                      },
                      icon: Icon(Icons.home_outlined,
                          color: isDashboardSelected
                              ? Colors.white
                              : Colors.black),
                      label: Text(
                        "DASHBOARD",
                        style: TextStyle(
                            color: isDashboardSelected
                                ? Colors.white
                                : Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: isDashboardSelected ? Colors.indigo : null,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: tilePadding,
                  child: ListTile(
                    title: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showDashboard = false;
                          showHistory = true;
                          showSettings = false;
                          isDashboardSelected = false;
                          isHistorySelected = true;
                          isSettingsSelected = false;
                        });
                      },
                      icon: Icon(Icons.history,
                          color:
                          isHistorySelected ? Colors.white : Colors.black),
                      label: Text(
                        "HISTORY",
                        style: TextStyle(
                            color: isHistorySelected
                                ? Colors.white
                                : Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: isHistorySelected ? Colors.indigo : null,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: tilePadding,
                  child: ListTile(
                    title: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showDashboard = false;
                          showHistory = false;
                          showSettings = true;
                          isDashboardSelected = false;
                          isHistorySelected = false;
                          isSettingsSelected = true;
                        });
                      },
                      icon: Icon(Icons.settings,
                          color:
                          isSettingsSelected ? Colors.white : Colors.black),
                      label: Text("SETTINGS",
                          style: TextStyle(
                              color: isSettingsSelected
                                  ? Colors.white
                                  : Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: isSettingsSelected ? Colors.indigo : null,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: 'Search Bar',
                      hintText: 'Type here',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        if (showDashboard)
                          Expanded(
                            child: Dashboard(),
                          ),
                        if (showHistory)
                          Expanded(
                            child: HistoryScreen(),
                          ),
                        if (showSettings)
                          Expanded(
                            child: Setting(),
                          )
                      ],
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
}