// ignore_for_file: unused_import

import 'package:bookapp/design/aboutsus.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/design/dimBackgroundimages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  //the url i want to launch
  final Uri facebookUrl =
      Uri.parse('https://www.facebook.com/profile.php?id=100090064172536');
  Future<void> launchUrl(Uri url) async {
    if (await canLaunchUrl(facebookUrl)) {
      await launchUrl(url);
    } else {
     throw _dialog(context, 'Could not open link$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        centerTitle: true,
        title: Text(
          'About Us',
          style: GoogleFonts.acme(
              fontSize: 30, fontWeight: FontWeight.bold, color: kwhitecolor),
        ),
      ),
      body: DimImages(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25)),
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                height: 200,
                child: const AboutUs(child: SizedBox()),
              ),
              Container(
                decoration: BoxDecoration(
                    color: kbackgroundColor,
                    borderRadius: BorderRadius.circular(25)),
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                height: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Text(
                    'Hello! welcome to NetVex, the cutting-edge platform dedicated to transforming the landscape of network management. At NetVex, our core mission is to simplify and enhance the way you connect, manage, and secure your digital environments. We provide a comprehensive suite of tools tailored to meet the evolving needs of businesses, IT professionals,great user interfaces and tech enthusiasts alike.',
                    style: GoogleFonts.acme(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kwhitecolor,
                        letterSpacing: 2),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: kwhitecolor,
                    borderRadius: BorderRadius.circular(25)),
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                height: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 40, left: 15, right: 15),
                  child: Text(
                    'Our Vision:'
                    'We envision a world where managing complex networks is effortless and accessible to everyone. By leveraging cutting-edge technology and a user-centric approach, NetVex strives to be the go-to solution for all your network management needs.',
                    style: GoogleFonts.acme(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kbackgroundColor,
                        letterSpacing: 2),
                  ),
                ),
              ),
               Container(
                decoration:
                    BoxDecoration(
                      color: kbackgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                height: 70,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                'For more info:Please click the link below:',
                style: GoogleFonts.acme(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kwhitecolor),
              ),
              GestureDetector(
                onTap: () => launchUrl(facebookUrl),
                child:  Text('WWW.facebook.NetVex.com', style: GoogleFonts.acme(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                     decoration: TextDecoration.underline,
                    color: kwhitecolor),),
              )
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
_dialog(context, String messages) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messages),
    ),
  );
}