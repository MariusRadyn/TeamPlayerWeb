import 'package:flutter/material.dart';
import 'package:teamplayerwebapp/theme/theme_constants.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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

              // Confirm Password
              textInputWidget(
                hintText: "Confirm Password",
                isPasswordField: true,
              ),
              SizedBox(height: 20),

              // Signup Button
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
                        'Sign Up',
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
