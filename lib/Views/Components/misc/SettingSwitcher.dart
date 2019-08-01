import 'package:flutter/material.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class SettingSwitcher extends StatelessWidget {

  final String title;
  final String desc;
  final ValueChanged<bool> callback;
  final bool isVal;

  SettingSwitcher({@required this.title, @required this.desc, @required this.callback, @required this.isVal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10,15,10,10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).primaryTextTheme.subtitle
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      UserLanguage.of(context).desc("themeSetting"),
                      style: Theme.of(context).primaryTextTheme.body1
                    ),
                  ),
                ),

                Switch(
                  onChanged: callback,
                  value: isVal,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}