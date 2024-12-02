import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/loginPage.dart';
//import 'package:teamplayerwebapp/utils/db_manager.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loggedIn = true;

  @override
  Widget build(BuildContext context) {
    if (loggedIn)
      return homePage();
    else
      return loginPage();
  }
}

Widget homePage() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/pearl_black.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
            )),
          ],
        ),
      ),
    ),
  );
}
