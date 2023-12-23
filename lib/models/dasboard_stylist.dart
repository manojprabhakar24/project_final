import 'package:flutter/material.dart';

class StylistDetails extends StatelessWidget {
  final String id;
  final String name;
  final String phoneNumber;

  const StylistDetails({
    Key? key,
    required this.id,
    required this.name,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stylist Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'ID: $id',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Name: $name',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Phone Number: $phoneNumber',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}