import 'package:flutter/material.dart';

class FallbackContainer extends StatelessWidget {
  FallbackContainer({@required this.text, @required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          SizedBox(height: 10),
          Text(text, style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }
}
