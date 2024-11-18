import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const COLOR_DARK_PRIMARY = Colors.grey;
const COLOR_DARK_ONPRIMARY = Colors.lightBlueAccent;
const COLOR_DARK_ONSECONDARY = Colors.deepOrange;
const COLOR_DARK_BACKGROUND = Colors.black12;
const COLOR_DARK_APPBAR = Colors.black12;
const COLOR_DARK_BUTTON = Colors.black54;
const COLOR_DARK_HEDDING = Colors.blue;

//---------------------------------------------------
// Theme Light
//---------------------------------------------------
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.green,
  //useMaterial3: false,
  //brightness: Brightness.light,
  // primaryColor: Colors.blue[900],
  // textTheme: const TextTheme(
  //   displayLarge: TextStyle(
  //     fontSize: 40,
  //     color: Colors.white,
  //   ),
  //),
);

//---------------------------------------------------
// Theme Dark
//---------------------------------------------------
@override
ThemeData darkTheme = ThemeData(
  primaryColor: COLOR_DARK_PRIMARY,
  cardColor: COLOR_DARK_BACKGROUND,
  disabledColor: COLOR_DARK_PRIMARY.withOpacity(.48),
  highlightColor: COLOR_DARK_ONPRIMARY,

  useMaterial3: false,
  colorScheme: const ColorScheme.dark(
    primary: COLOR_DARK_PRIMARY,
    onPrimary: COLOR_DARK_ONPRIMARY,
    brightness: Brightness.dark,
    onSecondary: COLOR_DARK_ONSECONDARY,
  ),
  scaffoldBackgroundColor: Colors.black,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: COLOR_DARK_PRIMARY,
    showUnselectedLabels: true,
    selectedItemColor: COLOR_DARK_ONPRIMARY,
    unselectedItemColor: COLOR_DARK_ONPRIMARY,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: COLOR_DARK_APPBAR,
    iconTheme: IconThemeData(color: COLOR_DARK_HEDDING),
    titleTextStyle: TextStyle(color: COLOR_DARK_ONPRIMARY, fontSize: 20),
  ),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(fontSize: 20, color: COLOR_DARK_ONPRIMARY),
    subtitleTextStyle: TextStyle(fontSize: 12, color: Colors.white),
    tileColor: Colors.black54,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'aBeeZee',
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(fontFamily: 'aBeeZee', fontSize: 30),
    displayMedium: TextStyle(fontFamily: 'aBeeZee', fontSize: 20),
    displaySmall: TextStyle(fontFamily: 'aBeeZee', fontSize: 10),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((Set states) {
      if (states.contains(MaterialState.disabled)) {
        return COLOR_DARK_ONPRIMARY.withOpacity(.48);
      }
      return COLOR_DARK_ONPRIMARY;
    }),
    overlayColor: MaterialStateProperty.resolveWith((Set states) {
      return COLOR_DARK_PRIMARY;
    }),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey[700],
  ),
);

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  get themeMode => _themeMode;

  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
