// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const  Center(child: Text('No user is signed in.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('collectionPath').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const  Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user data available.'));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        String userName = userData['userName'] ?? 'No username';
        String imageUrl = userData['imageUrl'] ?? '';

        return Column(
          children: [
            Text('Username: $userName'),
            if (imageUrl.isNotEmpty)
              Image.network(imageUrl),
          ],
        );
      },
    );
  }
}
