import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/NerbApp.dart';
import 'package:nerb/Views/Components/Buttons/SettingButton.dart';
import 'package:nerb/Views/Components/misc/Language.dart';
import 'package:nerb/Views/Components/misc/Radius.dart';
import 'package:nerb/Views/Components/misc/SettingSwitcher.dart';
import 'package:nerb/Views/Pages/WebPage.dart';

class Settings extends StatefulWidget {

  Settings();

  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  initiateData() async{
    bool isTheme = await PreferenceHelper.instance.isHaveVal(key: ConstantCollections.PREF_IS_DARK_THEME);
    if(mounted){
      setState(() {
        isDarkTheme = isTheme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                UserLanguage.of(context).label('setting'),
                softWrap: true,
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.title
              ),
            ),

            Radius(),

            Language(),

            SettingSwitcher(
              callback: changingTheme,
              title: UserLanguage.of(context).label("theme"),
              desc: UserLanguage.of(context).desc("themeSetting"),
              isVal: MediaQuery.of(context).platformBrightness == Brightness.dark ? true : isDarkTheme,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Text(
                UserLanguage.of(context).label('about'),
                softWrap: true,
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.title
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                UserLanguage.of(context).label('version')+" "+ConstantCollections.VERSION,
                softWrap: true,
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.subhead
              ),
            ),

            Padding(
              padding: const prefix0.EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                UserLanguage.of(context).desc("appAbout"),
                softWrap: true,
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            ),

            SettingButton(
              title: UserLanguage.of(context).title("privacyPolicy"),
              desc: UserLanguage.of(context).desc("privacyPolicy"),
              callback: (){
                NerbNavigator.instance.push(context,
                  child: WebPage(
                    title: UserLanguage.of(context).title("privacyPolicy"),
                    url: "https://flutter.dev/",
                  )
                );
              },
            ),

            SettingButton(
              title: UserLanguage.of(context).title("termCondition"),
              desc: UserLanguage.of(context).desc("termCondition"),
              callback: (){},
            ),

            SettingButton(
              title: UserLanguage.of(context).title("thirdPartySoftware"),
              desc: UserLanguage.of(context).desc("thirdPartySoftware"),
              callback: (){},
            ),

            SettingButton(
              title: UserLanguage.of(context).title("credits"),
              desc: UserLanguage.of(context).desc("credits"),
              callback: (){},
            )

        ],
      ),
    );
  }

  changingTheme(isVal){
    if(mounted){
      setState(() {
        isDarkTheme = isVal;
        NerbApp.of(context).changingTheme(isVal);
      });
    }
  }

}