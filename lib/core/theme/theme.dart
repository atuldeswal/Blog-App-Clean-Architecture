import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPalette.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    chipTheme: ChipThemeData(
      color: WidgetStatePropertyAll(AppPalette.backgroundColor),
      side: BorderSide.none,
    ),
    appBarTheme: AppBarTheme(backgroundColor: AppPalette.backgroundColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPalette.gradient2),
      errorBorder: _border(AppPalette.errorColor),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppPalette.gradient2, width: 1.5),
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
      actionTextColor: AppPalette.gradient1,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      shadowColor: Colors.black54
    ),
  );
}
