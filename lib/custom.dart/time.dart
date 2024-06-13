// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';

class DeviceTimeWidget extends StatefulWidget {
  final String text;
  final TextStyle style;

  const DeviceTimeWidget({super.key, required this.text, required this.style});
  @override
  _DeviceTimeWidgetState createState() => _DeviceTimeWidgetState();
}

class _DeviceTimeWidgetState extends State<DeviceTimeWidget> {
  late String currentTime;
    late Timer timer;
  @override
  void initState() {
    super.initState();
    // Initialize the current time
    currentTime = _getCurrentTime();
    // Start a timer to update the time every second
   timer= Timer.periodic( const Duration(seconds: 1), (Timer timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }
  
  String _getCurrentTime() {
    // Get the current time
    DateTime now = DateTime.now();
    // Format the time as desired
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: widget.style,
    );
  }
}

