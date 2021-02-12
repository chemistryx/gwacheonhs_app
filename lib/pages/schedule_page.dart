import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/schedule.dart';
import 'package:gwacheonhs_app/repositories/schedule_repository.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/utils.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:gwacheonhs_app/widgets/custom_calendar.dart';
import 'package:gwacheonhs_app/widgets/loading_indicator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin<SchedulePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  Map<DateTime, List<dynamic>> _events;
  Future<Schedule> schedule;
  List<dynamic> _selectedEvents;
  TextEditingController _addController;
  TextEditingController _editController;
  CalendarController _calendarController;
  var box = Hive.box('schedule');

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _addController = TextEditingController();
    _editController = TextEditingController();
    schedule = ScheduleRepository().getSchedule();
    _events = {};
    _selectedEvents = [];
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(box.get('events') ?? "{}")));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
    _addController.dispose();
    _editController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text("일정", style: CustomStyle.appBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.red,
        child: Icon(EvaIcons.plus),
        onPressed: () => buildAddDialog(),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: FutureBuilder(
          future: schedule,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return LoadingIndicator();
                break;
              default:
                if (snapshot.hasError ||
                    snapshot.data.result != null &&
                        snapshot.data.result.code.startsWith('ERROR')) {
                  print(
                      "An error occured while fetching schedule from API: ${snapshot.data.result.message}"); // TODO: better error handling
                } else {
                  // snapshot.data.schoolSchedule[1].row.forEach((f) {
                  //   DateTime date = DateTime.parse(f.eventDate);
                  //   print("$date: ${f.eventName}");
                  //   if (_events[date] != null) {
                  //     _events[date].add(f.eventName);
                  //   } else {
                  //     _events[date] = [f.eventName];
                  //   }
                  // });
                }
            }
            return Column(
              children: <Widget>[
                ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, box, widget) {
                    return CustomCalendar(
                        controller: _calendarController,
                        events: Map<DateTime, List<dynamic>>.from(
                            decodeMap(json.decode(box.get('events') ?? "{}"))),
                        daySelectionHandler: (date, events) {
                          print(date);
                          setState(() {
                            _selectedEvents = events;
                          });
                        });
                  },
                ),
                // TODO: fix today events not displaying on initial build
                Expanded(child: _buildEventList()),
              ],
            );
          },
        ),
      ),
    );
  }

  Future buildAddDialog() {
    // TODO: fix bottom overflow
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("일정 추가"),
          content: TextField(
            controller: _addController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "내용을 입력해주세요",
            ),
          ),
          actions: [
            FlatButton(
              child: Text("추가"),
              onPressed: () {
                if (_addController.text.isEmpty ||
                    _addController.text.trim().length == 0) return;
                if (_events[_calendarController.selectedDay] != null) {
                  _events[_calendarController.selectedDay]
                      .add(_addController.text);
                } else {
                  _events[_calendarController.selectedDay] = [
                    _addController.text
                  ];
                }
                update();
                _addController.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future buildEditDialog(int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("일정 수정"),
          content: TextFormField(
            // since we cannot use initialValue with controller at the same time, pass the value directly to a controller
            controller: _editController
              ..text = _events[_calendarController.selectedDay][index],
            autofocus: true,
          ),
          actions: [
            FlatButton(
              child: Text("수정"),
              onPressed: () {
                if (_editController.text.isNotEmpty) {
                  _events[_calendarController.selectedDay]
                      .insert(index, _editController.text);
                  _events[_calendarController.selectedDay]
                      .removeAt((index + 1));
                }
                update();
                _editController.clear();
                Navigator.pop(context);
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('일정을 수정했습니다.', style: CustomStyle.snackBar),
                  ),
                  duration: Duration(seconds: 1),
                ));
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildEventList() {
    print("hive events:: ${box.get('events')}");
    return ListView(
      physics: ClampingScrollPhysics(),
      children: _selectedEvents.asMap().entries.map((event) {
        int index = event.key;
        String content = event.value;
        return Dismissible(
          direction: DismissDirection.horizontal,
          key: Key("$index-$content"),
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            tileColor: CustomColor.indigo.withOpacity(0.1),
            title: Text(content, style: CustomStyle.tableHeader),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              buildEditDialog(index);
              return false;
            }
            if (direction == DismissDirection.endToStart) return true;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              _events[_calendarController.selectedDay].removeAt(index);
              update();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "일정을 삭제했습니다.",
                      style: CustomStyle.snackBar,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          background: buildDismissibleBackground(
              CustomColor.yellow, EvaIcons.editOutline, Alignment.centerLeft),
          secondaryBackground: buildDismissibleBackground(
              CustomColor.red, EvaIcons.trash2Outline, Alignment.centerRight),
        );
      }).toList(),
    );
  }

  Widget buildDismissibleBackground(
      Color color, IconData icon, Alignment alignment) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      padding: EdgeInsets.all(16),
      alignment: alignment,
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  void update() {
    print("call update()");
    box.put('events', json.encode(encodeMap(_events)));
    setState(() {
      _selectedEvents = _events[_calendarController.selectedDay];
    });
  }

  @override
  bool get wantKeepAlive => true;
}
