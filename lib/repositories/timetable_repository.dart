import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gwacheonhs_app/models/timetable.dart';
import 'package:gwacheonhs_app/utils/constants.dart';

class TimetableRepository {
  Future<Timetable> getTimetable(
      {int schoolGrade = 1,
      int schoolClass = 1,
      int year,
      int from,
      int to}) async {
    Response response = await Dio().get(Constants.NEIS_API_TIMETABLE_URL +
        "&GRADE=$schoolGrade&CLASS_NM=$schoolClass&AY=$year&TI_FROM_YMD=$from&TI_TO_YMD=$to");
    var timetable = Timetable.fromJson(json.decode(response.data));

    return timetable;
  }
}
