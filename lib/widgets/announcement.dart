import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/url_handler.dart';

class Announcement extends StatelessWidget {
  Announcement({@required this.reference});

  final DatabaseReference reference;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: reference.onValue,
      builder: (context, snap) {
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          if (snap.data.snapshot.value['active']) {
            DataSnapshot snapshot = snap.data.snapshot;
            Color color = Colors.white;
            Color iconColor = Colors.white;
            Icon icon = Icon(EvaIcons.checkmarkCircle, color: iconColor);
            TextStyle textStyle = CustomStyle.cardContent;
            int priority = snapshot.value['priority'];
            switch (priority) {
              case 2:
                color = CustomColor.green;
                break;
              case 1:
                color = CustomColor.yellow;
                icon = Icon(EvaIcons.alertTriangleOutline, color: iconColor);
                break;
              case 0:
                color = CustomColor.red;
                icon = Icon(EvaIcons.alertCircleOutline, color: iconColor);
                break;
              default:
            }
            if (priority > -1 && priority < 3) {
              return GestureDetector(
                onTap: () {
                  if (snapshot.value['url'] != null)
                    UrlHandler.launchBrowser(snapshot.value['url']);
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      icon,
                      SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          snapshot.value['content'],
                          style: textStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return SizedBox();
          }
        } else {
          return SizedBox();
        }
        return SizedBox();
      },
    );
  }
}
