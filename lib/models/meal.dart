class Meal {
  List<MealServiceDietInfo> mealServiceDietInfo;
  Result result;

  Meal({this.mealServiceDietInfo, this.result});

  Meal.fromJson(Map<String, dynamic> json) {
    if (json['mealServiceDietInfo'] != null) {
      mealServiceDietInfo = new List<MealServiceDietInfo>();
      json['mealServiceDietInfo'].forEach((v) {
        mealServiceDietInfo.add(new MealServiceDietInfo.fromJson(v));
      });
    } else {
      result =
          json['RESULT'] != null ? new Result.fromJson(json['RESULT']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mealServiceDietInfo != null) {
      data['mealServiceDietInfo'] =
          this.mealServiceDietInfo.map((v) => v.toJson()).toList();
    }
    data['RESULT'] = this.result != null ? this.result.toJson() : null;
    return data;
  }
}

class MealServiceDietInfo {
  List<Head> head;
  List<MealRow> row;

  MealServiceDietInfo({this.head, this.row});

  MealServiceDietInfo.fromJson(Map<String, dynamic> json) {
    if (json['head'] != null) {
      head = new List<Head>();
      json['head'].forEach((v) {
        head.add(new Head.fromJson(v));
      });
    }
    if (json['row'] != null) {
      row = new List<MealRow>();
      json['row'].forEach((v) {
        row.add(new MealRow.fromJson(v));
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

class MealRow {
  String mealDate; // 급식일자
  String mealName; // 요리명
  String updatedAt; // 등록일자

  MealRow({this.mealDate, this.mealName, this.updatedAt});

  MealRow.fromJson(Map<String, dynamic> json) {
    mealDate = json['MLSV_YMD'];
    mealName = json['DDISH_NM'];
    updatedAt = json['LOAD_DTM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MLSV_YMD'] = this.mealDate;
    data['DDISH_NM'] = this.mealName;
    data['LOAD_DTM'] = this.updatedAt;

    return data;
  }
}
