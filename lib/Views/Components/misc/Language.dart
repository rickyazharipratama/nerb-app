import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/StringHelper.dart';
import 'package:nerb/Views/Components/Collections/Items/LanguageItem.dart';

class Language extends StatefulWidget {

  final String language;
  final ValueChanged<String> callback;

  Language({@required this.language, @required this.callback});

  @override
  _LanguageState createState() => new _LanguageState();
}

class _LanguageState extends State<Language> {

  String language;
  List<String> langs = [ConstantCollections.LANGUAGE_EN, ConstantCollections.LANGUAGE_ID];
  List<String> images = ["assets/ic_usa.png","assets/ic_id.png"];
  @override
  void initState() {
    super.initState();
    this.language = widget.language;
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            StringHelper.instance.getCollections[widget.language]['labelLanguage'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorCollections.titleColor,
              fontSize: FontSizeHelper.titleList(scale: MediaQuery.of(context).textScaleFactor),
              fontWeight: FontWeight.w500
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5 ,bottom: 10),
            child: Text(
              StringHelper.instance.getCollections[widget.language]['descLanguageSetting'],
              style: TextStyle(
                color: ColorCollections.descColor,
                fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor),
                fontWeight: FontWeight.w300
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: langs.map((lg){
              return LanguageItem(
                image: images[langs.indexOf(lg)],
                language: lg,
                selected: this.language,
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
        this.language = lg;
        PreferenceHelper.instance.setStringValue(
          key: ConstantCollections.PREF_LANGUAGE,
          value: lg
        );
        widget.callback(lg);
      });
    }
  }

}