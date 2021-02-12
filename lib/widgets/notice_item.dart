import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/notice.dart';
import 'package:gwacheonhs_app/pages/notice_detail_page.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:intl/intl.dart';

class NoticeItem extends StatelessWidget {
  NoticeItem({@required this.post});

  final Posts post;

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('yy.MM.dd').format(DateTime.parse(post.createdAt));
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) =>
                  NoticeDetailPage(postInfo: post),
            ),
          );
        },
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(0),
          title: Text(post.title, style: CustomStyle.postListTitle),
          subtitle: Row(
            children: [
              // HACK: fix weird line height
              Text(post.author + " ", style: CustomStyle.postDesc),
              SizedBox(width: 3),
              Text(formattedDate, style: CustomStyle.postDesc),
              SizedBox(width: 6),
              Text("조회 " + post.views.toString(), style: CustomStyle.postDesc),
              SizedBox(width: 6),
              post.hasAttachments
                  ? Icon(EvaIcons.attachOutline, size: 12, color: Colors.grey)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
