class ClassData {
  List<ClassInfo> classInfo;

  ClassData({this.classInfo});

  ClassData.fromJson(Map<String, dynamic> json) {
    if (json['classInfo'] != null) {
      classInfo = new List<ClassInfo>();
      json['classInfo'].forEach((v) {
        classInfo.add(new ClassInfo.fromJson(v));
      });
    }
  }
}

class ClassInfo {
  List<Head> head;
  List<ClassRow> row;

  ClassInfo({this.head, this.row});

  ClassInfo.fromJson(Map<String, dynamic> json) {
    if (json['head'] != null) {
      head = new List<Head>();
      json['head'].forEach((v) {
        head.add(new Head.fromJson(v));
      });
    }
    if (json['row'] != null) {
      row = new List<ClassRow>();
      json['row'].forEach((v) {
        row.add(new ClassRow.fromJson(v));
      });
    }
  }
}

class Head {
  int listTotalCount;
  Result result;

  Head({this.listTotalCount, this.result});

  Head.fromJson(Map<String, dynamic> json) {
    listTotalCount = json['list_total_count'];
    result =
        json['RESULT'] != null ? new Result.fromJson(json['RESULT']) : null;
  }
}

class Result {
  String code;
  String message;

  Result({this.code, this.message});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['CODE'];
    message = json['MESSAGE'];
  }
}

class ClassRow {
  String grade;
  String classNumber;
  String updatedAt;

  ClassRow({this.grade, this.classNumber, this.updatedAt});

  ClassRow.fromJson(Map<String, dynamic> json) {
    grade = json['GRADE'];
    classNumber = json['CLASS_NM'];
    updatedAt = json['LOAD_DTM'];
  }
}
