// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 
class AppStyles {
    static List<TextStyle> TextStyleItems = [
    GoogleFonts.acme(
        fontSize: 20.5, fontWeight: FontWeight.bold, color: Colors.white),
    GoogleFonts.abel(
        fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
    GoogleFonts.adventPro(
        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
         GoogleFonts.akronim(
        fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
         GoogleFonts.k2d(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
         GoogleFonts.alef(
        fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
         GoogleFonts.alkalami(
        fontSize:16, fontWeight: FontWeight.bold, color: Colors.white),
         GoogleFonts.bokor(
        fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),

  ];
  static List<Color> noteCardColors =  [
     Color.fromARGB(143, 35, 88, 0),
     Color.fromARGB(59, 8, 94, 0),
     Color.fromARGB(108, 0, 139, 0),
     Color.fromARGB(200, 9, 54, 4),

  ];
   static List<AssetImage>images=[
    AssetImage('assets/images1.jpg'),
    AssetImage('assets/images2.jpg'),
    AssetImage('assets/images3.jpg'),
    AssetImage('assets/images4.jpg'),
    AssetImage('assets/images5.jpg'),
   ];
  static TextStyle titleStyle = GoogleFonts.acme(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,);
  static TextStyle contentStyle = GoogleFonts.dancingScript(
      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle dateStyle =  GoogleFonts.acme(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle timeStyle = GoogleFonts.acme(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
}
