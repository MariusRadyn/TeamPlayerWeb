import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamplayerwebapp/theme/theme_constants.dart';
import 'package:teamplayerwebapp/utils/global_data.dart';

enum SlideActions { Share, Delete, Sync }

// Functions
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

// Stateless Widgets
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
    return Expanded(
      child: ListTile(
        //tileColor: Theme.of(context).colorScheme.primary,
        dense: true,
        //splashColor: Colors.cyan,
        //Delete Icon
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
        ),
        title: Text(
          text,
          overflow: TextOverflow.ellipsis,
          //style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //color: Theme.of(context).colorScheme.onPrimary,
          //),
        ),
        subtitle: Text(subText, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
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
    this.image = "images/warning.png",
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
  String image;

  MyMessageBox({required this.message, this.image = ""});

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
