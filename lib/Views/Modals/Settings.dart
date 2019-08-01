import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/StringHelper.dart';
import 'package:nerb/Views/Components/misc/Language.dart';
import 'package:nerb/Views/Components/misc/Radius.dart';

class Settings extends StatefulWidget {
  final String language;

  Settings({@required this.language});

  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {

  String lang;

  @override
  void initState() {
    super.initState();
    this.lang = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              StringHelper.instance.getCollections[this.lang]['labelSetting'].toUpperCase(),
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorCollections.shimmerHighlightColor,
                fontSize: FontSizeHelper.titleSectionSize(scale: MediaQuery.of(context).textScaleFactor),
                fontWeight: FontWeight.w500
              ),
            ),
          ),

          Radius(
            language: this.lang
          ),

          Language(
            language: this.lang,
            callback: (language){
                if(mounted){
                  setState(() {
                    this.lang = language;
                  });
                }
            },
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Text(
              StringHelper.instance.getCollections[this.lang]['labelAbout'].toUpperCase(),
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorCollections.shimmerHighlightColor,
                fontSize: FontSizeHelper.titleSectionSize(scale: MediaQuery.of(context).textScaleFactor),
                fontWeight: FontWeight.w500
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              StringHelper.instance.getCollections[this.lang]['labelVersion'] + " "+ConstantCollections.VERSION,
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorCollections.descColor,
                fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor),
                fontWeight: FontWeight.w500
              ),
            ),
          ),

      ],
    );
  }
}