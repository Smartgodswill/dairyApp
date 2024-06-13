import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String password;
  final String confirmpassword;
  final String? userName;
  final String pofile;
  final String? email;
  final bool isverified;

  Users(
    this.isverified, {
    required this.confirmpassword,
    required this.pofile,
    required this.uid,
    required this.email,
    required this.password,
    required this.userName,
  });

 

  Map<String, dynamic> tojson() => {
        "userName": userName,
        "email": email,
        "uid": uid,
        "confirmpassord": confirmpassword,
        "password": password,
        "profilephoto": pofile
      };
}

Users userFromJson(DocumentSnapshot snap) {
  var snapshot = snap.data() as Map<String, dynamic>;
  return Users(false,
      pofile: snapshot["profile"],
      confirmpassword: snapshot['confirmpassword'],
      uid: snapshot['uid'],
      email: snapshot["email"],
      password: snapshot['password'],
      userName: snapshot["userName"]);
}
