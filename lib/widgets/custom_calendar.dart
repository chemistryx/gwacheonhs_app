import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  CustomCalendar(
      {@required this.controller, this.events, this.daySelectionHandler});

  final CalendarController controller;
  final Map events;
  final Function daySelectionHandler;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      calendarController: controller,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      events: events,
      availableGestures: AvailableGestures.horizontalSwipe,
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: CustomStyle.calendarHeader,
        headerPadding: EdgeInsets.only(bottom: 10),
      ),
      builders: CalendarBuilders(
        dowWeekdayBuilder: (context, day) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  day,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        },
        dowWeekendBuilder: (context, day) {
          return Container(
            padding: EdgeInsets.only(left: 3),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(color: Colors.red),
            ),
          );
        },
        dayBuilder: (context, date, _) {
          return Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text(
              '${date.day}',
              style: CustomStyle.calendarDefaultDate,
            ),
          );
        },
        selectedDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: CustomColor.cyan,
              borderRadius: BorderRadius.circular(5),
            ),
            width: 100,
            height: 100,
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text(
              '${date.day}',
              style:
                  CustomStyle.calendarDefaultDate.copyWith(color: Colors.white),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            width: 100,
            height: 100,
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text(
              '${date.day}',
              style: CustomStyle.calendarDefaultDate,
            ),
          );
        },
        weekendDayBuilder: (context, date, _) {
          return Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text(
              '${date.day}',
              style:
                  CustomStyle.calendarDefaultDate.copyWith(color: Colors.red),
            ),
          );
        },
        outsideWeekendDayBuilder: (context, date, _) {
          return Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text(
              '${date.day}',
              style: CustomStyle.calendarDefaultDate
                  .copyWith(color: Colors.red[200]),
            ),
          );
        },
        outsideDayBuilder: (context, date, _) {
          // HACK: disable outside day selection
          return IgnorePointer(
            child: Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.only(left: 5, top: 2),
              child: Text(
                '${date.day}',
                style: CustomStyle.calendarDefaultDate
                    .copyWith(color: Colors.grey),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.redAccent,
                  ),
                  child: Center(
                    child: Text(
                      "${events.length}",
                      style: CustomStyle.calendarEventsMarker,
                    ),
                  ),
                ),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: daySelectionHandler,
    );
  }
}
