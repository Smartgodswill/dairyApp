// ignore_for_file: library_private_types_in_public_api, unused_import

import 'package:bookapp/custom.dart/textAnimation.dart';
import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/flows/screenscontrols.dart';
import 'package:bookapp/screens/signupscreens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Spalshscreen extends StatefulWidget {
  const Spalshscreen({Key? key}) : super(key: key);

  @override
  _SpalshscreenState createState() => _SpalshscreenState();
}

class _SpalshscreenState extends State<Spalshscreen> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Future.delayed( const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: _isLoading
          ?   JumpingAnimation()
          :  const ScreesnController()
    ),
          );
  }
}
