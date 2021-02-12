class Notice {
  bool status;
  String message;
  int limit;
  int page;
  int totalPages;
  List<Posts> posts;

  Notice(
      {bool status,
      String message,
      int limit,
      int page,
      int totalPages,
      List<Posts> posts});

  Notice.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    limit = json['limit'];
    page = json['page'];
    totalPages = json['total_pages'];
    if (json['posts'] != null) {
      posts = new List<Posts>();
      json['posts'].forEach((v) {
        posts.add(new Posts.fromJson(v));
      });
    }
  }
}

class Posts {
  int id;
  String title;
  String author;
  String createdAt;
  int views;
  bool hasAttachments;

  Posts(
      {int id,
      String title,
      String author,
      String createdAt,
      int views,
      bool hasAttachments});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    createdAt = json['created_at'];
    views = json['views'];
    hasAttachments = json['has_attachments'];
  }
}
