//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:teamplayerwebapp/SyncDialog.dart';
import 'package:teamplayerwebapp/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teamplayerwebapp/libraryPage.dart';
import 'package:teamplayerwebapp/playlistPage.dart';
import 'package:teamplayerwebapp/theme/theme_manager.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';
import 'firebase_options.dart';

//ThemeManager _themeManager = ThemeManager();

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
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
  int _currentIndex = 0;
  SyncLib _syncLib = SyncLib();

  final List _pages = [
    {"page": const HomePage(), "title": Text("")},
    {"page": const PlaylistPage(), "title": Text("Playlist")},
    {"page": const LibraryPage(), "title": Text("Library")},
    {"page": const PlaylistPage(), "title": Text("Settings")},
  ];

  @override
  void initState() {
    userData.userName = "Marius";
    userData.surname = "Radyn";
    userData.userID = "user1";
    synchBusy = true;

    super.initState();

    _syncLib.onListUpdate = (_songDta) {
      if (mounted) {
        setState(() {
          lstSongsLib = _songDta;
        });
      }
    };

    _syncLib.onSyncDone = (_syncDone) {
      if (mounted) {
        setState(() {
          synchBusy = !_syncDone;
        });
      }
    };

    _syncLib.Sync();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      //fireDbWrite(
      //  'SongsTable',
      //  'user1',
      //  SongData(songName: 'new song1', author: 'unknown1', genre: 'pop1'),
      //);

      //Sync(context);
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //     opaque: false,
      //     pageBuilder: (context, _, __) => SynchDialog(),
      //   ),
      // );
      return;
    }

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
        appBar: AppBar(
          title: _pages[_currentIndex]["title"],
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  ),
                )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home $_currentIndex',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Setlist'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync'),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Page")),
      body: Center(child: Text("Welcome to the Second Page")),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
