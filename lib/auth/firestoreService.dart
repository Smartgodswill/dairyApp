import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getUserNotes(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Notes')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching user notes: $e');
      return [];
    }
  }
}
