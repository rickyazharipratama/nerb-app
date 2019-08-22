import 'package:flutter/material.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class ErrorPlaceholder extends StatelessWidget {

  final String title;
  final String desc;
  final VoidCallback callback;
  final String buttonText;
  final isNeedButton;
  final IconData icon;

  ErrorPlaceholder({@required this.title, @required this.desc, this.callback, this.buttonText,this.isNeedButton : true, this.icon : Icons.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Icon(
            icon,
            color: Colors.red,
            size: 50,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.subhead,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ),
          
         isNeedButton ?
            InkWell(
              onTap: callback,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                color: Theme.of(context).buttonColor,
                child: Text(
                  buttonText != null ? buttonText : UserLanguage.of(context).button("retry"),
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
            )
         : Container()

        ],
      ),
    );
  }
}