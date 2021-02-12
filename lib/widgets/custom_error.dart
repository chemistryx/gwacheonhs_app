import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  CustomError({this.message, this.error});

  final String message;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("$message", style: TextStyle(fontWeight: FontWeight.bold)),
          Divider(),
          Text("$error",
              style: TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
