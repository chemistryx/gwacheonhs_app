import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/timetable.dart';
import 'package:gwacheonhs_app/repositories/timetable_repository.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/extensions.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:gwacheonhs_app/widgets/custom_error.dart';
import 'package:gwacheonhs_app/widgets/fallback_container.dart';
import 'package:gwacheonhs_app/widgets/loading_indicator.dart';
import 'package:gwacheonhs_app/widgets/timetable_list.dart';
import 'package:hive/hive.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with SingleTickerProviderStateMixin {
  var box = Hive.box('preferences');
  DateTime date = DateTime.now();
  Future<Timetable> timetable;
  TabController _controller;
  List<Tab> dayBuilder = [
    Tab(text: '월요일'),
    Tab(text: '화요일'),
    Tab(text: '수요일'),
    Tab(text: '목요일'),
    Tab(text: '금요일'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: dayBuilder.length, vsync: this);
    timetable = TimetableRepository().getTimetable(
        schoolGrade: box.get('grade', defaultValue: 1),
        schoolClass: box.get('class', defaultValue: 1),
        year: date.year,
        from: 20201026,
        to: 20201030);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text("시간표", style: CustomStyle.appBarTitle),
            SizedBox(width: 8),
            Text(
              "2020년 10월 12일 ~ 10월 16일",
              style: CustomStyle.appBarSubtitle,
            ),
          ],
        ),
      ),
      body: FutureBuilder<Timetable>(
        future: timetable,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingIndicator();
              break;
            default:
              if (!snapshot.hasData) {
                return FallbackContainer(
                    text: "시간표가 없습니다.", icon: EvaIcons.clock);
              }
              if (snapshot.hasError ||
                  (snapshot.data.result != null &&
                      snapshot.data.result.code.startsWith('ERROR'))) {
                return CustomError(
                    message: "시간표를 불러오는 중 오류가 발생했습니다.",
                    error: snapshot.data.result.message);
              } else {
                // print(snapshot.data.hisTimetable[1].toJson());
                var data = snapshot.data.hisTimetable[1].row;
                final dataGroup = data.groupBy((m) => m.timetableDate);
                var timetableList = dataGroup.values.toList();
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _controller,
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle:
                            TextStyle(fontWeight: FontWeight.normal),
                        labelColor: Colors.black87,
                        labelStyle: TextStyle(fontWeight: FontWeight.w700),
                        indicator: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tabs: dayBuilder,
                      ),
                      Container(height: 10),
                      Expanded(
                        child: TabBarView(
                          controller: _controller,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            TimetableList(
                                timetableList: timetableList, dayIndex: 0),
                            TimetableList(
                                timetableList: timetableList, dayIndex: 1),
                            TimetableList(
                                timetableList: timetableList, dayIndex: 2),
                            TimetableList(
                                timetableList: timetableList, dayIndex: 3),
                            TimetableList(
                                timetableList: timetableList, dayIndex: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
