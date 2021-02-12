import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/url_handler.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:package_info/package_info.dart';

class AppInfoPage extends StatelessWidget {
  final PackageInfo packageInfo;
  AppInfoPage({Key key, this.packageInfo}) : super(key: key);
  final appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: appBar,
        title: Text("앱 정보", style: CustomStyle.appBarTitle),
        titleSpacing: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Container()),
            GestureDetector(
              child: Image.asset('assets/icon.png', height: 82),
              onLongPress: () =>
                  UrlHandler.launchBrowser('https://chemistryx.me'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(packageInfo.appName, style: CustomStyle.appInfo),
            ),
            Text("버전 ${packageInfo.version}", style: CustomStyle.postDesc),
            Expanded(child: Container()),
            Container(height: appBar.preferredSize.height), // appbar height
          ],
        ),
      ),
    );
  }
}
