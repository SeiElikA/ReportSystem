import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:report_app/utils/utils.dart';

import 'colorExt.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: createMaterialColor(colorExt.mainColor),
      primaryColor: createMaterialColor(colorExt.mainColor),
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      hoverColor: isDarkTheme ? Colors.grey : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ), textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.grey.withOpacity(0.3)),
      fontFamily: "SF Compact Rounded",
      textTheme: TextTheme(
          titleMedium: TextStyle(color: isDarkTheme ? colorExt.titleColorDark : colorExt.titleColorLight),
          headlineMedium: TextStyle(color: isDarkTheme ? colorExt.subTitleColorDark : colorExt.subTitleColorLight),
          bodyMedium: TextStyle(color: isDarkTheme ? colorExt.bodyColorDark : colorExt.bodyColorLight),
          bodySmall: TextStyle(color: isDarkTheme? colorExt.bodySmallColorDark : colorExt.bodySmallColorLight)
      )
    );
  }
}