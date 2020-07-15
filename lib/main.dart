import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:intl/intl.dart' show DateFormat;

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          // ignore: deprecated_member_use
          display1: TextStyle(color: Colors.black38, fontSize: 30),
        ),
        fontFamily: 'Alatsi',
      ),
      home: Scaffold(
        body: SafeArea(child: Clock()),
      ),
    );
  }
}

class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  BinaryTime _now = BinaryTime();

  // Tick the clock
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        _now = BinaryTime();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Columns for the clock
          ClockColumn(
            binaryInteger: _now.hourTens,
            title: 'H',
            color: Colors.blue,
            rows: 2,
          ),
          ClockColumn(
            binaryInteger: _now.hourOnes,
            title: 'h',
            color: Colors.lightBlue,
          ),
          ClockColumn(
            binaryInteger: _now.minuteTens,
            title: 'M',
            color: Colors.green,
            rows: 3,
          ),
          ClockColumn(
            binaryInteger: _now.minuteOnes,
            title: 'm',
            color: Colors.lightGreen,
          ),
          ClockColumn(
            binaryInteger: _now.secondTens,
            title: 'S',
            color: Colors.pink,
            rows: 3,
          ),
          ClockColumn(
            binaryInteger: _now.secondOnes,
            title: 's',
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }
}

/// Fixed range of 4 rows per column
// List fixedRows = Iterable<int>.generate(4).toList();

/// Column to represent a binary integer.
class ClockColumn extends StatelessWidget {
  String binaryInteger;
  String title;
  Color color;
  int rows;
  List bits;

  ClockColumn({this.binaryInteger, this.title, this.color, this.rows = 4}) {
    bits = binaryInteger.split('');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...[
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.display1,
              ),
            )
          ],
          ...bits.asMap().entries.map((entry) {
            int idx = entry.key;
            String bit = entry.value;

            bool isActive = bit == '1';
            int binaryCellValue = pow(2, 3 - idx);

            return Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 475),
                curve: Curves.ease,
                height: 40,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: isActive
                      ? color
                      : idx < 4 - rows
                          ? Colors.white.withOpacity(0)
                          : Colors.black38,
                ),
                margin: EdgeInsets.all(4),
                child: Center(
                  child: isActive
                      ? Text(
                          binaryCellValue.toString(),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Container(),
                ),
              ),
            );
          }),
          ...[
            Text(
              int.parse(binaryInteger, radix: 2).toString(),
              style: TextStyle(fontSize: 30, color: color),
            ),
            Container(
              child: Text(
                binaryInteger,
                style: TextStyle(fontSize: 15, color: color),
              ),
            )
          ]
        ],
      ),
    );
  }
}

/// Utility class to access values as binary integers
class BinaryTime {
  List<String> binaryIntegers;

  BinaryTime() {
    DateTime now = DateTime.now();
    String hhmmss = DateFormat("Hms").format(now).replaceAll(':', '');

    binaryIntegers = hhmmss
        .split('')
        .map((str) => int.parse(str).toRadixString(2).padLeft(4, '0'))
        .toList();
  }

  get hourTens => binaryIntegers[0];
  get hourOnes => binaryIntegers[1];
  get minuteTens => binaryIntegers[2];
  get minuteOnes => binaryIntegers[3];
  get secondTens => binaryIntegers[4];
  get secondOnes => binaryIntegers[5];
}
