import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[150],
          appBar: AppBar(
            title: Text("CURRENCY",
              style: GoogleFonts.majorMonoDisplay()
            ),
            centerTitle: true,
            backgroundColor: Colors.black26,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Converter(),
              ),

              Container(
                margin: EdgeInsets.only(
                  bottom: 5
                ),
                child: Text("Data from European Central Bank - " + DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString(),
                  style: GoogleFonts.majorMonoDisplay(
                    fontSize: 8
                  ),
                ),
              ),
              
            ],
          ),
        ),
      )
    );
  }
}

class Converter extends StatefulWidget {
  Converter({Key key}) : super(key: key);

  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  var _upperText = new TextEditingController();
  var _lowerText = new TextEditingController();
  double _upperNum = 0;
  double _lowerNum = 0;
  String _upperChoice = 'USD';
  String _lowerChoice = 'MYR';
  String url;
  
  Map data;

  Future<String> getCurrencyData(String currencyType) async {
    var res = await http.get('https://api.exchangeratesapi.io/latest?base=' + currencyType);
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody['rates'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    getCurrencyData(_upperChoice);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: upperField(),
                  flex: 6
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 25
                    ),
                    child: IconButton(
                      icon: Icon(Icons.attach_money),
                      onPressed: () {
                        showCupertinoModalPopup(context: context, builder: (context) => cupertinoCurrencySheet(context, 1));
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),

        Icon(Icons.arrow_downward),

        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: lowerField(),
                  flex: 6
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 25
                    ),
                    child: IconButton(
                      icon: Icon(Icons.attach_money),
                      onPressed: () {
                        showCupertinoModalPopup(context: context, builder: (context) => cupertinoCurrencySheet(context, 2));
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget upperField() {
    return Container(
      padding: EdgeInsets.only(
        left: 100,
      ),
      child: TextFormField(
        autofocus: false,
        controller: _upperText,
        onChanged: (text) {
          setState(() {
            try {
              if (text != "") {
                _upperNum = double.parse(text);
                _upperNum = _upperNum * data[_lowerChoice];
              }
            } catch (ex) { print(ex); }
          });

          _lowerText.text = _upperNum.toStringAsFixed(2);
        },
        keyboardType: TextInputType.number,
        keyboardAppearance: Theme.of(context).brightness,
        decoration: InputDecoration(
          labelText: _upperChoice,
          labelStyle: GoogleFonts.ubuntu(
            color: Colors.white,
            fontWeight: FontWeight.w500
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            )
          )
        ),
      ),
    );
  }

  Widget lowerField() {
    return Container(
      padding: EdgeInsets.only(
        left: 100,
      ),
      child: TextFormField(
        autofocus: false,
        controller: _lowerText,
        onChanged: (text) {
          setState(() {
            try {
              if (text != "") {
                _lowerNum = double.parse(text);
                _lowerNum = _lowerNum / data[_lowerChoice];
              }
            } catch (ex) { print(ex); }
          });

          _upperText.text = _lowerNum.toStringAsFixed(2);
        },
        keyboardType: TextInputType.number,
        keyboardAppearance: Theme.of(context).brightness,
        decoration: InputDecoration(
          labelText: _lowerChoice,
          labelStyle: GoogleFonts.ubuntu(
            color: Colors.white,
            fontWeight: FontWeight.w500
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            )
          )
        ),
      ),
    );
  }

  Widget cupertinoCurrencySheet(context, int field) {
    return CupertinoActionSheet(
      title: Text("CHOOSE CURRENCY",
        style: GoogleFonts.majorMonoDisplay(
          fontSize: 24
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget> [
        CupertinoActionSheetAction(
          child: Text("United States Dollar"),
          onPressed: () {
            if (field == 1) {
              setState(() {
                _upperChoice = "USD";

              });
              getCurrencyData("USD");
              
            } else {
              setState(() {
                _lowerChoice = "USD";

              });
            }
            Navigator.pop(context);
          },
        ),

        CupertinoActionSheetAction(
          child: Text("Malaysian Ringgit"),
          onPressed: () {
            if (field == 1) {
              setState(() {
                _upperChoice = "MYR";

              });
              getCurrencyData("MYR");

            } else {
              setState(() {
                _lowerChoice = "MYR";

              });
            }
            Navigator.pop(context);
          },
        ),

        CupertinoActionSheetAction(
          child: Text("Singaporian Dollar"),
          onPressed: () {
            if (field == 1) {
              setState(() {
                _upperChoice = "SGD";

              });
              getCurrencyData("SGD");

            } else {
              setState(() {
                _lowerChoice = "SGD";

              });
            }
            Navigator.pop(context);
          },
        ),

        CupertinoActionSheetAction(
          child: Text("Japanese Yen"),
          onPressed: () {
            if (field == 1) {
              setState(() {
                _upperChoice = "JPY";

                convertCurrencyAndShow(field);
              });
              getCurrencyData("JPY");

            } else {
              setState(() {
                _lowerChoice = "JPY";

                convertCurrencyAndShow(field);
              });
            }
            Navigator.pop(context);
          },
        ),
      ]
    );
  }

  //only for cupertinoactionsheet
  void convertCurrencyAndShow(int field) {
    if (field == 1) {
      try {
        if (_upperText.text != "") {
          _upperNum = double.parse(_lowerText.text) * data[_upperChoice];
          _upperText.text = _upperNum.toStringAsFixed(2);
        }
      } catch (ex) { print(ex); }
    } else {
      try {
        if (_lowerText.text != "") {
          _lowerNum = double.parse(_upperText.text) * data[_lowerChoice];
          _lowerText.text = _lowerNum.toStringAsFixed(2);
        }
      } catch (ex) { print(ex); }
    }
  }
}