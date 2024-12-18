import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Scaffold(
        body: ListView.builder(
          itemCount: lstSongsLib.length,
          itemBuilder: (context, index) {
            return MyListTile(
              text: lstSongsLib[index].songName,
              subText: lstSongsLib[index].author,
            );
          },
        ),
      ),
    );
  }
}
