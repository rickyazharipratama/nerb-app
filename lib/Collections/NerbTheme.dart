import 'package:flutter/material.dart';

class NerbTheme{

  ThemeData lightTheme;
  ThemeData darkTheme;


  NerbTheme(){
    lightTheme =  ThemeData(
      brightness: Brightness.light,
      backgroundColor: Color(0xfffefefe),
      cursorColor: Color(0xff101017),
      errorColor: Color(0xffca1818),
      focusColor: Color(0xff101017),
      hintColor: Color(0xff666666b),
      primaryTextTheme: TextTheme(
        title: TextStyle(
          fontSize:  21,
          color: Color(0xffc9c9c9),
          fontWeight: FontWeight.w500
        ),
        subtitle: TextStyle(
          fontSize: 19,
          color: Color(0xffa9a9a9),
          fontWeight: FontWeight.w500
        ),
        subhead: TextStyle(
          fontSize: 16,
          color: Color(0xff898989),
          fontWeight: FontWeight.w500
        ),
        body1: TextStyle(
          fontSize: 13,
          color: Color(0xff585858),
          fontWeight: FontWeight.w300
        ),
        display1: TextStyle(
          fontSize: 19,
          color: Colors.red,
          fontWeight: FontWeight.w500
        ),
        display2: TextStyle(
          fontSize: 13,
          color: Color(0xfff8f8f8),
          fontWeight: FontWeight.w300
        )
      ),
      buttonColor: Color(0xFF666666),
      highlightColor: Color(0xfff3f3f3),
      canvasColor: Color(0x77ffffff),
      dialogBackgroundColor: Color(0xaa000000)

    );

    darkTheme = ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Color(0xff252525),
      cursorColor: Color(0xfffefefe),
      errorColor: Color(0xffca1818),
      focusColor: Color(0xfffefefe),
      hintColor: Color(0xff666666b),
      primaryTextTheme: TextTheme(
        title: TextStyle(
          fontSize: 21,
          color: Color(0xffc6c6c6),
          fontWeight: FontWeight.w500
        ),
        subtitle: TextStyle(
          fontSize: 19,
          color: Color(0xffd9d9d9),
          fontWeight: FontWeight.w500
        ),
        subhead: TextStyle(
          fontSize: 16,
          color: Color(0xffe9e9e9),
          fontWeight: FontWeight.w500
        ),
        body1: TextStyle(
          fontSize: 13,
          color: Color(0xfff8f8f8),
          fontWeight: FontWeight.w300
        ),
        display1: TextStyle(
          fontSize: 19,
          color: Colors.red,
          fontWeight: FontWeight.w500
        ),
        display2: TextStyle(
          fontSize: 13,
          color: Color(0xff585858),
          fontWeight: FontWeight.w300
        )
      ),
      buttonColor: Color(0xffc6c6c6),
      highlightColor: Color(0xff454545),
      canvasColor: Color(0x77000000),
      dialogBackgroundColor: Color(0xaaffffff)
    );
  }

 static NerbTheme instance = NerbTheme();

}