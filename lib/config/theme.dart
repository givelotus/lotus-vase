import 'package:flutter/material.dart';
import 'package:vase/config/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.lotusPink,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: AppColors.lotusPink,
    ),
  );

  static final double splashRadius = 20;
}
