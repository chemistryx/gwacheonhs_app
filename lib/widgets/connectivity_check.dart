import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/utils/custom_color.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';

class ConnectivityCheck extends StatelessWidget {
  ConnectivityCheck({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO: Add support for iOS devices
    return !Platform
            .isIOS // only check connectivity on android devices for now.
        ? StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == ConnectivityResult.none) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(EvaIcons.wifiOff, color: CustomColor.cyan, size: 36),
                      SizedBox(height: 10),
                      Text("네트워크에 연결할 수 없습니다.",
                          style: CustomStyle.settingsDefault),
                      Text("네트워크에 연결되어 있는지 확인해 주세요.",
                          style: CustomStyle.settingsDefault),
                    ],
                  ),
                );
              } else if (snapshot.data == null) {
                return Center();
              } else {
                return child;
              }
            })
        : child;
  }
}
