class Timetable {
  List<HisTimetable> hisTimetable;
  Result result;

  Timetable({this.hisTimetable, this.result});

  Timetable.fromJson(Map<String, dynamic> json) {
    if (json['hisTimetable'] != null) {
      hisTimetable = new List<HisTimetable>();
      json['hisTimetable'].forEach((v) {
        hisTimetable.add(new HisTimetable.fromJson(v));
      });
    } else {
      result =
          json['RESULT'] != null ? new Result.fromJson(json['RESULT']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hisTimetable != null) {
      data['hisTimetable'] = this.hisTimetable.map((v) => v.toJson()).toList();
    }
    data['RESULT'] = this.result != null ? this.result.toJson() : null;
    return data;
  }
}

class HisTimetable {
  List<Head> head;
  List<TimetableRow> row;

  HisTimetable({this.head, this.row});

  HisTimetable.fromJson(Map<String, dynamic> json) {
    if (json['head'] != null) {
      head = new List<Head>();
      json['head'].forEach((v) {
        head.add(new Head.fromJson(v));
      });
    }
    if (json['row'] != null) {
      row = new List<TimetableRow>();
      json['row'].forEach((v) {
        row.add(new TimetableRow.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head.map((v) => v.toJson()).toList();
    }
    if (this.row != null) {
      data['row'] = this.row.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_total_count'] = this.listTotalCount;
    data['RESULT'] = this.result != null ? this.result.toJson() : null;

    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODE'] = this.code;
    data['MESSAGE'] = this.message;

    return data;
  }
}

class TimetableRow {
  String timetableDate;
  String timetablePeriod;
  String timetableSubject;
  String updatedAt;

  TimetableRow(
      {this.timetableDate,
      this.timetablePeriod,
      this.timetableSubject,
      this.updatedAt});

  TimetableRow.fromJson(Map<String, dynamic> json) {
    timetableDate = json['ALL_TI_YMD'];
    timetablePeriod = json['PERIO'];
    timetableSubject = json['ITRT_CNTNT'];
    updatedAt = json['LOAD_DTM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ALL_TI_YMD'] = this.timetableDate;
    data['PERIO'] = this.timetablePeriod;
    data['ITRT_CNTNT'] = this.timetableSubject;
    data['LOAD_DTM'] = this.updatedAt;

    return data;
  }
}
