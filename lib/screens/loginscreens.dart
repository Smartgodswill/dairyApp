// ignore_for_file: unnecessary_import, prefer_const_constructors, use_build_context_synchronously

import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/design/dimBackgroundimages.dart';
import 'package:bookapp/flows/verification.dart';
import 'package:bookapp/screens/resetpasswordscreen.dart';
import 'package:bookapp/screens/signupscreens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({
    super.key,
  });

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emaileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmepasswordController = TextEditingController();
  bool isloading = false;
  bool visible = true;
  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthRemote>(context);
    Future<void> signInUser(BuildContext context) async {
      try {
        setState(() {
          isloading = true;
        });
        String result = await authcontroller.signIn(
            emaileController.text.trim(),
            passwordController.text.trim(),
            confirmepasswordController.text.trim());
        if (result != 'sucess') {
          _dialog(context, result);
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return VerificationEmail();
          }));
        }
      } catch (error) {
        _dialog(context, 'Authentication error:${error.toString()}');
      }
      setState(() {
        isloading = false;
      });
    }

    return Scaffold(
        body: DimImages(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 0, top: 25),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Text(
                      'Welcome Back! ',
                      style: GoogleFonts.acme(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'SignIn ',
                    style: GoogleFonts.acme(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
              child: TextFormField(
                controller: emaileController,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
              child: TextFormField(
                controller: passwordController,
                obscureText: visible,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          visible =!visible;
                        });
                      },
                      child: visible
                          ? Icon(
                              Icons.visibility_off,
                              size: 30,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 30,
                            ),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Password',
                    border: OutlineInputBorder()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ResetpasswordScreens();
                      }));
                    },
                    child: Text(
                      'Forgotten password?',
                      style: TextStyle(
                          color: Color.fromARGB(255, 233, 17, 1),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
              child: TextFormField(
                controller: confirmepasswordController,
                decoration: InputDecoration(
                    labelText: 'ConfirmPassword',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Confirm-Password',
                    border: OutlineInputBorder()),
                  
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Don\'t have an Account?',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return SignupScreen();
                      }));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Color.fromARGB(255, 233, 17, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () => signInUser(context),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 62,
                    width: 300,
                    decoration: BoxDecoration(
                        color: kpurplecolor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: isloading
                          ? Center(
                              child: CircularProgressIndicator(
                      color: kwhitecolor,
                    )
                            )
                          : Text(
                              'SignIn',
                              style: GoogleFonts.acme(
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  void _dialog(context, String messages) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messages),
      ),
    );
  }
}
