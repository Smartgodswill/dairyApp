// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyBackground extends StatelessWidget {
  final Widget child;
  const MyBackground ({super.key, required this.child});

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
            color: const Color.fromARGB(255, 120, 28, 59).withOpacity(0.5), // Adjust opacity as needed
            width: double.infinity,
            height: double.infinity,
          ),
          // Your Content
          Center(
            child:child
          ),
        ],
      ),
    );
  }
}
