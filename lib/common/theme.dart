import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khatadiary/common/style.dart';

lightTheme(context) {
  return ThemeData(
    scaffoldBackgroundColor: white1,
    primaryColor: blueC,
    canvasColor: blueC,
    shadowColor: darkC,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: blueC),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: darkC)
        .copyWith(
          bodyLarge: const TextStyle(
            color: darkC,
          ),
          bodyMedium: const TextStyle(
            color: darkC,
          ),
        ),
  );
}
