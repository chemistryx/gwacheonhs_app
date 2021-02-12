import 'package:dio/dio.dart';
import 'package:gwacheonhs_app/models/notice_detail.dart';
import 'package:gwacheonhs_app/utils/constants.dart';

class NoticeDetailRepository {
  Future<NoticeDetail> getNoticeDetail({int id}) async {
    Response response =
        await Dio().get(Constants.GHS_API_NOTICE_DETAIL_URL + id.toString());
    var noticeDetail = NoticeDetail.fromJson(response.data);

    return noticeDetail;
  }
}
