// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:async';

import 'package:bookapp/themes/const.dart';
import 'package:bookapp/design/dimBackgroundimages.dart';
import 'package:bookapp/screens/homepage.dart';
import 'package:bookapp/screens/loginscreens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail();

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  bool isEmailVerified = false;
  bool cancelReSendEmail = false;
  TextEditingController username = TextEditingController();
  Timer? time;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      time =
          Timer.periodic(const Duration(seconds: 9), (_) => checkEmailVerified);
    }
  }

  @override
  void dispose() {
    super.dispose();
    time?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => cancelReSendEmail = false);
      await Future.delayed(const Duration(seconds: 8));
      setState(() => cancelReSendEmail = true);
    } catch (e) {
      _dialog(context, 'Error in verification$e');
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) time?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage(
        )
      : Scaffold(
          body: DimImages(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Check your mail to get Verified',
                    style: GoogleFonts.acme(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
               
                MaterialButton(
                  color: kpurplecolor,
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const LogInScreen();
                    }));
                  },
                  child:  Text('Got a link Login then',  style: GoogleFonts.acme(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: MaterialButton(
                                       color: kbackgroundColor,
                                       onPressed: () async {
                      FirebaseAuth.instance.signOut();
                                       },
                                       child: const Text('cancel'),
                                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: GestureDetector(
                      
                      onTap: cancelReSendEmail ? sendVerificationEmail : null,
                      child: const Text('Resend verification link?')),
                   ),
                ],
              )
               
              ],
            ),
          ),
        );
}

_dialog(BuildContext context, String messages) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messages),
    ),
  );
}
