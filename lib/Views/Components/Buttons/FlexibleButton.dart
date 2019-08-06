import 'package:flutter/material.dart';

class FlexibleButton extends StatelessWidget {

  final String title;
  final VoidCallback callback;
  final double width;
  final double height;
  final Color background;

  FlexibleButton({@required this.title, @required this.callback, @required this.width, @required this.height, this.background : Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1,
          ),
        ),
      ),
    );
  }
}