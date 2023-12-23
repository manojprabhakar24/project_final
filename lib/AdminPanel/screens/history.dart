import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int n = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Customer List', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
            Divider(color: Colors.black45,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(height: 20),
            for (int i = 1; i <= n; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: ListTile(
                  leading:Text('Price'),
                  contentPadding: EdgeInsets.all(16),
                  title: Text('Customer $i'),
                  subtitle: Text('Details of Customer $i'),
                  trailing: Text('Ratings'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}