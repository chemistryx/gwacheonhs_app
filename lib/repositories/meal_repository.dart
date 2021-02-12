import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gwacheonhs_app/models/meal.dart';
import 'package:gwacheonhs_app/utils/constants.dart';

class MealRepository {
  Future<Meal> getMeal({int year, int month}) async {
    Response response = await Dio().get(Constants.NEIS_API_MEAL_URL +
        "$year${month.toString().padLeft(2, '0')}");
    var meal = Meal.fromJson(json.decode(response.data));

    return meal;
  }
}
