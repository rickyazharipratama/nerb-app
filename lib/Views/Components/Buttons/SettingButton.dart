import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback callback;

  SettingButton({@required this.title, @required this.desc, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).highlightColor,
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      title,
                      style: Theme.of(context).primaryTextTheme.subtitle,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        desc,
                        style: Theme.of(context).primaryTextTheme.body1,
                      ),
                    )
                  ],
                ),
              ),
            ),

            Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).buttonColor,
              size: 20,
            )

          ],
        ),
      ),
    );
  }
}