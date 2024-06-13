// ignore_for_file: non_constant_identifier_names, unused_import
import 'dart:math';
import 'package:bookapp/custom.dart/time.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/domain/notereaderScreen.dart';
import 'package:bookapp/themes/stylescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:intl/intl.dart';

class NoteScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final String?
      documentId; // use to identify if the note is new or already exist
  const NoteScreen(
      {super.key, this.initialTitle, this.initialContent, this.documentId});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

DateTime _time = DateTime.now();

class _NoteScreenState extends State<NoteScreen> {
  int color_id = Random().nextInt(AppStyles.noteCardColors.length);
  int images_id = Random().nextInt(AppStyles.images.length);
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String initialTitle;
  late String initialContent;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data
    initialTitle = widget.initialTitle ?? '';
    initialContent = widget.initialContent ?? '';
    titleController.text = initialTitle;
    contentController.text = initialContent;
  }

  Future<void> saveNote() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (titleController.text.isNotEmpty &&
            contentController.text.isNotEmpty) {
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(_time); // Format: yyyy-MM-dd
          String formattedTime =
              DateFormat('hh:mm a').format(_time); // Format: HH:mm
          // Check if we're editing an existing note or creating a new one
          String updatedTitle = titleController.text;
          String updatedContent = contentController.text;
          if (widget.documentId != null) {
            FirebaseFirestore.instance
                .collection("Notes")
                .doc(widget.documentId)
                .update({
                  "title": updatedTitle,
                  "note contains": updatedContent,
                  "current_date": formattedDate,
                  "current_time": formattedTime,
                  "color_id": color_id,
                  "image_id": images_id
                })
                .then((value) => Navigator.pop(context, true))
                .catchError((error) => debugPrint(
                    'An error occurred while trying to update your note. Please check your internet connection and try again. $error'));
          } else {
            // Create new note
            FirebaseFirestore.instance
                .collection("Notes")
                .add({
                  "title": titleController.text,
                  "note contains": contentController.text,
                  "current_date": formattedDate,
                  "current_time": formattedTime,
                  "uid": user.uid,
                  "color_id": color_id,
                  "image_id": images_id
                })
                .then((value) => Navigator.pop(context, true))
                .catchError((error) => debugPrint(
                    'An error occurred while trying to save your note. Please check your internet connection and try again. $error'));
          }
        } else {
          _dialog(context, 'Please enter both Title and Note before saving.');
        }
      }
    } catch (e) {
      _dialog(context, 'An error occurred: $e');
      print('An error occurred: $e');
    }
  }

  var _currentTextStyle = GoogleFonts.dancingScript(
      fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white);
  void changeTextFonts(TextStyle styles) {
    setState(() {
      _currentTextStyle = styles;
    });
  }

  List<String> FontsName = [
    "stylo",
    "Acme",
    'Dando',
    'Mega',
    "Mela",
    "rubbet",
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyles.noteCardColors[color_id],
          actions: [
            MaterialButton(
              onPressed: saveNote,
              child: Text(
                widget.documentId != null ? 'Update' : 'Save',
                style: AppStyles.dateStyle,
              ),
            )
          ],
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AppStyles.images[images_id], fit: BoxFit.fitHeight)),
          ),
          Container(
            color: kcombinecolor.withOpacity(0.5), // Adjust opacity as needed
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: titleController,
                    cursorColor: kwhitecolor,
                    style: AppStyles.titleStyle,
                    decoration: InputDecoration(
                        hintText: "Enter Title........",
                        hintStyle: AppStyles.titleStyle),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DeviceTimeWidget(
                          text: formattedTime, style: AppStyles.timeStyle),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formattedDate,
                          style: AppStyles.dateStyle,
                        )),
                  ],
                ),
                
                 
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Notefonts',
                            style: GoogleFonts.acme(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: kwhitecolor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:IconButton(onPressed: (){
                              showDialog(context: context, builder: (context){
                             return   Padding(
                               padding: const EdgeInsets.only(bottom: 350),
                               child: AlertDialog(
                                backgroundColor: kbackgroundColor,
                                    content: Container(
                                      height: 400,
                                      width: double.infinity,
                                      child: Container(
                          height: 80,
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: FontsName.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 9, left: 6, right: 6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: MaterialButton(
                                      
                                      onPressed: () {
                                        changeTextFonts(
                                            AppStyles.TextStyleItems[index]);
                                      },
                                      child: Text(
                                        FontsName[index],
                                        style: GoogleFonts.acme(
                                            fontSize: 20,
                                            letterSpacing: 4,
                                            fontWeight: FontWeight.bold,
                                            color: kwhitecolor),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                                    ),
                                  ),
                             );
                              });
                            }, icon: Icon(Icons.menu,color: kwhitecolor,),color: kwhitecolor,)
                          )
                        ],
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: contentController,
                      maxLines: MediaQuery.of(context).size.width.toInt(),
                      cursorColor: kwhitecolor,
                      style: _currentTextStyle,
                      decoration: InputDecoration(
                        hintText: "Note.......",
                        hintStyle: GoogleFonts.acme(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ]));
  }
}

_dialog(context, String messages) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error,
              size: 30,
              color: kbackgroundColor,
            ),
            Text(
              'Oops!',
              style: GoogleFonts.acme(
                  fontSize: 20.5,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 230, 25, 11)),
            ),
          ],
        ),
        content: Text(
          messages,
          style: GoogleFonts.acme(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kbackgroundColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text(
              'Got it',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}
