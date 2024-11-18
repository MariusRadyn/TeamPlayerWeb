import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';
import 'package:teamplayerwebapp/utils/global_data.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List lstSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DB_ReadFirestore("SongsTable"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Firebase Error');
          } else if (snapshot.connectionState == ConnectionState.done) {
            lstSongs = snapshot.data as List;
            return buildItems(lstSongs);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Widget buildItems(datalist) => ListView.separated(
  separatorBuilder: (BuildContext context, int index) => const Divider(),
  itemCount: datalist.length,
  itemBuilder: (BuildContext context, int index) {
    return MyListTile(
      text: datalist[index]['SongName'],
      subText: datalist[index]['Genre'],
      onDelete: () {},
    );
  },
);
