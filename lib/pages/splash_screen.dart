import 'dart:developer';
import 'dart:js';

import 'package:diu_project2/lib3/const/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  SplashScreen(
      {required this.userModel, required this.firebaseUser});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// @override
// void initState() {
//   Future.delayed(Duration(seconds: 4), () {
//     if (FirebaseAuth.instance.currentUser == null) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//     } else {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (_) =>
//                   HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser
//
//                   )));
//     }
//   });
//   super.initState();
// }



class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.new_color,
      ),
    );
  }
}