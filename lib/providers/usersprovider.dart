import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier{
  String _userName='';
  String  _imageUrl='';

  String get username=>_userName;
  String get imageurl=>_imageUrl;


    getUserInfo(String userName,String imageUrl){
    _userName=userName;
    _imageUrl=imageUrl;
    notifyListeners();
  }
}