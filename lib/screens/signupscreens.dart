// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:typed_data';

import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/design/dimBackgroundimages.dart';
import 'package:bookapp/flows/verification.dart';
import 'package:bookapp/screens/loginscreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmepasswordController = TextEditingController();
  final emailController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  Uint8List? images;
  bool visible = false;
  bool _isloading = false;

  _getImages(ImageSource sources) async {
    XFile? pickImage = await picker.pickImage(source: sources);
    if (pickImage != null) {
      return await pickImage.readAsBytes();
    }
    _dialog(context, "No Images Selected");
  }

  _pickimage() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text(
                  "Select Image Source",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  MaterialButton(
                    color: kblackcolor,
                    onPressed: () async {
                      Navigator.pop(context);
                      Uint8List? im = await _getImages(ImageSource.camera);
                      if (im != null) {
                        setState(() {
                          images = im;
                        });
                      }
                    },
                    child: Text(
                      "Camera",
                      style: TextStyle(color: kwhitecolor),
                    ),
                  ),
                  MaterialButton(
                    color: kblackcolor,
                    onPressed: () async {
                      Navigator.pop(context);
                      Uint8List? im = await _getImages(ImageSource.gallery);
                      if (im != null) {
                        setState(() {
                          images = im;
                        });
                      }
                    },
                    child: Text(
                      "Gallery",
                      style: TextStyle(color: kwhitecolor),
                    ),
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthRemote>(context);
    Future<void> register(BuildContext context) async {
      String res = "An error occured";
      try {
        setState(() {
          _isloading = true;
        });
        String result = await authcontroller.register(
            usernameController.text,
            passwordController.text,
            emailController.text,
            confirmepasswordController.text,
            images);
        if (result == 'sucess') {
         
           Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VerificationEmail(),
        ),
      );
        }else{
           _dialog(context, result);
        }
      } catch (e) {
        if (e.toString() == 'Null check operator used on a null value') {
          return _dialog(context,
              'Please check your email click the link to get verified  ');
        }
        _dialog(context, e.toString());
      }
      setState(() {
        _isloading = false;
      });
    }

    return Scaffold(
        body: DimImages(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 220, top: 25),
              child: Text(
                'Register',
                style: GoogleFonts.acme(
                    fontSize: 43,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Stack(
              children: [
                images != null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundImage: MemoryImage(images!),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images.png')),
                Positioned(
                    left: 70,
                    right: -10,
                    top: 125,
                    child: IconButton(
                        onPressed: () {
                          _pickimage();
                        },
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          color: kwhitecolor,
                          size: 30,
                        )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: 'UserName',
                    labelText: 'UserName',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                            color: kwhitecolor))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                obscureText: visible,
                controller: passwordController,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          visible = !visible;
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
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    hintText: 'Password',
                    border: OutlineInputBorder()),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Already have an Account?',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LogInScreen();
                      }));
                    },
                    child: Text(
                      'SignIn',
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
                onTap: () => register(context),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 62,
                  width: 250,
                  decoration: BoxDecoration(
                      color: kpurplecolor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: _isloading
                        ? Text(
                            'Loading...',
                            style: TextStyle(
                                color: kwhitecolor,
                                fontWeight: FontWeight.bold),
                          )
                        : Center(
                            child: Text(
                              'Register',
                              style: GoogleFonts.acme(
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Or ',
                  style: GoogleFonts.acme(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.all(0),
                  height: 65,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(236, 138, 132, 132),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(0, 240, 227, 227),
                          radius: 25,
                          backgroundImage: AssetImage('assets/google.jpg'),
                        ),
                      ),
                      Text(
                        ' Continue with Google',
                        style: GoogleFonts.acme(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kblackcolor),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}

_dialog(context, String messages) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messages),
    ),
  );
}
