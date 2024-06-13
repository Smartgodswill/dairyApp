// ignore_for_file: avoid_print, body_might_complete_normally_nullable, unused_local_variable, unnecessary_string_interpolations

import 'dart:async';
import 'dart:typed_data';
import 'package:bookapp/models/users.dart'as model;
import 'package:bookapp/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'Package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthRemote {
  final  auth.FirebaseAuth _firebaseAuth=auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firestorage = FirebaseStorage.instance;
  Future<String> saveUserImages(
      String childName, bool isposted, Uint8List images) async {
    Reference ref = _firestorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);
    UploadTask uploadtask = ref.putData(images);
    TaskSnapshot snap = await uploadtask;
    String downloadImages = await snap.ref.getDownloadURL();
    return downloadImages;
  }
  Future<String> uploadImageToStorage(
      Uint8List imageBytes, String imageName) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$imageName');
    UploadTask uploadTask = storageReference.putData(imageBytes);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> register(String userName, String password, String email,
      String confirmPassword, Uint8List? images) async {
    String res = "Some error occured";
    try {
      if (password == confirmPassword ||
          password.isNotEmpty ||
          email.isNotEmpty ||
          userName.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          images != null) {
        UserCredential credential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(credential.user!.uid);
        String downloadImages = await saveUserImages('images', false, images!);
                  model.Users users= model.Users(false,pofile:downloadImages ,confirmpassword: confirmPassword, uid: credential.user!.uid, email: email, password: password, userName: userName);

        await firestore
            .collection('collectionPath')
            .doc(credential.user!.uid)
            .set({
          "uid": credential.user!.uid,
          "email": email,
          "userName": userName,
          "password": password,
          "images": downloadImages
        });
        debugPrint('success');
        return "Success";
      }else{
        return "password does not match";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        // Provide custom message to the user
        res = "please enter correct information";
      } else {
        return e.message ?? 'An error occurred';
      }
    } catch (e) {
      res = e.toString();
      rethrow;
    }
    return res;
  }

  Users? _usersFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }else{

    
    return Users(false,confirmpassword: '', uid:user.uid, email: user.email, password: '', userName: user.displayName, pofile: '');
  }}

  Stream<Users?>? get user {
    return _firebaseAuth.authStateChanges().map(_usersFromFirebase);
  
  }

  Future<String> signIn(
      String email, String password, String confirmPassword) async {
    String res = "Some error occured";
    try {
      if (password == confirmPassword) {
        final creds = await _firebaseAuth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        return 'sucess';
      } else {
        return "password does not match";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Error' &&
          e.message == 'Unable to establish connection on channel') {
        return "Please enter your info";
      } else if (e.code ==
              'The supplied auth credential is incorrect, malformed or has expired.' ||
          e.code ==
              " A network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
        return "email not vaild please register";
      } else {
        return e.message ?? 'An error occurred';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signout() async {
    String res = "Some error occured";
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      res = e.toString();
       print('Error during sign-out: $e');
      rethrow;
    }
    return res;
  }

  Future<String> resetPassword({
    required String email,
  }) async {
    String res = "An error occured";
    try {
      if(email.isNotEmpty){
         await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email sent successfully";
      }else{
         return "Please enter your email address";
      }
     
    } on FirebaseAuthException catch (e) {
    
        return e.message ?? "Error";
    
    } catch (e) {
      print('Error sending password reset email: ${e.toString()}');
         return res.toString();
    }
   
  }
   Future<List<QueryDocumentSnapshot>> getUserNotes(User? userId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Notes')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching user notes: $e');
      return [];
    }
  }
   Future<void>updateusersDetails(String userName,String imageUrl)async{
    User? users = FirebaseAuth.instance.currentUser;
    if(users!=null){
      try {
        await FirebaseFirestore.instance.collection('collectionPath').doc(users.uid).update({
      "userName":userName,
      "imageUrl":imageUrl
    });
      } catch (e) {
        print('Unable to update profile due to $e');
      }
    }
    
  }
}
