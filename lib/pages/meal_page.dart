import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/meal.dart';
import 'package:gwacheonhs_app/repositories/meal_repository.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:gwacheonhs_app/widgets/custom_error.dart';
import 'package:gwacheonhs_app/widgets/fallback_container.dart';
import 'package:gwacheonhs_app/widgets/loading_indicator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MealPage extends StatefulWidget {
  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage>
    with AutomaticKeepAliveClientMixin<MealPage> {
  var box = Hive.box('meal');
  Future<Meal> meal;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    meal = MealRepository().getMeal(year: now.year, month: now.month);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text("급식", style: CustomStyle.appBarTitle),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Meal>(
          future: meal,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return LoadingIndicator();
                break;
              default:
                if (!snapshot.hasData) {
                  if (box.length == 0) {
                    return FallbackContainer(
                        text: "급식을 불러올 수 없습니다.\n네트워크 연결을 확인 후 다시 시도해주세요.",
                        icon: EvaIcons.wifiOffOutline);
                  } else {
                    print("load from Hive::::");
                    return _buildMealList(
                        Meal.fromJson(json.decode(box.get('data'))));
                  }
                }
                // additional null check for the result because there are two cases:
                // if result is success, the result element is located under 'mealServiceDietInfo'
                // otherwise, the result element is located in the root of the json.
                if (snapshot.hasError ||
                    (snapshot.data.result != null &&
                        snapshot.data.result.code.startsWith('ERROR'))) {
                  return CustomError(
                      message: "급식을 불러오는 중 오류가 발생했습니다.",
                      error: snapshot.data.result.message);
                } else {
                  print("load from web::::");
                  box.put('data', json.encode(snapshot.data));
                  return _buildMealList(snapshot.data);
                }
            }
          },
        ),
      ),
    );
  }

  Widget _buildMealList(Meal meal) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(top: 8),
      itemCount: meal.mealServiceDietInfo[1].row.length,
      itemBuilder: (context, index) {
        return _buildMealItem(meal, index);
      },
    );
  }

  Widget _buildMealItem(Meal meal, int index) {
    DateTime dateTime =
        DateTime.parse(meal.mealServiceDietInfo[1].row[index].mealDate);
    int year = dateTime.year;
    int month = dateTime.month;
    int date = dateTime.day;
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            margin: EdgeInsets.only(right: 10),
            child: Column(
              children: <Widget>[
                Text(
                  date.toString(),
                  style: date == DateTime.now().day
                      ? CustomStyle.currentDate
                      : CustomStyle.defaultDate,
                ),
                Text(
                  DateFormat.EEEE('ko_KR').format(DateTime(year, month, date)),
                  style: date == DateTime.now().day
                      ? CustomStyle.currentDay
                      : CustomStyle.defaultDay,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColor.yellow,
                boxShadow: [
                  BoxShadow(
                    color: CustomColor.yellow.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    meal.mealServiceDietInfo[1].row[index].mealName
                        .replaceAll(RegExp(r'\d|[.]|[*]'), '')
                        .split('<br/>')
                        .join('\n'),
                    style: CustomStyle.defaultMealDesc,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
