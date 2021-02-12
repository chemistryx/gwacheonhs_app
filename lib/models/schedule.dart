class Schedule {
  List<SchoolSchedule> schoolSchedule;
  Result result;

  Schedule({this.schoolSchedule, this.result});

  Schedule.fromJson(Map<String, dynamic> json) {
    if (json['SchoolSchedule'] != null) {
      schoolSchedule = new List<SchoolSchedule>();
      json['SchoolSchedule'].forEach((v) {
        schoolSchedule.add(new SchoolSchedule.fromJson(v));
      });
    } else {
      result =
          json['RESULT'] != null ? new Result.fromJson(json['RESULT']) : null;
    }
  }
}

class SchoolSchedule {
  List<Head> head;
  List<ScheduleRow> row;

  SchoolSchedule({this.head, this.row});

  SchoolSchedule.fromJson(Map<String, dynamic> json) {
    if (json['head'] != null) {
      head = new List<Head>();
      json['head'].forEach((v) {
        head.add(new Head.fromJson(v));
      });
    }
    if (json['row'] != null) {
      row = new List<ScheduleRow>();
      json['row'].forEach((v) {
        row.add(new ScheduleRow.fromJson(v));
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

class ScheduleRow {
  String eventDate; // 학사일자
  String eventName; // 행사명
  String updatedAt; // 등록일자

  ScheduleRow({this.eventDate, this.eventName, this.updatedAt});

  ScheduleRow.fromJson(Map<String, dynamic> json) {
    eventDate = json['AA_YMD'];
    eventName = json['EVENT_NM'];
    updatedAt = json['LOAD_DTM'];
  }
}
