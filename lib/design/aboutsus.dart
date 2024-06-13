// ignore_for_file: prefer_const_constructors

import 'package:bookapp/themes/const.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  final Widget child;
  const AboutUs({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(125)),
              image: DecorationImage(image: AssetImage('assets/us.jpg'),fit: BoxFit.cover)
            ),
          ),
        ),
          // Dimming Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
                          color:kbackgroundColor.withOpacity(0.2), // Adjust opacity as needed

            ),
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
