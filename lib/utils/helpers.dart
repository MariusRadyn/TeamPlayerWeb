import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamplayerwebapp/theme/theme_manager.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';

enum SlideActions { Share, Delete, Sync }

//------------------------------------------------------------------------------
// Functions
//------------------------------------------------------------------------------
saveAppSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(USER_NAME, appSettings.userName);
  prefs.setBool(DARK_THEME, appSettings.themeDark);
  prefs.setInt(NR_OF_COLUMNS, appSettings.nrOfColumns);
}

getAppSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  appSettings.userName = prefs.getString(USER_NAME) ?? '';
  appSettings.themeDark = prefs.getBool(DARK_THEME) ?? false;
  appSettings.nrOfColumns = prefs.getInt(NR_OF_COLUMNS) ?? 1;
}

removeSharedPreference(String propertyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(propertyName);
}

TextStyle songWordsTextStyle() {
  return const TextStyle(
    fontFamily: songWordsFont,
    fontSize: songWordFontSize,
    color: songWordsColor,
  );
}

Text WriteSongLine(String text, double fontsize, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: songWordsFont,
      fontSize: fontsize,
      color: color,
    ),
  );
}

String getToken(String token, String text) {
  int posEnd = 0;
  int posStart = text.indexOf(token);
  if (posStart == -1) return "";

  posEnd = text.indexOf("}", posStart + token.length);
  if (posEnd == -1) posEnd = text.indexOf("\n", posStart + token.length);
  if (posEnd == -1) posEnd = text.indexOf("\r", posStart + token.length);

  if (posEnd == -1) {
    return text.substring(posStart + token.length).trim();
  } else {
    return text.substring(posStart + token.length, posEnd).trim();
  }
}

List<String> getLinesFromTxtFile(String text) {
  List<String> lines = [];
  int startPos = 0;
  int endPos = 0;
  String line;

  while (endPos < text.length) {
    endPos = text.indexOf("\n", startPos + 1);
    if (endPos == -1) break;

    line = text.substring(startPos, endPos).trim();
    startPos = endPos;
    lines.add(line);
  }
  return lines;
}

Future<void> MySimpleDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text("Title"),
        children: <Widget>[
          SimpleDialogOption(child: Text("Option1"), onPressed: () {}),
          SimpleDialogOption(child: Text("Option2"), onPressed: () {}),
          SimpleDialogOption(child: Text("Option3"), onPressed: () {}),
        ],
      );
    },
  );
}

ButtonStyle MyButtonStyle(Color backgroundColor) {
  return TextButton.styleFrom(
    minimumSize: Size(100, 50),
    backgroundColor: backgroundColor,
    shadowColor: Colors.white,
  );
}

//------------------------------------------------------------------------------
// Widgets
//------------------------------------------------------------------------------
MaterialButton myButton(String text, Function()? onPressed) {
  return MaterialButton(
    onPressed: onPressed,
    color: Colors.blue,
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
}

class MyTextFieldWithIcon extends StatelessWidget {
  final String text;
  final String? hint;
  final TextEditingController? textController;
  final Function()? onPressed;
  final IconData icon;
  final Color? iconColor;

  const MyTextFieldWithIcon({
    super.key,
    required this.textController,
    required this.text,
    this.onPressed,
    required this.icon,
    this.hint,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: hint,
          labelText: text,
          border: UnderlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String text;
  final String? hint;
  final TextEditingController? textController;

  const MyTextField({
    super.key,
    required this.textController,
    required this.text,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: hint,
          labelText: text,
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }
}

class MyDropdownButton extends StatelessWidget {
  List<String> lstValues;
  String dropdownValue;
  String label;
  IconData icon;
  String text;
  Function(String?)? onChange;

  MyDropdownButton({
    super.key,
    required this.lstValues,
    this.label = "",
    this.dropdownValue = "",
    this.icon = Icons.arrow_drop_down_sharp,
    this.onChange,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: const TextStyle(fontSize: normalTextFontSize),
            ),
          ),
          SizedBox(
            height: 30,
            width: 100,
            child: DropdownMenu<String>(
              label: Text(label),
              menuStyle: const MenuStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.blueGrey),
              ),
              expandedInsets: EdgeInsets.fromLTRB(10, 0, 10, 0),
              initialSelection: dropdownValue,
              onSelected: onChange,
              dropdownMenuEntries:
                  lstValues.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextTile extends StatelessWidget {
  final Color? color;
  final String text;

  const MyTextTile({super.key, this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        width: 400,
        height: 50,
        color: color,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String text;
  final String subText;
  Function()? onDelete;
  Function()? onTap;

  MyListTile({
    super.key,
    required this.text,
    this.subText = '',
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        dense: true,

        //Delete Icon
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
        ),
        title: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subText, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
      SizedBox(height: 3),
    ]);
  }
}

class MySwitchWithLabel extends StatelessWidget {
  const MySwitchWithLabel({
    super.key,
    this.onChanged,
    required this.switchState,
    required this.label,
  });

  final String label;
  final Function(bool)? onChanged;
  final bool switchState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: normalTextFontSize)),
          Switch(value: switchState, onChanged: onChanged),
        ],
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const MyTextButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Text(text, style: const TextStyle(fontSize: normalTextFontSize)),
      ),
    );
  }
}

class MyAlertDialogBox extends StatelessWidget {
  final String heading;
  final String msg;
  final String but1Text;
  final String but2Text;
  final Function()? onPressedBut1;
  final Function()? onPressedBut2;
  final BuildContext context;

  const MyAlertDialogBox({
    super.key,
    required this.heading,
    required this.msg,
    this.onPressedBut1,
    this.onPressedBut2,
    this.but1Text = "",
    this.but2Text = "",
    required this.context,
  });

  _alert() {
    var v = AlertDialog(
      title: Text(heading),
      content: Text(msg),
      actions: <Widget>[
        TextButton(onPressed: onPressedBut1, child: Text(but1Text)),
        TextButton(onPressed: onPressedBut2, child: Text(but2Text)),
      ],
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return v;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _alert();
  }
}

class EmptyWdget extends StatelessWidget {
  const EmptyWdget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyDialogWidget extends StatelessWidget {
  final String message;
  final String header;
  final String but1Text;
  final String but2Text;
  final VoidCallback? onPressedBut1;
  final VoidCallback? onPressedBut2;
  String image;

  MyDialogWidget({
    super.key,
    required this.message,
    required this.header,
    required this.but1Text,
    required this.but2Text,
    this.onPressedBut1,
    this.onPressedBut2,
    this.image = "assets/images/warning.png",
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        children: [
          Expanded(flex: 1, child: Image.asset(image, height: 30, width: 30)),
          SizedBox(width: 20),
          Expanded(flex: 4, child: Text(header, textAlign: TextAlign.start)),
        ],
      ),
      content: Text(message, textAlign: TextAlign.center),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: onPressedBut1,
          child: Text(but1Text),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: onPressedBut2,
          child: Text(but2Text),
        ),
      ],
    );
  }
}

class MyDialogBox {
  final String message;
  final String header;
  final String but1Text;
  final String but2Text;
  final VoidCallback? onPressedBut1;
  final VoidCallback? onPressedBut2;
  String image;

  MyDialogBox({
    required this.message,
    required this.header,
    required this.but1Text,
    required this.but2Text,
    this.onPressedBut1,
    this.onPressedBut2,
    this.image = "images/warning.png",
  });

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(image, height: 30, width: 30),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: Text(header, textAlign: TextAlign.start),
              ),
            ],
          ),
          content: Text(message, textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: onPressedBut1,
              child: Text(but1Text),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: onPressedBut2,
              child: Text(but2Text),
            ),
          ],
        );
      },
    );
  }
}

class MyMessageBox {
  final String message;
  final String header;
  String image;

  MyMessageBox({required this.message, required this.header, this.image = ""});

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            width: 250, // Custom width
            height: 200, // Custom height

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heading
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image
                        Image.asset(image, height: 30, width: 30),
                        SizedBox(width: 8),
                        // Heading
                        Text(
                          header,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                  SizedBox(height: 10),
                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: MyButtonStyle(COLOR_ORANGE), // Button color
                    child: const Text(
                      "OK",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }
}

class MyLoginBox {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void Dispose() {
    _pwController.dispose();
    _emailController.dispose();
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Custom width
            height: MediaQuery.of(context).size.height * 0.4, // Custom height

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heading
                  Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),
                  // Email
                  textInputWidget(
                    controller: _emailController,
                    hintText: "Enter Email Address",
                    width: 300,
                  ),
                  SizedBox(height: 20),
                  // Password
                  textInputWidget(
                    controller: _pwController,
                    hintText: "Password",
                    isPasswordField: true,
                    width: 300,
                  ),
                  SizedBox(height: 20),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cancel Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: MyButtonStyle(COLOR_ORANGE),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.right,
                        ),
                      ),

                      SizedBox(width: 10),

                      // OK Button
                      TextButton(
                        onPressed: () {
                          login(context);
                        },
                        style: MyButtonStyle(COLOR_ORANGE),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        );
      },
    );
  }

  void login(BuildContext context) async {
    FirbaseAuthService _auth = FirbaseAuthService();

    if (_emailController.text.isEmpty || _pwController.text.isEmpty) {
      MyMessageBox(
        header: "Login Error",
        message: 'Please enter both email and password.',
        image: "assets/images/warning.png",
      ).dialogBuilder(context);
      return;
    }

    if (!_emailController.text.contains('@')) {
      MyMessageBox(
        header: "Login Error",
        message: 'Please enter a valid email address.',
        image: "assets/images/warning.png",
      ).dialogBuilder(context);
      return;
    }

    // Show status indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      User? user =
          await _auth.fireAuthSignIn(_emailController.text, _pwController.text);

      // Pop status indicator
      Navigator.of(context).pop();

      if (user != null) {
        userData.userID = user.uid;
        userData.email = user.email;
        userData.isLoggedIn = true;
        userData.login(user.uid, user.email!);

        print('User logged in');
        Navigator.of(context).pop();
      } else {
        userData.logout();
        print(userData.errorMsg);
        MyMessageBox(
                header: "Error",
                message: userData.errorMsg,
                image: "assets/images/warning.png")
            .dialogBuilder(context);
      }
    } catch (e) {
      // Pop status indicator
      Navigator.of(context).pop();
      print('Error: $e');
    }
  }
}

class SyncLib {
  List<SongData> _songData = [];
  bool _syncBusy = true;
  Function(List<SongData>)? onListUpdate;
  Function(bool)? onSyncDone;

  Future<void> sync(BuildContext context) async {
    List<Reference> lstRef = await fireStoreGetFilesList(userData.userID);
    _songData.clear();

    for (var item in lstRef) {
      String _author = "";
      String _song = "";
      int iEnd = item.name.indexOf('-');
      int iPoint = item.name.indexOf('.');

      if (iEnd == -1) {
        _song = item.name;
      } else {
        _author = item.name.substring(0, iEnd);
        _song = item.name.substring(iEnd + 1, iPoint);
      }

      _songData.add(
        SongData(
          songName: _song.replaceAll('_', ' '),
          author: _author.replaceAll('_', ' '),
          filename: item.name,
        ),
      );

      onListUpdate!(_songData);
    }

    _syncBusy = false;
    onSyncDone!(_syncBusy);
  }
}

class textInputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final double? width;

  const textInputWidget(
      {this.controller,
      this.isPasswordField,
      this.fieldKey,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.width,
      this.onFieldSubmitted,
      this.inputType});

  @override
  _textInputWidgetState createState() => _textInputWidgetState();
}

class _textInputWidgetState extends State<textInputWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      //clipBehavior: Clip.hardEdge,
      //decoration: BoxDecoration(
      //  borderRadius: BorderRadius.circular(4),
      color: Colors.red,
      //),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: widget.isPasswordField == true
                ? Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _obscureText == false ? Colors.blue : Colors.grey,
                  )
                : Text(""),
          ),
        ),
      ),
    );
  }
}

class GlobalSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
      ),
    );
  }

  // Cleanup
  void dispose() {
    //scaffoldMessengerKey.currentState?.dispose();
  }
}

class BitMonitor {
  final ValueNotifier<bool> bit = ValueNotifier<bool>(false);
  final Function(bool) onBitChanged;

  BitMonitor({required this.onBitChanged}) {
    // Listen to changes in the bit
    bit.addListener(() {
      onBitChanged(bit.value); // Fire callback
    });
  }

  // Method to toggle the bit
  void toggleBit() {
    bit.value = !bit.value;
  }

  // Cleanup
  void dispose() {
    bit.dispose();
  }
}

//------------------------------------------------------------------------------
// Classes
//------------------------------------------------------------------------------
