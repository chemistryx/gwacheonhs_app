import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gwacheonhs_app/models/class_data.dart';
import 'package:gwacheonhs_app/utils/constants.dart';

class ClassInfoRepository {
  Future<ClassData> getClassInfo({int year}) async {
    Response response =
        await Dio().get(Constants.NEIS_API_CLASS_INFO_URL + year.toString());
    var classInfo = ClassData.fromJson(json.decode(response.data));

    return classInfo;
  }
}
