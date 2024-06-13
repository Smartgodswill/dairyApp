// ignore_for_file: use_key_in_widget_constructors

import 'package:bookapp/themes/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNameAnimation extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AppNameAnimationState createState() => _AppNameAnimationState();
}

class _AppNameAnimationState extends State<AppNameAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(
          0.0, -0.2), // Adjust this value to control the jump height
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SlideTransition(
              position: _animation,
              child: Text(
                'Its NetVeX Diary',
                style: GoogleFonts.dancingScript(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
