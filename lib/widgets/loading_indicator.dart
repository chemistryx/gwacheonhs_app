import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.isInScrollView: false});

  final bool isInScrollView;

  @override
  Widget build(BuildContext context) {
    var height = isInScrollView
        ? MediaQuery.of(context).size.height / 1.5
        : MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CupertinoActivityIndicator()],
      ),
    );
  }
}
