import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teamplayerwebapp/utils/helpers.dart';
import 'package:teamplayerwebapp/utils/firebase.dart';
import 'package:string_validator/string_validator.dart';
import 'package:teamplayerwebapp/utils/globalData.dart';

// Tokens
const tokenTitle = "{title:";
const tokenSubtitle = "{subtitle:";
const tokenComment = "{comment:";
const tokenDefine = "{define:";
const tokenStartOfPart = "{start_of_part:";
const tokenEndOfPart = "{end_of_part}";
const tokenStartOfChorus = "{start_of_chorus}";
const tokenEndOfChorus = "{end_of_chorus}";
const tokenStartOfTab = "{start_of_tab}";
const tokenEndOfTab = "{end_of_tab}";
const tokenLineOfChords = "#C";
const tokenEndOfSong = "#";
const tokenTranspose = "# transpose =";
const tokenVersion = "# version =";

class ViewSong extends StatefulWidget {
  final SongViewModel songView;

  const ViewSong({
    Key? key,
    required this.songView,
  }) : super(key: key);

  @override
  _viewSong createState() => _viewSong();
}

class _viewSong extends State<ViewSong> {
  final PageController _pageController = PageController();
  List<Size> _textSizes = [];
  double _screenWidth = 0;
  double _screenHeight = 0;
  double _padBottom = 50.0;
  double _padTop = 10.0;
  double _maxScreenHeight = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    _maxScreenHeight = _screenHeight - _padTop - _padBottom - 30;
    List<List<Text>> columns = _getSongColumns();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SafeArea(
            child: Text(widget.songView.title, style: songTitleStyle),
          ),
          Text(widget.songView.author, style: songAuthorStyle),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return PageView.builder(
                  itemCount:
                      (columns.length / appSettings.nrOfColumns).ceil().toInt(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int pageIndex) {
                    print("PageIndex = " + pageIndex.toString());
                    return GridView.builder(
                        itemCount: columns.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: appSettings.nrOfColumns,
                          crossAxisSpacing: 10,
                          mainAxisExtent: _maxScreenHeight,
                        ),
                        itemBuilder: (BuildContext context, int widgetIndex) {
                          int index = widgetIndex +
                              (pageIndex * appSettings.nrOfColumns);
                          print("Index = " + index.toString());
                          if (index >= columns.length) return null;
                          int i = 0;
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.black12),
                            child: ListView(
                              children: columns[index],
                            ),
                          );
                        });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController,
            count: (columns.length / appSettings.nrOfColumns).ceil().toInt(),
            effect: WormEffect(
              dotColor: Theme.of(context).colorScheme.primary,
              activeDotColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Size _calcTextSize(String str, TextStyle style) {
    //if (str == "") return const Size(0, 0);

    Text myText = Text(str, style: style);

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(text: myText.data, style: myText.style),
    )..layout();
    // Return the size of the text painter
    return textPainter.size;
  }

  List<List<Text>> _getSongColumns() {
    bool foundAnyText = false;
    List<List<Text>> lstColumns = [];
    List<Text> lstText = [];
    int nr = appSettings.nrOfColumns;
    double maxColumnWidth = (_screenWidth / appSettings.nrOfColumns) - 10;
    double currentPageHeight =
        _calcTextSize(widget.songView.title, songTitleStyle).height + 20;
    currentPageHeight +=
        _calcTextSize(widget.songView.author, songAuthorStyle).height;

    // Itterate Words/Chords Lines
    for (int i = 0; i < widget.songView.songWords.length; i++) {
      String tempWords = "";
      String tempChords = "";
      String words = widget.songView.songWords[i];
      String chords = widget.songView.songChords[i];
      Size sizeWords = _calcTextSize(words, songWordsStyle);
      Size sizeChords = Size(0, 0);

      if (isAscii(chords.replaceAll(" ", ""))) {
        sizeChords = _calcTextSize(chords, songChordsStyle);
      }

      // Assume words is the longest
      Size bigestSize = sizeWords;
      if (sizeChords.width > sizeWords.width) bigestSize = sizeChords;

      // Calc Line span
      int span = (bigestSize.width / maxColumnWidth).ceil();

      // Debug
      if (lstText.length == 23) {
        int c = i;
      }

      if (span >= 1) {
        // Break line up in correct words
        List<String> lst = words.split(" ");

        // Look 1 word ahead and break the line
        // if the next word will not fit
        for (int i = 0; i < lst.length; i++) {
          if (i + 2 <= lst.length) {
            tempWords += lst[i] + " ";
            double currentLen =
                _calcTextSize(tempWords + lst[i + 1], songWordsStyle).width;
            if (currentLen > maxColumnWidth) {
              // Break Chords / Words
              if (chords.length > tempWords.length) {
                // Break Chords according to Words Length
                tempChords = chords.substring(0, tempWords.length);

                if (isAscii(tempChords.replaceAll(" ", ""))) {
                  lstText.add(Text(tempChords, style: songChordsStyle));
                  currentPageHeight += sizeChords.height;
                  foundAnyText = true;
                }
                chords = chords.replaceFirst(tempChords, "");
              } else {
                // Chords fits
                lstText.add(Text(tempChords, style: songChordsStyle));
                chords = chords.replaceFirst(tempChords, "");
                currentPageHeight += sizeChords.height;
                if (isAscii(tempChords.replaceAll(" ", "")))
                  foundAnyText = true;
              }

              lstText.add(Text(tempWords, style: songWordsStyle));
              currentPageHeight += sizeWords.height;
              if (isAscii(tempWords.replaceAll(" ", ""))) foundAnyText = true;

              words = words.replaceFirst(tempWords, "");
              tempWords = "";
              tempChords = "";
            }
          } else {
            // Last word
            // Check Chords first, then write Words
            if (isAscii(chords.replaceAll(" ", ""))) {
              lstText.add(Text(chords, style: songChordsStyle));
              currentPageHeight += sizeChords.height;
            }

            // Now Check words
            if (isAscii(words.replaceAll(" ", ""))) {
              lstText.add(Text(words, style: songWordsStyle));
              currentPageHeight += sizeWords.height;
              foundAnyText = true;
            }
          }
        }
      } else {
        // Whole line fits
        if (chords.length > 0) {
          lstText.add(Text(chords, style: songChordsStyle));
          currentPageHeight += sizeChords.height;
        }
        lstText.add(Text(words, style: songWordsStyle));
        currentPageHeight += sizeWords.height;
      }

      if (currentPageHeight >= _maxScreenHeight - 50) {
        if (foundAnyText) {
          lstColumns.add([...lstText]); // copy clone
          lstText.clear();
          currentPageHeight = 0;
          foundAnyText = false;
        }
      }
    }

    if (foundAnyText) lstColumns.add([...lstText]);
    return lstColumns;
  }

  Text _stripLineTokens(Text text) {
    // # = Line of Chords
    if (text.data!.contains(tokenLineOfChords)) {
      return Text(text.data!.replaceAll(tokenLineOfChords, ""),
          style: songWordsStyle);
    } else
      return text;
  }
}

// Functions
Future<SongViewModel> getSongFromCloud(int index) async {
  List<String> _songWords = [];
  List<String> _songChords = [];
  List<Text> _lstTextWords = [];
  List<Text> _lstTextChords = [];

  SongViewModel _songView = SongViewModel(
    songWords: _songWords,
    songChords: _songChords,
    lstTextWords: _lstTextWords,
    lstTextChords: _lstTextChords,
  );

  String text = await fireStoreReadFile(index);
  List<String> _lines = getLinesFromTxtFile(text);
  bool startOfChord = false;
  bool startOfChorus = false;

  for (String line in _lines) {
    // Title
    if (line.indexOf(tokenTitle) != -1) {
      _songView.title = getToken(tokenTitle, line);
    }

    // Author
    else if (line.indexOf(tokenSubtitle) != -1) {
      _songView.author = getToken(tokenSubtitle, line);
    }

    // Transpose, Version
    else if (line.indexOf(tokenEndOfSong) != -1) {
      _songView.transpose = getToken(tokenTranspose, text);
      _songView.version = getToken(tokenVersion, text);
      break;
    }

    // Song words and chords
    else {
      // {Start of Part}
      if (line.indexOf(tokenStartOfPart) != -1) {
        _songWords.add(getToken(tokenStartOfPart, line));
        _songChords.add("");

        _lstTextChords.add(const Text(""));
        _lstTextWords.add(WriteSongLine(
            getToken(tokenStartOfPart, line), songPartFontSize, Colors.white));
      }

      // {End of Part}
      else if (line.indexOf(tokenEndOfPart) != -1) {
      }

      // {Comment}
      else if (line.indexOf(tokenComment) != -1) {
        if (appSettings.showComments) {
          _songWords.add(getToken(tokenComment, line));
          _songChords.add("");

          _lstTextChords.add(const Text(""));
          _lstTextWords.add(WriteSongLine(
              getToken(tokenComment, line), songWordFontSize, Colors.grey));
        }
      }

      // {define}
      else if (line.indexOf(tokenDefine) != -1) {
        if (appSettings.showDefine) {
          _songWords.add(getToken(tokenDefine, line));
          _songChords.add("");

          _lstTextChords.add(const Text(""));
          _lstTextWords.add(WriteSongLine(
              getToken(tokenDefine, line), songWordFontSize, Colors.grey));
        }
      }

      // {Start of Tabs}
      else if (line.indexOf(tokenStartOfTab) != -1) {
        if (appSettings.showTabs) {
          _songWords.add(getToken(tokenStartOfTab, line));
          _songChords.add("");

          _lstTextChords.add(const Text(""));
          _lstTextWords.add(WriteSongLine(
              getToken(tokenStartOfTab, line), songWordFontSize, Colors.grey));
        }
      }

      // {end of Tabs}
      else if (line.indexOf(tokenEndOfTab) != -1) {
      }

      // {Start of Chorus}
      else if (line.indexOf(tokenStartOfChorus) != -1) {
        startOfChorus = true;

        _songWords.add("Chorus");
        _songChords.add("");

        _lstTextChords.add(const Text(""));
        _lstTextWords
            .add(WriteSongLine("Chorus", songPartFontSize, Colors.red));
      }

      // {End of Chorus}
      else if (line.indexOf(tokenEndOfChorus) != -1) {
        startOfChorus = false;
      }

      // Words and Chords
      else {
        var sbChords = StringBuffer();
        var sbWords = StringBuffer();
        List<String> lastChord = [];
        bool chordEntry = false;
        //lineChords.write(tokenLineOfChords); // Mark chord line with #C token

        for (int i = 0; i < line.length; i++) {
          if (line[i] == '[') {
            startOfChord = true;
            chordEntry = true;
            continue;
          }
          if (line[i] == ']') {
            startOfChord = false;
            continue;
          }
          if (startOfChord) {
            // Chord
            sbChords.write(line[i]);
            lastChord.add(line[i]);
          } else {
            // Words
            sbWords.write(line[i]);
            if (lastChord.isEmpty)
              sbChords.write(" ");
            else {
              lastChord.removeAt(lastChord.length - 1);
            }
          }
        }

        _songChords.add(sbChords.toString());
        _songWords.add(sbWords.toString());

        // Chords
        String _str = sbChords.toString();
        if (_str != "") {
          if (startOfChorus) {
            _str = "  " + _str; // Indent Chorus
          }
          _lstTextChords.add(
              WriteSongLine(_str, songWordFontSize, Colors.deepOrangeAccent));
        }

        // Words
        _str = sbWords.toString();
        if (startOfChorus) _str = "  " + _str; // Indent Chorus
        _lstTextWords.add(WriteSongLine(_str, songWordFontSize, Colors.white));
      }
    }
  }

  // Format Song
  //var _song = StringBuffer();
  // for(int i = 0;i < _songWords.length;i++){
  //   if(_songChords[i] != "") _song.write(_songChords[i] + "\n");
  //   _song.write(_songWords[i] + "\n");
  // }
  return _songView;
}

// View Model
class SongViewModel {
  String title;
  String author;
  String version;
  String transpose;
  String originalChord;
  List<String> songWords;
  List<String> songChords;
  List<Text> lstTextWords;
  List<Text> lstTextChords;

  SongViewModel({
    this.title = "",
    this.author = "",
    this.transpose = "",
    this.originalChord = "",
    this.version = "",
    required this.songWords,
    required this.songChords,
    required this.lstTextWords,
    required this.lstTextChords,
  });
}
