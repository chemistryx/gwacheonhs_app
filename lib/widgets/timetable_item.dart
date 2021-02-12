import 'package:flutter/material.dart';

class TimetableItem extends StatelessWidget {
  final int period;
  final String subject;
  final Color color;
  const TimetableItem(
      {Key key, @required this.period, @required this.subject, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped");
      },
      child: Container(
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color ?? Colors.grey,
          boxShadow: [
            BoxShadow(
              color: color != null
                  ? color.withOpacity(0.25)
                  : Colors.grey.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "$period교시",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Text(
                subject,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
