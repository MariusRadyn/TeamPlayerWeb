import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';
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

      // FutureBuilder<List<Reference>>(
      //   future: fireStoreGetFilesList('user1'),
      //   builder: (context, AsyncSnapshot<List<Reference>> snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Firebase Error');
      //     } else if (snapshot.connectionState == ConnectionState.done) {
      //       List<Reference> ref = snapshot.data!;
      //       return buildItems(ref);
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
    );
  }
}

Widget buildItems(datalist) => ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: datalist.length,
      itemBuilder: (BuildContext context, int index) {
        final Reference dta = datalist[index];
        return MyListTile(
          text: dta.name,
          //subText: datalist[index]['Genre'],
          onDelete: () {},
        );
      },
    );
