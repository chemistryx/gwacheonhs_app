import 'package:dio/dio.dart';
import 'package:gwacheonhs_app/models/notice.dart';
import 'package:gwacheonhs_app/utils/constants.dart';

class NoticeRepository {
  Future<Notice> getNotice({int page = 1, int limit = 15}) async {
    Response response =
        await Dio().get(Constants.GHS_API_NOTICE_URL + "$limit/$page");
    var notice = Notice.fromJson(response.data);

    return notice;
  }
}
