import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/notice_detail.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/url_handler.dart';

class AttachmentsContainer extends StatelessWidget {
  AttachmentsContainer({@required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Text(
          "첨부파일 (${post.attachments.length})",
          style: CustomStyle.attachmentsHeader,
        ),
        Container(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: post.attachments.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(post.attachments[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: CustomStyle.attachmentsHeader),
                      ),
                    ),
                    GestureDetector(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          child: Icon(EvaIcons.download, color: Colors.white),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CustomColor.cyan,
                          ),
                        ),
                      ),
                      onTap: () {
                        UrlHandler.launchBrowser(post.attachments[index].url);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
