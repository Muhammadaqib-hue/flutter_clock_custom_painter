import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_custom_design_painter/clock_painter.dart';

void main() => runApp(ClockApp());

class ClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ClockWidget(),
        ),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();

  final Duration updateInterval = Duration(seconds: 1);
  final double clockSize = 350;
  final double boxShadowBlur = 30;
  final double boxShadowSpread = 20;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(updateInterval, (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: clockSize,
      height: clockSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: boxShadowBlur,
            spreadRadius: boxShadowSpread,
          ),
        ],
      ),
      child: CustomPaint(
        painter: ClockPainter(_dateTime),
      ),
    );
  }
}
