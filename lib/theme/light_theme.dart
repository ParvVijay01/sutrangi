import 'package:hexacom_user/utill/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
<<<<<<< HEAD
  primaryColor: const Color(0xFF0c7372),
  secondaryHeaderColor: const Color(0xFF0c7372),
=======
  primaryColor: const Color(0xFF562E9C),
  secondaryHeaderColor: const Color(0xFFEFE6FE),
>>>>>>> f6ba2fcd8c522daa8299b79f7fa3c59ce7266449
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: const Color(0xFFC3CAD9),
  hintColor: const Color(0xFF52575C),
  canvasColor: const Color(0xFFFCFCFC),
  shadowColor: Colors.grey[300],
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF002349))),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
<<<<<<< HEAD
    primary: const Color(0xFF0c7372),
    onPrimary: const Color(0xFF0c7372),
=======
    primary: const Color(0xFF562E9C),
    onPrimary: const Color(0xFF562E9C),
>>>>>>> f6ba2fcd8c522daa8299b79f7fa3c59ce7266449
    secondary: const Color(0xFFEFE6FE),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),
);