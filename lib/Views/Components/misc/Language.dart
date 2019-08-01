import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/NerbApp.dart';
import 'package:nerb/Views/Components/Collections/Items/LanguageItem.dart';

class Language extends StatefulWidget {

  Language();

  @override
  _LanguageState createState() => new _LanguageState();
}

class _LanguageState extends State<Language> {

  List<String> langs = [ConstantCollections.LANGUAGE_EN, ConstantCollections.LANGUAGE_ID];
  List<String> images = ["assets/ic_usa.png","assets/ic_id.png"];
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            UserLanguage.of(context).label('language'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).primaryTextTheme.subtitle
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5 ,bottom: 10),
            child: Text(
              UserLanguage.of(context).desc("languageSetting"),
              style: Theme.of(context).primaryTextTheme.body1
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: langs.map((lg){
              return LanguageItem(
                image: images[langs.indexOf(lg)],
                language: lg,
                selected: UserLanguage.of(context).currentLanguage,
                callback: onSelectedLanguage,
              );
            }).toList()
          )

        ],
      ),
    );
  }

  onSelectedLanguage(lg){
    if(mounted){
      setState(() {
        PreferenceHelper.instance.setStringValue(
          key: ConstantCollections.PREF_LANGUAGE,
          value: lg
        );
        NerbApp.of(context).onLocaleChanged(Locale(lg));
      });
    }
  }

}