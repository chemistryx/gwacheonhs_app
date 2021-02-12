import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {@required this.appBar,
      @required this.title,
      this.titleSpacing: 16,
      this.elevation: 0,
      this.actions});
  final AppBar appBar;
  final Widget title;
  final double titleSpacing;
  final double elevation;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: elevation,
      centerTitle: false,
      titleSpacing: titleSpacing,
      iconTheme: IconThemeData(color: Colors.black87),
      bottom: PreferredSize(
        child: Container(
          height: 8,
        ),
        preferredSize: Size.fromHeight(8),
      ),
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
