import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Views/Components/misc/Language.dart';
import 'package:nerb/Views/Components/misc/Radius.dart';

class Settings extends StatefulWidget {

  Settings();

  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              UserLanguage.of(context).label('setting'),
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

          Radius(),

          Language(),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Text(
              UserLanguage.of(context).label('about'),
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
              UserLanguage.of(context).label('version')+" "+ConstantCollections.VERSION,
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