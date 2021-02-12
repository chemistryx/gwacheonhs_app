import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/notice.dart';
import 'package:gwacheonhs_app/repositories/notice_repository.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:gwacheonhs_app/widgets/custom_error.dart';
import 'package:gwacheonhs_app/widgets/fallback_container.dart';
import 'package:gwacheonhs_app/widgets/loading_indicator.dart';
import 'package:gwacheonhs_app/widgets/notice_item.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage>
    with AutomaticKeepAliveClientMixin<NoticePage> {
  ScrollController _controller = ScrollController();
  Future<Notice> notice;
  List<Posts> posts;
  int _page = 1, _totalPages = 0;

  @override
  void initState() {
    super.initState();
    notice = NoticeRepository().getNotice(page: 1, limit: 15);
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text("공지사항", style: CustomStyle.appBarTitle),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: FutureBuilder<Notice>(
          future: notice,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return LoadingIndicator();
                break;
              default:
                if (!snapshot.hasData) {
                  return FallbackContainer(
                      text: "공지사항이 없습니다.", icon: EvaIcons.clipboardOutline);
                }
                if (snapshot.hasError || !snapshot.data.status) {
                  return CustomError(
                      message: "공지사항을 불러오는 중 오류가 발생했습니다.",
                      error: snapshot.data.message);
                } else {
                  _totalPages = snapshot.data.totalPages;
                  posts = snapshot.data.posts;
                  return RefreshIndicator(
                    child: _buildNoticeList(posts),
                    onRefresh: _handleRefresh,
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget _buildNoticeList(List<Posts> posts) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      controller: _controller,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NoticeItem(post: posts[index]),
            posts.length - 1 != index ? Divider() : SizedBox.shrink()
          ],
        );
      },
    );
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _page < _totalPages) {
      List<Posts> newPosts = await NoticeRepository()
          .getNotice(page: ++_page, limit: 15)
          .then((value) => value.posts);
      setState(() => posts.addAll(newPosts));
    }
  }

  Future<void> _handleRefresh() async {
    Notice freshNotice = await NoticeRepository().getNotice(page: 1, limit: 15);
    setState(() {
      notice = Future.value(freshNotice);
      posts = freshNotice.posts;
      _page = 1;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
