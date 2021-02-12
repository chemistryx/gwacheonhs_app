import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Badge({this.color, @required this.content});

  final Color color;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ?? Colors.grey,
      ),
      child: Center(child: content),
    );
  }
}
