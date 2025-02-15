import 'package:hexacom_user/utill/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF0c7372),
  secondaryHeaderColor: const Color(0xFF0c7372),
  brightness: Brightness.dark,
  cardColor: const Color(0xFF29292D),
  hintColor: const Color(0xFFE7F6F8),
  focusColor: const Color(0xFFC3CAD9),
  shadowColor: Colors.black.withOpacity(0.4),
  popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF0c7372),
    onPrimary: const Color(0xFF0c7372),
    secondary: const Color(0xFFffffff),
    onSecondary: const Color(0xFFffffff),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white10,
    onSurface: Colors.white70,
    shadow: Colors.black.withOpacity(0.4),
  ),
);
