import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF00aaff);
const kSuccessColor = Colors.green;
const kWarningColor = Colors.orange;

const List<Color> kAvatarColors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.amber,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.lime,
  Colors.lightBlue,
];

final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    surface: const Color(0xFFf8f9fa),
    primary: primaryColor,
    error: Colors.redAccent
  ),
  scaffoldBackgroundColor: const Color(0xFFf8f9fa),
  textTheme: GoogleFonts.interTextTheme(),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.white,
    elevation: 8,
    shadowColor: Colors.black.withOpacity(0.5),
  ),
  primaryColor: primaryColor
);

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    surface: const Color(0xFF121212),
    primary: primaryColor,
    error: Colors.redAccent
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  textTheme: GoogleFonts.interTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFF2c2c2c)),
    ),
    color: const Color(0xFF1e1e1e),
    elevation: 8,
    shadowColor: Colors.black.withOpacity(0.5),
  ),
  
);
