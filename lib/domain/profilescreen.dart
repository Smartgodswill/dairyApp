// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<DateTime> _days;

  _CalendarScreenState() {
    _generateDays();
  }

  void _generateDays() {
    DateTime now = DateTime.now();
    _days = List.generate(7, (index) => now.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar View'),
      ),
      body: ListView.builder(
        itemCount: _days.length,
        itemBuilder: (context, index) {
          DateTime day = _days[index];
          bool isPast = day.isBefore(DateTime.now());
          return Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isPast ? Colors.grey : Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('EEEE').format(day),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  DateFormat('MMMM d').format(day),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
