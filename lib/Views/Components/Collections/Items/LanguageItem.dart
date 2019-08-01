import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class LanguageItem extends StatelessWidget {

  final String language;
  final String selected;
  final ValueChanged<String> callback;
  final String image;

  LanguageItem({@required this.language, @required this.callback, this.selected, @required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: ColorCollections.shimmerBaseColor,
      splashColor: ColorCollections.shimmerHighlightColor,
      onTap: (){
        callback(language);
      },
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 75,
        height: 80,
        padding: const EdgeInsets.all(5),
        decoration: language == selected ? BoxDecoration(
          border: Border.all(
            color: ColorCollections.shimmerBaseColor,
            width: 1  
          ),
          borderRadius: BorderRadius.circular(5),
          color: language == selected ? ColorCollections.shimmerBaseColor : Colors.transparent,
        ): BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Center(
              child: Image.asset(
                image,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 2, right: 2),
                child: Text(
                  UserLanguage.of(context).label("language"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorCollections.titleColor,
                    fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor),
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}