import 'package:flutter/material.dart';

PageTransitionsBuilder createTransition() {
  return const ZoomPageTransitionsBuilder();
}

ThemeData theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF041950),
  splashColor: Colors.grey.shade100,
  highlightColor: Colors.grey.shade300,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  backgroundColor: const Color(0xFFFFFFFF),

  // Define the default font family.
  fontFamily: 'SFProText',

  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 20.0,
        fontFamily: 'SFProText',
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.24,
        color: Color(0xFFE06437)),
    headline2: TextStyle(
        fontSize: 17.0,
        fontFamily: 'SFProText',
        fontWeight: FontWeight.w600,
        height: 1.08,
        letterSpacing: -0.41,
        color: Color(0xFF222222)),
    headline3: TextStyle(
        fontSize: 14.0,
        fontFamily: 'SFProText',
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.24,
        color: Color(0xFF000000)),
    bodyText1: TextStyle(
        fontSize: 16.0,
        fontFamily: 'SFProText',
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
        height: 1.05,
        color: Color(0xFF000000)),
    bodyText2: TextStyle(
        fontSize: 12.0,
        fontFamily: 'SFProText',
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: -0.24,
        color: Color(0xFF000000)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: const Color(0xffE06437),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: const BorderSide(width: 1, color: Color(0xffE06437))),
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'SFProText',
          fontWeight: FontWeight.w200,
          letterSpacing: -0.32,
          color: Color(0xffFFFFFF),
        ),
        visualDensity: VisualDensity.comfortable),
  ),

  pageTransitionsTheme: PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.iOS: createTransition(),
      TargetPlatform.android: createTransition(),
    },
  ),
);
