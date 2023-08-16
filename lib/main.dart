import 'dart:io';

import 'package:diu_project2/lib3/custom_wigets/bottom_navigation_controller.dart';
import 'package:diu_project2/lib3/pages/entry_page.dart';
import 'package:diu_project2/lib3/pages/log_in.dart';
import 'package:diu_project2/pages/CompleteProfile.dart';
import 'package:diu_project2/pages/HomePage.dart';
import 'package:diu_project2/pages/HomePage.dart';
import 'package:diu_project2/pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';

import 'lib3/const/app_color.dart';
import 'models/FirebaseHelper.dart';
import 'models/UserModel.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   User? user;
//
//   @override
//   void initState() {
//
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tuition Finder',
//       theme: ThemeData(
//       ),
//        home: user != null ? const BottomNavigationController() : LogIn(),
//
//     );
//   }
// }

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // Logged In
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(MyApp());
    }
  } else {
    // Not logged in
    runApp(MyApp());
  }
}

// Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// Already Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TuitionFinderT',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30))),
        // Color(0xff73c5e0),
        //focusColor: Colors.red
        //focusColor: Colors.red
        //colorSchemeSeed: Colors.lightGreen
      ),
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
      // HomePaget(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}


