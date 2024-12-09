import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/signupPage.dart';
import 'package:teamplayerwebapp/theme/theme_constants.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Email Address
              textInputWidget(
                hintText: "Enter Email Address",
              ),
              SizedBox(height: 20),
              // Password
              textInputWidget(
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(height: 20),

              // Login Button
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
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ]),
                  )
                ],
              ),

              SizedBox(height: 20),

              // Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have an account?"),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signupPage()),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: COLOR_ORANGE),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
