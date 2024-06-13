// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/design/dimBackgroundimages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetpasswordScreens extends StatefulWidget {
  const ResetpasswordScreens({super.key});

  @override
  State<ResetpasswordScreens> createState() => _ResetpasswordScreensState();
}

class _ResetpasswordScreensState extends State<ResetpasswordScreens> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthRemote>(context);
    Future<void> resetPassword() async {
      String email = emailController.text.trim();
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email address')),
        );
        return;
      }
      try {
        String result = await authcontroller.resetPassword(
            email:email);
        _dialog(context, result);
        // Navigate back to the login screen
        Navigator.of(context).pop();
      } catch (e) {
        _dialog(context, e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Reset your password',
          style: GoogleFonts.acme(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kbackgroundColor,
      ),
      body: SafeArea(
        child: DimImages(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 10, top: 25),
              child: Text(
                'Please enter your email to reset your password.',
                style: GoogleFonts.acme(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 10),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: 'Enetr your email',
                    labelText: ' Enter your email',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: kpurplecolor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:  Center(
                        child: Text('Cancel', style: GoogleFonts.arimo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: kpurplecolor,
                      onPressed: () async {
                        resetPassword();
                      },
                      child: Center(
                        child: Text('Reset password', style: GoogleFonts.arimo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )),
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
