import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwacheonhs_app/pages/home_page.dart';
import 'package:gwacheonhs_app/pages/meal_page.dart';
import 'package:gwacheonhs_app/pages/notice_page.dart';
import 'package:gwacheonhs_app/pages/schedule_page.dart';
import 'package:gwacheonhs_app/pages/timetable_page.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/widgets/connectivity_check.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Firebase.initializeApp();
  await Hive.openBox('preferences');
  await Hive.openBox('meal');
  await Hive.openBox('schedule');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runZonedGuarded<Future<void>>(() async {
    initializeDateFormatting().then((_) => runApp(App()));
  }, FirebaseCrashlytics.instance.recordError);
}

// ignore: must_be_immutable
class App extends StatefulWidget {
  int currentIndex = 0;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  App({Key key, this.currentIndex}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  Widget buildPageView() {
    return PageView(
      controller: widget.pageController,
      physics: ClampingScrollPhysics(),
      onPageChanged: (index) {
        _updateIndex(index);
      },
      children: <Widget>[
        HomePage(),
        NoticePage(),
        TimetablePage(),
        MealPage(),
        SchedulePage()
      ],
    );
  }

  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(EvaIcons.homeOutline),
          ),
          label: '홈',
          activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 3), child: Icon(EvaIcons.home))),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(EvaIcons.clipboardOutline),
          ),
          label: '공지사항',
          activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(EvaIcons.clipboard))),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(EvaIcons.clockOutline),
          ),
          label: '시간표',
          activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(EvaIcons.clock))),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(EvaIcons.pieChartOutline),
          ),
          label: '급식',
          activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(EvaIcons.pieChart2))),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(EvaIcons.calendarOutline),
          ),
          label: '일정',
          activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(EvaIcons.calendar))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      builder: (context, child) {
        return ScrollConfiguration(
            behavior: CustomScrollBehavior(), child: child);
      },
      title: "과천고등학교",
      theme: ThemeData(
          primaryColor: CustomColor.cyan,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(brightness: Brightness.light),
          canvasColor: Colors.white),
      home: _buildMainPage(),
    );
  }

  Widget _buildMainPage() {
    return Scaffold(
      body: ConnectivityCheck(
        child: buildPageView(),
      ),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          unselectedItemColor: Colors.black87,
          selectedItemColor: Colors.black87,
          unselectedFontSize: 13,
          selectedFontSize: 13,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
          type: BottomNavigationBarType.fixed,
          onTap: _handleBottomTap,
          currentIndex: widget.currentIndex ?? 0,
          items: buildBottomNavigationBarItems(),
        ),
      ),
    );
  }

  void _updateIndex(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  void _handleBottomTap(int index) {
    setState(() {
      widget.currentIndex = index;
      widget.pageController.jumpToPage(index);
    });
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
