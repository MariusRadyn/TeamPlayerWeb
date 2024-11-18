import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:flex_seed_scheme/flex_seed_scheme.dart';

const FONT_MAIN = 'SpaceMono';



// Define your seed colors.
// const Color primarySeedColor = Color(0xFF6750A4);
// const Color secondarySeedColor = Color(0xFF3871BB);
// const Color tertiarySeedColor = Color(0xFF6CA450);

//---------------------------------------------------
// Theme Light
//---------------------------------------------------
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue[900],
  textTheme: const TextTheme(
    displayLarge: TextStyle(
    fontSize: 40,
    color: Colors.white,
    ),
  ),
);

//---------------------------------------------------
// Theme Dark
//---------------------------------------------------
const COLOR_DARK_PRIMARY = Colors.deepOrange;
const COLOR_DARK_BACKGROUND = Colors.black12;
const COLOR_DARK_APPBAR = Colors.black26;
const COLOR_DARK_BUTTON = Colors.black54;

const COLOR_ORANGE = Color(0xFFF26800);
const COLOR_BLACK = Color(0xFF14140F);
const COLOR_BLACK_LIGHT = Color(0x10A3CCAB);
const COLOR_TEAL_LIGHT = Color(0xFFA3CCAB);
const COLOR_TEAL_MID = Color(0xFF34675C);
const COLOR_TEAL_DARK = Color(0xFF053D38);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: COLOR_ORANGE,
    onPrimary: Colors.blue,
    brightness: Brightness.dark,
    background: COLOR_BLACK,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: COLOR_DARK_APPBAR,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: FONT_MAIN,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontFamily: FONT_MAIN,
      fontSize: 30,
    ),
    displayMedium: TextStyle(
        fontFamily: FONT_MAIN,
        fontSize: 20
    ),
    displaySmall: TextStyle(
        fontFamily: FONT_MAIN,fontSize: 10
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey[700]
  ),
);
