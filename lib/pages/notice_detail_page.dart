import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:gwacheonhs_app/models/notice.dart';
import 'package:gwacheonhs_app/models/notice_detail.dart';
import 'package:gwacheonhs_app/repositories/notice_detail_repository.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/url_handler.dart';
import 'package:gwacheonhs_app/widgets/attachments_container.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:gwacheonhs_app/widgets/custom_error.dart';
import 'package:gwacheonhs_app/widgets/fallback_container.dart';
import 'package:gwacheonhs_app/widgets/loading_indicator.dart';
import 'package:intl/intl.dart';

class NoticeDetailPage extends StatefulWidget {
  final Posts postInfo;
  NoticeDetailPage({Key key, this.postInfo}) : super(key: key);

  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  Future<NoticeDetail> noticeDetail;

  @override
  void initState() {
    super.initState();
    noticeDetail =
        NoticeDetailRepository().getNoticeDetail(id: widget.postInfo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text("공지사항", style: CustomStyle.appBarTitle),
        titleSpacing: 0,
      ),
      body: _buildParsedContent(),
    );
  }

  Widget _buildParsedContent() {
    String formattedDate = DateFormat('yyyy.MM.dd')
        .format(DateTime.parse(widget.postInfo.createdAt));
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.postInfo.title, style: CustomStyle.postTitle),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.postInfo.author + " | " + formattedDate,
                    style: CustomStyle.postDesc),
                Row(
                  children: <Widget>[
                    Icon(EvaIcons.eyeOutline, size: 16, color: Colors.grey),
                    Text(" ${widget.postInfo.views}",
                        style: CustomStyle.postDesc),
                  ],
                ),
              ],
            ),
            Divider(),
            Container(
              child: FutureBuilder(
                  future: noticeDetail,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return LoadingIndicator(isInScrollView: true);
                        break;
                      default:
                        if (!snapshot.hasData) {
                          // should never happen
                          return FallbackContainer(
                              text: "내용이 없습니다.",
                              icon: EvaIcons.clipboardOutline);
                        }
                        if (snapshot.hasError || !snapshot.data.status) {
                          return CustomError(
                              message: "내용을 불러오는 중 오류가 발생했습니다.",
                              error: snapshot.data.message);
                        } else {
                          return Column(
                            children: <Widget>[
                              _buildContent(snapshot.data.post[0]),
                              _buildAttachments(snapshot.data.post[0]),
                            ],
                          );
                        }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments(Post post) {
    return (post.attachments.isNotEmpty)
        ? AttachmentsContainer(post: post)
        : SizedBox();
  }

  Widget _buildContent(Post post) {
    // FIXME: temp fix for text scale issue on Android devices
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Html(
        data: post.raw,
        onLinkTap: (url) {
          UrlHandler.launchBrowser(url);
        },
        // FIXME: temporary disable table
        // Related: https://github.com/Sub6Resources/flutter_html/issues/213
        customRender: {
          "table": (RenderContext context, Widget child, attributes, _) {
            return GestureDetector(
              onTap: () {
                UrlHandler.launchBrowser(post.url);
              },
              child: Container(
                alignment: Alignment(0, 0),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomColor.cyan,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: <Widget>[
                    Text("해당 요소를 표시할 수 없습니다.",
                        style: CustomStyle.unsupportedElement),
                    Text("이곳을 눌러 원본 내용을 확인해주세요.",
                        style: CustomStyle.unsupportedElement)
                  ],
                ),
              ),
            );
          },
        },
      ),
    );
  }
}
