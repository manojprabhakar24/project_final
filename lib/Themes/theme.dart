import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.brown,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey[900],
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.red,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}


class AppFonts {
  static TextStyle getHeadingStyle() {
    return GoogleFonts.openSans(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getSubHeadingStyle() {
    return GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getDescriptionStyle() {
    return GoogleFonts.poppins(
      fontWeight: FontWeight.bold, color: Colors.white,
    );
  }

  static TextStyle getTotalPriceStyle() {
    return GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }
}
