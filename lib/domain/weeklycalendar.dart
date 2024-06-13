import 'dart:async';
import 'package:bookapp/themes/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({Key? key}) : super(key: key);

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  late List<DateTime> _currentDays;
  late String _currentDate = "";
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentDays = formatCurrentLiveDays(); // Initialize _currentDays here
    _currentDate = formatCurrentLiveDates(_currentDays[0]);

    // Update every 24 hours (1 day)
    _timer = Timer.periodic(const Duration(days: 1), (timer) {
      updateCurrentLiveDays();
    });

    updateCurrentLiveDays();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatCurrentLiveDates(DateTime time) {
    return DateFormat('dd MMMM, yyyy').format(time);
  }

  List<DateTime> formatCurrentLiveDays() {
    DateTime now = DateTime.now();
    int daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
    if (daysUntilMonday == 0 && now.weekday != DateTime.monday) {
      daysUntilMonday = 7;
    }
    DateTime monday = now.subtract(Duration(days: now.weekday - DateTime.monday));

    // Generate a list of DateTime objects for the current week starting from Monday
    List<DateTime> currentWeekDays = [];
    for (int i = 0; i < 7; i++) {
      currentWeekDays.add(monday.add(Duration(days: i)));
    }
    return currentWeekDays;
  }

  void updateCurrentLiveDays() {
    DateTime now = DateTime.now();
    DateTime lastDayOfWeek = _currentDays.last;

    // Check if the current date is after the last day of the current week
    if (now.isAfter(lastDayOfWeek)) {
      // Generate a list of DateTime objects for the next week starting from next Monday
      List<DateTime> nextWeekDays = formatCurrentLiveDays();

      // Update the state with the new week's days
      setState(() {
        _currentDays = nextWeekDays;
        _currentDate = formatCurrentLiveDates(_currentDays[0]);
        debugPrint(_currentDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 10),
                        child: Text(
                          'Weekly Calendar',
                          style: GoogleFonts.acme(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_downward,
                        size: 25,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 115,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _currentDays.length,
                      itemBuilder: (context, index) {
                        DateTime day = _currentDays[index];
                        bool isPast = day.isBefore(DateTime.now());
                        return GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (context){
                              return AlertDialog();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 17.0),
                            decoration: BoxDecoration(
                              color: isPast ? kbackgroundColor : Color.fromARGB(0, 0, 0, 0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('EEEE').format(day),
                                  style: GoogleFonts.actor(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isPast ? kblackcolor : kwhitecolor,
                                  ),
                                ),
                                const SizedBox(height: 3.0),
                                Text(
                                  DateFormat('dd MMMM, yyyy').format(day),
                                  style: TextStyle(
                                    color: isPast ? kblackcolor : kwhitecolor,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
