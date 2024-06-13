// ignore_for_file: prefer_const_constructors

import 'package:bookapp/themes/const.dart';
import 'package:flutter/material.dart';

class HomePageBackground extends StatelessWidget {
  final Widget child;
  const HomePageBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/female.jpg'),fit: BoxFit.cover)
          ),
        ),
          // Dimming Overlay
          Container(
            color:kbackgroundColor.withOpacity(0.5), // Adjust opacity as needed
            width: double.infinity,
            height: double.infinity,
          ),
          // Your Content
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}
