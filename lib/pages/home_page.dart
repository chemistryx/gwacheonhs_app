import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/meal.dart';
import 'package:gwacheonhs_app/pages/settings_page.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/widgets/announcement.dart';
import 'package:gwacheonhs_app/widgets/badge.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:gwacheonhs_app/widgets/custom_card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  DatabaseReference _noticeRef;
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  var mealBox = Hive.box('meal');
  var scheduleBox = Hive.box('schedule');

  @override
  void initState() {
    super.initState();
    _noticeRef = FirebaseDatabase().reference().child('notice');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: _buildAppBarTitle(),
        titleSpacing: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              EvaIcons.settingsOutline,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => SettingsPage(),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8),
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Announcement(reference: _noticeRef),
              CustomCard(
                vsync: this,
                index: 2,
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.clock, color: CustomColor.cyan),
                    SizedBox(width: 10),
                    Text("오늘 시간표", style: CustomStyle.cardTitleDark),
                  ],
                ),
                // content: _buildTodayTimetable(),
                content: SizedBox(),
                badge: _buildClassBadge(),
                color: Colors.white,
              ),
              CustomCard(
                vsync: this,
                index: 3,
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.pieChart2, color: CustomColor.yellow),
                    SizedBox(width: 10),
                    Text("오늘 급식", style: CustomStyle.cardTitleDark),
                  ],
                ),
                content: _buildTodayMeal(),
                color: Colors.white,
              ),
              CustomCard(
                vsync: this,
                index: 4,
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.calendar, color: CustomColor.red),
                    SizedBox(width: 10),
                    Text("오늘 일정", style: CustomStyle.cardTitleDark),
                  ],
                ),
                content: _buildTodaySchedule(),
                badge: Badge(
                  color: CustomColor.red,
                  content: Text(
                    DateFormat.yMMMd('ko_KR').format(DateTime.now()),
                    style: CustomStyle.badge,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/logo.png", fit: BoxFit.cover, height: 36),
          Container(
            padding: EdgeInsets.all(8),
            child: Text('과천고등학교', style: CustomStyle.appBarHomeTitle),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMeal() {
    String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    List<MealRow> filtered = [];
    return ValueListenableBuilder(
      valueListenable: mealBox.listenable(),
      builder: (context, box, widget) {
        if (box.values.isEmpty)
          return Text("급식을 불러올 수 없습니다.", style: CustomStyle.cardContentGrey);
        Meal meal = Meal.fromJson(json.decode(box.get('data')));
        filtered = meal.mealServiceDietInfo[1].row
            .where((element) => element.mealDate == formattedDate)
            .toList();
        return Text(
          filtered.isEmpty
              ? "급식이 없습니다."
              : filtered[0]
                  .mealName
                  .replaceAll(RegExp(r'\d|[.]|[*]'), '')
                  .split('<br/>')
                  .join('\n'),
          style: filtered.isEmpty
              ? CustomStyle.cardContentGrey
              : CustomStyle.cardContentDark.apply(heightFactor: 1.4),
        );
      },
    );
  }

  Widget _buildTodaySchedule() {
    return ValueListenableBuilder(
      valueListenable: scheduleBox.listenable(),
      builder: (context, box, widget) {
        var events = box.get('events');
        if (events == null)
          return Text("일정이 없습니다.", style: CustomStyle.cardContentGrey);
        DateTime now = DateTime.now();
        DateTime key = DateTime.utc(now.year, now.month, now.day, 12);
        List todayEvents = json.decode(events)[key.toString()] ?? [];
        return Text(
          todayEvents.isEmpty ? "일정이 없습니다." : todayEvents.join('\n'),
          style: todayEvents.isEmpty
              ? CustomStyle.cardContentGrey
              : CustomStyle.cardContentDark.apply(heightFactor: 1.4),
        );
      },
    );
  }

  Widget _buildClassBadge() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferences').listenable(),
      builder: (context, box, widget) {
        var formatted = box.get('grade', defaultValue: 1).toString() +
            '학년 ' +
            box.get('class', defaultValue: 1).toString() +
            '반';
        return Badge(
            content: Text(formatted, style: CustomStyle.badge),
            color: CustomColor.cyan);
      },
    );
  }

  // TODO: bring back timetable feature
  // Widget _buildTodayTimetable() {
  //   return StreamBuilder(
  //     stream: timetableBloc.subject.stream,
  //     builder: (context, AsyncSnapshot<Timetable> snapshot) {
  //       if (snapshot.hasData && snapshot.data.status) {
  //         return _buildTimetableList(snapshot);
  //       } else if (snapshot.data == null) {
  //         // fetch in progress
  //         return Text("시간표를 불러오는 중입니다.", style: CustomStyle.cardContentGrey);
  //       } else if (snapshot.hasError || !snapshot.data.status) {
  //         return Text("시간표를 불러오는 중 오류가 발생했습니다.",
  //             style: CustomStyle.cardContentGrey);
  //       } else {
  //         return Text("시간표를 불러오는 중입니다.", style: CustomStyle.cardContentGrey);
  //       }
  //     },
  //   );
  // }

  Widget _buildTimetableItem(String period, String subject, bool active) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: active ? Colors.grey[200] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(period, style: CustomStyle.cardContentDark),
          Text(subject, style: CustomStyle.cardContentSubject),
        ],
      ),
    );
  }

  // TODO: bring back timetable feature
  // Widget _buildTimetableList(AsyncSnapshot<Timetable> snapshot) {
  //   var data = [];
  //   var periodData = [];
  //   var todayData = [];
  //   var weekday = DateTime.now().weekday;
  //   if (weekday < 6) {
  //     for (var i = 1; i <= 7; i++) {
  //       data.add(snapshot.data.content.grid[i][weekday]);
  //       periodData.add(snapshot.data.content.grid[i][0].split('|'));
  //     }
  //     for (var i = 0; i <= 6; i++) {
  //       todayData.add(data[i].split('|')[0]);
  //     }
  //     todayData = todayData.reversed
  //         .skipWhile((val) => val == '')
  //         .toList()
  //         .reversed
  //         .toList();
  //     return todayData.isNotEmpty
  //         ? ListView.builder(
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             itemCount: todayData.length,
  //             itemBuilder: (context, index) {
  //               return _buildTimetableItem(periodData[index][0],
  //                   todayData[index], index % 2 != 0 ? true : false);
  //             },
  //           )
  //         : Text("시간표가 없습니다.", style: CustomStyle.cardContentGrey);
  //   } else {
  //     return Text("시간표가 없습니다.", style: CustomStyle.cardContentGrey);
  //   }
  // }

  @override
  bool get wantKeepAlive => true;
}
