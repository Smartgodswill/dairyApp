// ignore_for_file: must_be_immutable

import 'package:bookapp/domain/notescreen.dart';
import 'package:bookapp/themes/stylescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteReaderScreen extends StatefulWidget {
  QueryDocumentSnapshot doc;
  NoteReaderScreen({super.key, required this.doc});

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

DateTime now = DateTime.now();
String formattedDate =
    DateFormat('yyyy-MM-dd').format(now); // Format: yyyy-MM-dd
String formattedTime = DateFormat('hh:mm a').format(now); // Format: HH:mm

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    int colors = widget.doc['color_id'];
    int images = widget.doc['image_id'];
    return Scaffold(
      backgroundColor: AppStyles.noteCardColors[colors],
      appBar: AppBar(
        backgroundColor: AppStyles.noteCardColors[colors],
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 25,
                ),
                onPressed: () {
                  // Delete the document from Firestore
                  FirebaseFirestore.instance
                      .collection("Notes")
                      .doc(widget.doc.id)
                      .delete()
                      .then((value) {
                    // Navigate back to the previous screen after deleting
                    Navigator.pop(context);
                  }).catchError((error) {
                    // Handle any errors that occur during deletion
                    print("Error deleting note: $error");
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return NoteScreen(
                      initialTitle: widget.doc["title"],
                      initialContent: widget.doc["note contains"],
                      documentId: widget.doc.id,
                    );
                  }));
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.doc['title'],
                style: AppStyles.titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      formattedTime,
                      style: AppStyles.dateStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      formattedDate,
                      style: AppStyles.timeStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.doc['note contains'],
                  style: AppStyles.contentStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
