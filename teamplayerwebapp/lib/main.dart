import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamplayerwebapp/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teamplayerwebapp/library_page.dart';
import 'package:teamplayerwebapp/playlist_page.dart';
import 'package:teamplayerwebapp/theme/theme_manager.dart';

//ThemeManager _themeManager = ThemeManager();

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAnySvXbn8R1pYZ3m1Z-mGMQ6fCD5nu16o",
        authDomain: "teamplayerwebapp.firebaseapp.com",
        projectId: "teamplayerwebapp",
        storageBucket: "teamplayerwebapp.firebasestorage.app",
        messagingSenderId: "34204010890",
        appId: "1:34204010890:web:11130a6c0b51b30896a073",
        measurementId: "G-G218EXR3V8",
      ),
    );
    runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
  } catch (e) {
    print("Error: $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List _pages = [
    {"page": const HomePage(), "title": Text("Home")},
    {"page": const PlaylistPage(), "title": Text("Playlist")},
    {"page": const LibraryPage(), "title": Text("Library")},
    {"page": const PlaylistPage(), "title": Text("Settings")},
  ];

  List lstSongs = [];
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: Scaffold(
        body: _pages[_currentIndex]["page"],
        appBar: AppBar(title: _pages[_currentIndex]["title"]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Setlist'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
