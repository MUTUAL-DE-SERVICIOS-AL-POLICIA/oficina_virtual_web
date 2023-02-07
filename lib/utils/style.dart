import 'package:flutter/material.dart';

ThemeData styleLigth() {
  return ThemeData.light().copyWith(
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xff419388))),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xff419388),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
          iconColor: Colors.black,
          errorStyle: const TextStyle(fontSize: 15).apply(color: Colors.red, fontFamily: 'Poppins'),
        ),
    buttonTheme: ButtonThemeData(
        padding: const EdgeInsets.all(0),
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textTheme: ButtonTextTheme.accent),
    textTheme: ThemeData.light()
        .textTheme
        .copyWith(
          bodyText1: const TextStyle(color: Color(0xff21232A), fontSize: 17),
          bodyText2: const TextStyle(color: Color(0xff21232A), fontSize: 17),
          button: const TextStyle(fontSize: 17),
        )
        .apply(
          fontFamily: 'Poppins',
        ),
    primaryTextTheme: ThemeData.light()
        .textTheme
        .copyWith(
          bodyText1: const TextStyle(fontSize: 20),
          bodyText2: const TextStyle(fontSize: 20),
        )
        .apply(fontFamily: 'Poppins'),
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xff419388), secondary: const Color(0xff419388)),
    primaryColor: const Color(0xff419388),
    cardColor: const Color(0xfff2f2f2),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    dialogBackgroundColor: const Color(0xfff2f2f2),
    scaffoldBackgroundColor: const Color(0xfff2f2f2),
    primaryColorDark: const Color(0xff21232A),
    iconTheme: const IconThemeData(color: Color(0xff419388)),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0)
        .copyWith(titleTextStyle: const TextStyle(color: Colors.black), iconTheme: const IconThemeData(color: Colors.black))
  );
}
