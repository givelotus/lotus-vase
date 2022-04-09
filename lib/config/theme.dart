import 'package:flutter/material.dart';
import 'package:vase/config/colors.dart';

class AppTheme {
  static final lotusTheme = ThemeData(
    fontFamily: 'Brandon',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.lotusPink,
      secondary: AppColors.lotusPink,
    ),
    scaffoldBackgroundColor: AppColors.lotusPurple4,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
      button: TextStyle(
        color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    dividerColor: Colors.white,
  );

  static const double splashRadius = 24;
}
