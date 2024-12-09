import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/homePage.dart';
import 'package:teamplayerwebapp/theme/theme_constants.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  FirbaseAuthService _auth = FirbaseAuthService();

  TextEditingController _userController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _pw2Controller = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _pw2Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Email Address
              textInputWidget(
                controller: _emailController,
                hintText: "Enter Email Address",
              ),

              SizedBox(height: 20),

              // Password
              textInputWidget(
                controller: _pwController,
                hintText: "Password",
                isPasswordField: true,
              ),

              SizedBox(height: 20),

              // Confirm Password
              textInputWidget(
                controller: _pw2Controller,
                hintText: "Confirm Password",
                isPasswordField: true,
              ),

              SizedBox(height: 20),

              // Signup Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 80, right: 80, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: COLOR_ORANGE,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (_pwController.text != _pw2Controller.text) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyDialogWidget(
                                          header: "Password Error",
                                          message:
                                              'Passwords do not match\rPlease re-enter your password',
                                          but1Text: "OK",
                                          but2Text: "Cancel",
                                          onPressedBut1:
                                              Navigator.of(context).pop,
                                          onPressedBut2:
                                              Navigator.of(context).pop,
                                        )));
                              } else {
                                signUp();
                              }
                            },
                          ),
                        ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    String username = _userController.text;
    String email = _emailController.text;
    String password = _pwController.text;

    User? user = await _auth.fireAuthCreateUser(email, password);

    if (user != null) {
      print('User created successfully');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } else {
      print('Error creating user');
    }
  }
}
