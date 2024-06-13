import 'dart:ui';

import 'package:bookapp/themes/const.dart';
import 'package:flutter/material.dart';

class BackDrop extends StatelessWidget {
   final Widget child;
  const BackDrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(-3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration:
                    BoxDecoration(color: kblackcolor, shape: BoxShape.circle),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration:
                    BoxDecoration(color: kblackcolor, shape: BoxShape.circle),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -1.2),
              child: Container(
                height: 300,
                width: 600,
                decoration: BoxDecoration(
                  color:kcombinecolor,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
              child: Container(
                child: child,
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
