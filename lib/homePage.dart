import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/loginPage.dart';
import 'package:teamplayerwebapp/theme/theme_constants.dart';
//import 'package:teamplayerwebapp/utils/db_manager.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loggedIn = true;
  //BitMonitor bitMonitorSychBusy = BitMonitor(onBitChanged: _onBitChanged);

  @override
  void initState() {
    super.initState();

    //Show SnackBar after the first frame is built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (synchBusy) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Synching...')),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Synching Done')),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pearl_black.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Builder(
        builder: (context) => Center(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ValueListenableBuilder<bool>(
                    valueListenable: syncBusy,
                    builder: (context, value, child) {
                      return Text('SynchBusy: ${value}');
                    },
                  ),
                  //Login Profile
                  Stack(
                    children: [
                      // Backdrop
                      Container(
                        alignment: Alignment.topCenter,
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.3,
                                0.9,
                              ],
                              colors: [
                                Colors.teal,
                                Colors.black26,
                              ]),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                      ),
                      // White Container
                      Container(
                        margin:
                            const EdgeInsets.only(top: 60, left: 10, right: 10),
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      // Avatar
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/profile.png"),
                                radius: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Welcome Message
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 130),
                            child: Text(
                              'Please login to continue',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      // Login Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 160),
                            width: 120,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: COLOR_ORANGE,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: TextButton(
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                //GlobalSnackBar.show('Hello from home page');

                                // final snack =
                                //     SnackBar(content: Text("Snackbar"));
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(snack);

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => loginPage(),
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
