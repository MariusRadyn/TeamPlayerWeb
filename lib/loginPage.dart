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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 200),
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
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: COLOR_ORANGE,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
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
