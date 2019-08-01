import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {

  final String value;
  SectionTitle.withText({this.value}) : assert(value != null);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.left,
      style: Theme.of(context).primaryTextTheme.title
    );
  }
}