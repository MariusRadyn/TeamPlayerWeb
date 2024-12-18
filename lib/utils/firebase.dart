import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';

FirebaseStorage fireStorageInstance = FirebaseStorage.instance;
List<Reference> fireAllSongsRef = [];

// ----------------------------------------------------------------------------
// Firebase Storage
// ----------------------------------------------------------------------------

Future<void> fireStoreUploadImage(String inputSource) async {
  final picker = ImagePicker();
  XFile? pickedImage;
  try {
    pickedImage = await picker.pickImage(
      source:
          inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1920,
    );

    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage.path);

    // Points to the root reference
    final storageRef = FirebaseStorage.instance.ref();
    var spaceRef = storageRef.child("user1/recycle/" + fileName);
    await spaceRef.putFile(
      imageFile,
      SettableMetadata(
        customMetadata: {
          'uploaded_by': 'A bad guy',
          'description': 'Some description...',
        },
      ),
    );
  } catch (err) {
    print(err);
  }
}

Future<void> fireStoreUploadFile(String filename) async {
  //Future<String> url = "" as Future<String>;
  try {
    //Create a reference to the location you want to upload to in firebase
    Reference reference = fireStorageInstance.ref().child(fireUserRecyclebin);

    //Upload the file to firebase
    UploadTask uploadTask = reference.putFile(File(filename));

    // Waits till the file is uploaded then stores the download url
    uploadTask.whenComplete(() {
      Future<String> url = reference.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
  } catch (err) {
    print(err);
  }
}

Future<List<Map<String, dynamic>>> fireStoreLoadFiles() async {
  List<Map<String, dynamic>> files = [];

  final ListResult result = await fireStorageInstance.ref().list();
  final List<Reference> allFiles = result.items;

  await Future.forEach<Reference>(allFiles, (file) async {
    final String fileUrl = await file.getDownloadURL();
    final FullMetadata fileMeta = await file.getMetadata();
    files.add({
      "url": fileUrl,
      "path": file.fullPath,
      "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
      "description":
          fileMeta.customMetadata?['description'] ?? 'No description',
    });
  });

  return files;
}

Future<List<Reference>> fireStoreGetFilesList(String path) async {
  try {
    final storageRef = fireStorageInstance.ref().child(path);
    final listResult = await storageRef.listAll();
    fireAllSongsRef.clear();

    for (var item in listResult.items) {
      fireAllSongsRef.add(item);
    }

    return fireAllSongsRef;
  } catch (e) {
    print("fireStoreGetFilesList Error: $e");
    return [];
  }
}

Future<String> fireStoreReadFile(int index) async {
  final _storageRef = fireStorageInstance.ref().child(
        fireAllSongsRef[index].fullPath,
      );
  Uint8List? downloadedData = await _storageRef.getData();
  String text = utf8.decode(downloadedData as List<int>);
  return text;
}

Future<void> fireStoreWriteFile(String text, int index) async {
  final _storageRef = fireStorageInstance.ref().child(
        fireAllSongsRef[index].fullPath,
      );
  _storageRef.putString(
    text,
    metadata: SettableMetadata(contentLanguage: 'en'),
  );
}

Future<List<Reference>> fireStoreGetDirectoryList(String path) async {
  final storageRef = fireStorageInstance.ref().child(path);
  final listResult = await storageRef.listAll();
  List<Reference> dir = [];

  for (var prefix in listResult.prefixes) dir.add(prefix);
  return dir;
}

Future<void> fireStoreDeleteFile(String ref) async {
  await fireStorageInstance.ref(ref).delete();
}

Future<String> fireStoreUploadProfilePic(String userId, File imageFile) async {
  Reference storageRef =
      FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');

  UploadTask uploadTask = storageRef.putFile(imageFile);
  TaskSnapshot snapshot = await uploadTask;

  // Get download URL
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

// ----------------------------------------------------------------------------
// Firestore Database
// ----------------------------------------------------------------------------
Future fireDbRead(String table) async {
  List Songs = [];

  final CollectionReference fRef = FirebaseFirestore.instance.collection(table);

  try {
    //var v = await fRef.doc("user1").get();

    await fRef.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        Songs.add(result.data());
      }
    });

    return Songs;
  } catch (e) {
    print("Firebase DB Error: $e");
    return null;
  }
}

Future<void> fireDbWriteSongData(
    String collection, String table, SongData song) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection(collection).doc(table).set({
      'songName': song.songName,
      'author': song.author,
      'genre': song.genre,
    });

    print('Data added successfully!');
  } catch (e) {
    print('Error adding data: $e');
  }
}

Future<void> fireDbWriteUserData(
    User user, String fullName, String profilePicUrl) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fullName': fullName,
      'email': user.email,
      'profilePicUrl': profilePicUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('Data added successfully!');
  } catch (e) {
    print('Error adding data: $e');
  }
}

// ----------------------------------------------------------------------------
// Firestore Authentication
// ----------------------------------------------------------------------------
class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> fireAuthCreateUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (e) {
      print("Firebase Auth Error: $e");
      return null;
    }
  }

  Future<User?> fireAuthSignIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          //- **invalid-email**:
          ///  - Thrown if the email address is not valid.
          /// - **user-disabled**:
          ///  - Thrown if the user corresponding to the given email has been disabled.
          /// - **user-not-found**:
          ///  - Thrown if there is no user corresponding to the given email.
          /// - **wrong-password**:
          ///  - Thrown if the password is invalid for the given email, or the account
          ///    corresponding to the email does not have a password set.
          /// - **too-many-requests**:
          ///  - Thrown if the user sent too many requests at the same time, for security
          ///     the api will not allow too many attemps at the same time, user will have
          ///     to wait for some time
          /// - **user-token-expired**:
          ///  - Thrown if the user is no longer authenticated since his refresh token
          ///    has been expired
          /// - **network-request-failed**:
          ///  - Thrown if there was a network request error, for example the user don't
          ///    don't have internet connection
          /// - **INVALID_LOGIN_CREDENTIALS** or **invalid-credential**:
          ///  - Thrown if the password is invalid for the given email, or the account
          ///    corresponding to the email does not have a password set.
          ///    depending on if you are using firebase emulator or not the code is
          ///    different
          /// - **operation-not-allowed**:
          ///  - Thrown if email/password accounts are not enabled. Enable
          ///    email/password accounts in the Firebase Console, under the Auth tab.
          ///
          case 'invalid-email':
          case 'wrong-password':
          case 'invalid-credential':
            userData.errorMsg = "Invalid email or password.";
            break;

          default:
            userData.errorMsg = e.code;
        }
      }

      print("Firebase Auth Error: $e");
      return null;
    }
  }

  Future<void> fireAuthSignOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Firebase Auth Error: $e");
    }
  }

  Future<void> fireAuthResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Firebase Auth Error: $e");
    }
  }
}
