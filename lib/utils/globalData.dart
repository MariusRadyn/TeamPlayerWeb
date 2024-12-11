//import '../theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';

bool synchBusy = false;
late BitMonitor bitMonitorSychBusy;

// UserData
final String fireUserName = 'user1';
final String fireUserRecyclebin = '${fireUserName}_recycle/';

// Song Font Sizes
const String songWordsFont = 'SpaceMono';
const Color songWordsColor = Colors.white;
const double songNameFontSize = 16;
const double songAuthorFontSize = 14;
const double songWordFontSize = 12;
const double songPartFontSize = 14;
const songWordsStyle = TextStyle(
  fontFamily: 'SpaceMono',
  fontSize: 12,
  color: Colors.white,
);

const String songChordsFont = 'SpaceMono';
const double songChordsFontSize = 12;
const Color songChordsColor = Colors.red;
const songChordsStyle = TextStyle(
  fontFamily: 'SpaceMono',
  fontSize: 12,
  color: Colors.red,
);

const songTitleStyle = TextStyle(
  fontFamily: 'SpaceMono',
  fontSize: 16,
  color: Colors.blue,
);

const songAuthorStyle = TextStyle(
  fontFamily: 'SpaceMono',
  fontSize: 12,
  color: Colors.grey,
);

// Widget Font Sizes
const double normalTextFontSize = 12;
const double headerTextFontSize = 14;

// Theme data
const String USER_NAME = 'username';
const String DARK_THEME = 'darktheme';
const String NR_OF_COLUMNS = 'nrofcolumns';
const String DB_LOCAL = 'LocalDB.db';
const String DB_TABLE_SONGS_LIB = 'SongsTable';
const String DB_TABLE_PLAYLIST_LIB = 'PlaylistsTable';
const String DB_TABLE_PLAYLIST_ITEMS = 'PlaylistItemsTable';

AppSettings appSettings = AppSettings();
//ThemeManager themeManager = ThemeManager();

List<PlayListData> myPlayList = <PlayListData>[];
List<LocalSongsLibrary> mySongsLibrary = <LocalSongsLibrary>[];

UserData userData = UserData();
List<SongData> lstSongsLib = [];
bool isSyncing = true;

// App Settings
class AppSettings {
  String userName;
  bool themeDark;
  bool showComments;
  bool showDefine;
  bool showTabs;
  int nrOfColumns;

  AppSettings({
    this.userName = "",
    this.themeDark = true,
    this.nrOfColumns = 3,
    this.showComments = false,
    this.showDefine = false,
    this.showTabs = false,
  });
}

class PlayListData {
  final String songName;
  final String writer;

  PlayListData({required this.songName, required this.writer});
}

// Database Schemas
class LocalSongsLibrary {
  final int id;
  final String songName;
  final String author;
  final String genre;
  final String dateCreated;
  final String dateModified;
  final String dateLastViewed;
  final int isActive;

  const LocalSongsLibrary({
    required this.id,
    required this.songName,
    required this.author,
    required this.genre,
    this.dateModified = '',
    this.dateCreated = "",
    this.dateLastViewed = "",
    this.isActive = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'songName': songName,
      'author': author,
      'genre': genre,
      'dateModified': dateModified,
      'dateCreated': dateCreated,
      'dateLastViewed': dateLastViewed,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return 'DB_Local{'
        'id: $id, '
        'songName: $songName, '
        'author: $author, '
        'dateModified : $dateModified, '
        'dateCreated : $dateCreated, '
        'dateLastViewed : $dateLastViewed, '
        'isActive : $isActive}';
  }
}

class LocalPlaylistLibrary {
  final int id;
  final String description;
  final String dateCreated;
  final String dateModified;
  final int nrOfItems;

  const LocalPlaylistLibrary({
    required this.id,
    required this.description,
    required this.dateCreated,
    this.dateModified = '',
    this.nrOfItems = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
    };
  }

  @override
  String toString() {
    return 'DB_Local{'
        'id: $id, '
        'description: $description, '
        'dateCreated: $dateCreated, '
        'dateModified: $dateModified';
  }
}

class LocalPlaylistItems {
  final int id;
  final String songName;
  final String author;
  final String genre;

  const LocalPlaylistItems({
    required this.id,
    required this.songName,
    required this.author,
    required this.genre,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'songName': songName, 'author': author, 'genre': genre};
  }

  @override
  String toString() {
    return 'DB_Local{'
        'id: $id, '
        'songName: $songName, '
        'author: $author, ';
  }
}

class UserData {
  String userName = "";
  String surname = "";
  String userID = "";
}

class SongData {
  String songName = "";
  String author = "";
  String? stars = "";
  String? dateAdded = "";
  String? datePlayed = "";
  String? dateModified = "";
  String? genre = "";
  String? tempo = "";
  String? filename = "";

  SongData({
    required this.songName,
    required this.author,
    this.dateAdded,
    this.dateModified,
    this.datePlayed,
    this.genre,
    this.stars,
    this.tempo,
    this.filename,
  });
}
