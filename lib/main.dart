// ignore_for_file: unused_import

import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/domain/weeklycalendar.dart';
import 'package:bookapp/firebase_options.dart';
import 'package:bookapp/flows/screenscontrols.dart';
import 'package:bookapp/notify/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of yvour application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (_) => AuthRemote(),
          )
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: kwhitecolor, // primary color for buttons, etc.
              onPrimary: Colors.white, // text color on primary color
              secondary:kwhitecolor, // secondary color for accents
            ),),
            home: const Spalshscreen()
          );
        });
  }
}
