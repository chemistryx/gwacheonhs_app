class NoticeDetail {
  bool status;
  String message;
  List<Post> post;

  NoticeDetail({bool status, String message, List<Post> post});

  NoticeDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['post'] != null) {
      post = new List<Post>();
      json['post'].forEach((v) {
        post.add(new Post.fromJson(v));
      });
    }
  }
}

class Post {
  String content;
  String raw;
  List<Attachments> attachments;
  String url;

  Post({String content, String raw, List<Attachments> attachments, String url});

  Post.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    raw = json['raw'];
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    url = json['url'];
  }
}

class Attachments {
  String title;
  String url;

  Attachments({String title, String url});

  Attachments.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
  }
}
