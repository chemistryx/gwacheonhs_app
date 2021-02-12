class Constants {
  static const NEIS_API_KEY = "YOUR_API_KEY";
  static const SCHOOL_REGION = "J10"; // 경기도교육청
  static const SCHOOL_CODE = "7530048"; // 과천고등학교

  static const NEIS_API_BASE_URL = "https://open.neis.go.kr/hub/";
  static const GHS_API_BASE_URL = "YOUR_API_BASE_URL";

  static const NEIS_API_MEAL_URL = Constants.NEIS_API_BASE_URL +
      "mealServiceDietInfo?Key=${Constants.NEIS_API_KEY}&Type=json&ATPT_OFCDC_SC_CODE=${Constants.SCHOOL_REGION}&SD_SCHUL_CODE=${Constants.SCHOOL_CODE}&MLSV_YMD=";
  static const NEIS_API_TIMETABLE_URL = Constants.NEIS_API_BASE_URL +
      "hisTimetable?key=${Constants.NEIS_API_KEY}&type=json&ATPT_OFCDC_SC_CODE=${Constants.SCHOOL_REGION}&SD_SCHUL_CODE=${Constants.SCHOOL_CODE}";
  static const NEIS_API_SCHEDULE_URL = Constants.NEIS_API_BASE_URL +
      "SchoolSchedule?Key=${Constants.NEIS_API_KEY}&Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=${Constants.SCHOOL_REGION}&SD_SCHUL_CODE=${Constants.SCHOOL_CODE}";
  static const NEIS_API_CLASS_INFO_URL = Constants.NEIS_API_BASE_URL +
      "classInfo?key=${Constants.NEIS_API_KEY}&type=json&ATPT_OFCDC_SC_CODE=${Constants.SCHOOL_REGION}&SD_SCHUL_CODE=${Constants.SCHOOL_CODE}&AY=";

  static const GHS_API_NOTICE_URL = Constants.GHS_API_BASE_URL + "notice/";
  static const GHS_API_NOTICE_DETAIL_URL =
      Constants.GHS_API_BASE_URL + "notice_detail/";
}
