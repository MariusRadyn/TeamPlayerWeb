import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';
//import 'package:teamplayerwebapp/utils/db_manager.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

enum Actions { share, delete, archive }

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final CollectionReference _songslistDB =
      FirebaseFirestore.instance.collection('SongsTable');

  void reorderItems(int oldIndex, int newIndex) {
    setState(() {
      // Fix error when moving down
      if (oldIndex < newIndex) newIndex--;

      final tile = myPlayList.removeAt(oldIndex);
      myPlayList.insert(newIndex, tile);
    });
  }

  // Database
  List<Map<String, dynamic>> _playList = [];
  bool _isLoading = true;
  void getPlayList() async {
    final data = await fireDbRead(DB_TABLE_PLAYLIST_ITEMS);
    setState(() {
      _playList = data;
      _isLoading = false;
    });
    print(_playList);
  }

  void loadDummyData() {
    LocalPlaylistLibrary data = LocalPlaylistLibrary(
      id: 0,
      description: 'My New Playlist',
      nrOfItems: 0,
      dateCreated: DateTime.now().toString(),
      dateModified: DateTime.now().toString(),
    );

    //sqlInsert(DB_TABLE_PLAYLIST_ITEMS, data);
  }

  @override
  void initState() {
    //deleteLocalDB();
    //loadDummyData();
    //getPlayList();
    super.initState();
  }

  void _onDismissed(int index, Actions action) {
    final song = myPlayList[index].songName;
    if (action == Actions.delete) {
      setState(() => {myPlayList.removeAt(index)});
    }
  }

  ListTile PlayListTile(int index) {
    return ListTile(
      key: Key('$index'),
      title: MyListTile(
        text: _playList[index]['description'],
        subText: 'Items: ' + _playList[index]['nrOfItems'],
        onDelete: () {
          setState(() {
            _playList.removeAt(index);
          });
        },
      ),
    );
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // prevent the soft keyboard from covering text fields
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(action == 'create' ? 'Create' : 'Update'),
                onPressed: () async {
                  final String? name = _nameController.text;
                  final double? price = double.tryParse(_priceController.text);
                  if (name != null && price != null) {
                    if (action == 'create') {
                      // Persist a new product to Firestore
                      await _songslistDB.add({"name": name, "price": price});
                    }

                    if (action == 'update') {
                      // Update the product
                      await _songslistDB.doc(documentSnapshot!.id).update({
                        "name": name,
                        "price": price,
                      });
                    }

                    // Clear the text fields
                    _nameController.text = '';
                    _priceController.text = '';

                    // Hide the bottom sheet
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _songslistDB.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have successfully deleted a product')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kindacode.com')),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _songslistDB.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _createOrUpdate(documentSnapshot),
                          ),
                          // This icon button is used to delete a single product
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteProduct(documentSnapshot.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
