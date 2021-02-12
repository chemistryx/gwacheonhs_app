import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';

abstract class CustomStyle {
  static const TextStyle defaultDate = TextStyle(
    color: Colors.grey,
    fontSize: 28,
    letterSpacing: -1,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle currentDate = TextStyle(
    color: CustomColor.yellow,
    fontSize: 28,
    letterSpacing: -1,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle defaultDay = TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle currentDay = TextStyle(
    color: CustomColor.yellow,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle defaultMealDesc = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle emptyMealDesc = TextStyle(
    color: Colors.white70,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.25,
  );

  static const TextStyle postListTitle = TextStyle(
    color: Colors.black87,
    fontSize: 18.5,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appBarTitle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w900,
    fontSize: 25,
  );

  static const TextStyle appBarHomeTitle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w900,
    fontSize: 25,
  );

  static const TextStyle appBarSubtitle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const TextStyle postTitle = TextStyle(
    color: Colors.black87,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle postDesc = TextStyle(
    color: Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle attachmentsHeader = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardTitle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    letterSpacing: -1,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitleDark = TextStyle(
    color: Colors.black87,
    fontSize: 24,
    letterSpacing: -1,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardContent = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle cardContentDark = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle cardContentSubject = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle cardContentGrey = TextStyle(
    color: Colors.black54,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle tableFirst = TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tableHeader = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tableDefault = TextStyle(
    color: Colors.black87,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle snackBar = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle settingsClickable = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: CustomColor.cyan,
  );

  static const TextStyle settingsDefault = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  static const TextStyle appInfo = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Colors.black87,
  );

  static const TextStyle calendarHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle calendarEventsMarker = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle calendarDefaultDate = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle badgeDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle unsupportedElement = TextStyle(
    color: Colors.white70,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.25,
  );

  static const TextStyle helpTitle = TextStyle(
    fontWeight: FontWeight.w700,
  );
}
