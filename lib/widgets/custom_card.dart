import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/main.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {this.vsync,
      this.index,
      this.title,
      this.badge,
      this.content,
      this.color});

  final TickerProvider vsync;
  final int index;
  final Widget title;
  final Widget content;
  final Widget badge;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index != null) {
          // HACK: set parent state from child
          var ancestralState = context.findAncestorStateOfType<State<App>>();
          // ignore: invalid_use_of_protected_member
          ancestralState.setState(() {
            ancestralState.widget.currentIndex = index;
            ancestralState.widget.pageController.jumpToPage(index);
          });
        }
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        vsync: vsync,
        child: Container(
          constraints: BoxConstraints(minHeight: 100),
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            title,
                            badge == null ? SizedBox() : badge,
                          ],
                        ),
                        SizedBox(height: 10),
                        content
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
