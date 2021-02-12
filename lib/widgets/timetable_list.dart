import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/widgets/timetable_item.dart';

class TimetableList extends StatelessWidget {
  TimetableList({@required this.timetableList, @required this.dayIndex});

  final List timetableList;
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          if (index >= timetableList[dayIndex].length) {
            if (index == 6) {
              return Container(
                width: 48,
                height: 48,
                child: Icon(EvaIcons.plus, size: 18),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
              );
            } else {
              return SizedBox();
            }
          } else {
            return TimetableItem(
              period: int.parse(timetableList[dayIndex][index].timetablePeriod),
              subject: timetableList[dayIndex][index].timetableSubject,
            );
          }
        },
      ),
    );
  }
}
