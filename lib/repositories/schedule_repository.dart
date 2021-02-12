import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gwacheonhs_app/models/schedule.dart';
import 'package:gwacheonhs_app/utils/constants.dart';

class ScheduleRepository {
  Future<Schedule> getSchedule() async {
    Response response = await Dio().get(Constants.NEIS_API_SCHEDULE_URL);
    var schedule = Schedule.fromJson(json.decode(response.data));

    return schedule;
  }
}
