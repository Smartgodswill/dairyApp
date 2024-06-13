// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names, must_be_immutable

import 'package:bookapp/themes/const.dart';
import 'package:bookapp/providers/usersprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MePage extends StatefulWidget {
  String UserName;
  String imageUrl;
  MePage({super.key, required this.UserName, required this.imageUrl});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final ImagePicker picker = ImagePicker();
  Uint8List? images;
  final TextEditingController usernameController = TextEditingController();
  UserProvider userProvider = UserProvider();

  @override
  final currentUser = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(
      Uint8List imageBytes, String imageName) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$imageName');
    UploadTask uploadTask = storageReference.putData(imageBytes);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    WidgetsBinding.instance.addPostFrameCallback((_){
       updateUsersInfo();
    });
   
  }

  void getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('collectionPath')
          .doc(user.uid)
          .get();
      if (snap.exists && snap.data() != null) {
        var data = snap.data() as Map<String, dynamic>;
        widget.UserName = data["userName"] ?? widget.UserName;
        widget.imageUrl = data["images"] ?? widget.imageUrl;
        usernameController.text = widget.UserName;
        setState(() {});
      }
    }
  }

  _getImages(ImageSource sources) async {
    XFile? pickImage = await picker.pickImage(source: sources);
    if (pickImage != null) {
      return await pickImage.readAsBytes();
    }
    _dialog(context, "No Images Selected");
    return null;
  }

  _pickimage() async {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: const Text("Select Image Source"), actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? im = await _getImages(ImageSource.camera);
                  if (im != null) {
                    setState(() {
                      images = im;
                    });
                  }
                },
                child: const Text("Camera"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? im = await _getImages(ImageSource.gallery);
                  if (im != null) {
                    setState(() {
                      images = im;
                    });
                  }
                },
                child: Text("Gallery"),
              ),
            ]));
  }

  void updateUsersInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String imageUrl = widget.imageUrl;
      if (images != null) {
        String imageName =
            'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        try {
          imageUrl = await uploadImageToStorage(images!, imageName);
        } catch (e) {
          return _dialog(context, 'Unable to update images due to $e');
        }
        try {
          final userpovider = Provider.of<UserProvider>(context, listen: false);
          final userinfo =
              userpovider.getUserInfo(usernameController.text, imageUrl);
          

          await FirebaseFirestore.instance
              .collection('collectionPath')
              .doc(user.uid)
              .update(
                  {"userName": usernameController.text, "images": imageUrl});
         setState(() {
          widget.UserName = usernameController.text;
          widget.imageUrl = imageUrl;
        });
          Navigator.pop(context);

          _dialog(context, "profile sucessfully changed");
        } catch (e) {
          _dialog(context, "Failed to update profile: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit your Info',
          style: GoogleFonts.acme(
              fontSize: 30, fontWeight: FontWeight.bold, color: kwhitecolor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
                onPressed: updateUsersInfo,
                child: Text(
                  'Update',
                  style: TextStyle(
                      color: kwhitecolor, fontWeight: FontWeight.bold),
                )),
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: images != null
                            ? MemoryImage(images!)
                            : widget.imageUrl.isNotEmpty
                                ? NetworkImage(widget.imageUrl)
                                : const AssetImage("assets/images.png")
                                    as ImageProvider,
                      ),
                      Positioned(
                          left: 69,
                          right: -10,
                          top: 105,
                          child: IconButton(
                            onPressed: () {
                              _pickimage();
                            },
                            icon: Icon(
                              Icons.add_a_photo_sharp,
                              color: kwhitecolor,
                              size: 30,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      hintText: widget.UserName,
                      hintStyle: TextStyle(color: kwhitecolor),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 25,
                        color: kwhitecolor,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

_dialog(context, String messages) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: kbackgroundColor,
      content: Text(messages),
    ),
  );
}
