import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const COLOR_BLUE = Colors.lightBlueAccent;
const COLOR_ORANGE = Color.fromARGB(255, 255, 60, 1);
const COLOR_GREY = Color.fromARGB(139, 119, 119, 119);

const COLOR_DARK_HEADER = Colors.white;
const COLOR_DARK_TEXT = Colors.white;
const COLOR_DARK_SUBTEXT = COLOR_GREY;
const COLOR_BACKGROUND = Color.fromARGB(255, 32, 48, 48);
const COLOR_APPBAR = Color.fromARGB(90, 30, 104, 104);

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
  primaryColor: const Color.fromARGB(255, 64, 233, 255),
  disabledColor: COLOR_GREY,
  useMaterial3: true,
  scaffoldBackgroundColor: COLOR_BACKGROUND,
  colorScheme: ColorScheme.dark(
    primary: COLOR_BLUE,
    brightness: Brightness.dark,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: COLOR_APPBAR,
    showUnselectedLabels: true,
    selectedItemColor: COLOR_BLUE,
    unselectedItemColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: COLOR_APPBAR,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: COLOR_DARK_TEXT, fontSize: 20),
  ),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(fontSize: 20, color: COLOR_DARK_TEXT),
    subtitleTextStyle: TextStyle(fontSize: 12, color: COLOR_ORANGE),
    tileColor: Color.fromARGB(22, 30, 104, 104),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'aBeeZee',
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontFamily: 'aBeeZee',
      fontSize: 30,
      color: COLOR_DARK_TEXT,
    ),
    displayMedium: TextStyle(
      fontFamily: 'aBeeZee',
      fontSize: 20,
      color: COLOR_DARK_TEXT,
    ),
    displaySmall: TextStyle(
      fontFamily: 'aBeeZee',
      fontSize: 10,
      color: COLOR_DARK_TEXT,
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((Set states) {
      if (states.contains(WidgetState.disabled)) {
        return COLOR_GREY;
      }
      return COLOR_BLUE;
    }),
    overlayColor: WidgetStateProperty.resolveWith((Set states) {
      return COLOR_BLUE;
    }),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: COLOR_ORANGE,
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
