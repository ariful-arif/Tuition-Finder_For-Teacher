import 'package:diu_project2/lib3/const/app_color.dart';
import 'package:diu_project2/pages/LoginPage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/UserModel.dart';
import '../../pages/HomePage.dart';
import '../../pages/HomePage.dart';

class EntryPage extends StatefulWidget {
  // final UserModel userModel;
  // final User firebaseUser;
  // EntryPage({
  //   required this.userModel,
  //   required this.firebaseUser,
  // });

  @override
  State<EntryPage> createState() => _EntryPageState();
}


class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.new_color,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("images/back1.png"), fit: BoxFit.cover),
        // ),
        // child: Center(
        //   child: Column(
        //     //crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         // child: Column(
        //         //   children: [
        //         //     Card(
        //         //       elevation: 20,
        //         //       shape: RoundedRectangleBorder(
        //         //           borderRadius: BorderRadius.all(Radius.circular(60))),
        //         //       child: ElevatedButton(
        //         //           onPressed: () {
        //         //             // Navigator.popUntil(
        //         //             //     context, (route) => route.isFirst);
        //         //             Navigator.pushReplacement(
        //         //               context,
        //         //               MaterialPageRoute(builder: (context) {
        //         //                 return LoginPage();
        //         //                     // userModel: widget.userModel,
        //         //                     // firebaseUser: widget.firebaseUser);
        //         //               }),
        //         //             );
        //         //           },
        //         //           style: ElevatedButton.styleFrom(
        //         //               minimumSize: Size(300, 60),
        //         //               primary: Colors.white,
        //         //               shape: RoundedRectangleBorder(
        //         //                   borderRadius:
        //         //                       BorderRadius.all(Radius.circular(60)))),
        //         //           child: Text(
        //         //             "Teacher",
        //         //             style: TextStyle(
        //         //               fontSize: 28,
        //         //               color: Colors.black
        //         //             ),
        //         //           )),
        //         //     ),
        //         //     SizedBox(
        //         //       height: 30,
        //         //     ),
        //         //     Card(
        //         //       elevation: 20,
        //         //       shape: RoundedRectangleBorder(
        //         //           borderRadius: BorderRadius.all(Radius.circular(60))),
        //         //       child: ElevatedButton(
        //         //           onPressed: () {
        //         //             Navigator.popUntil(
        //         //                 context, (route) => route.isFirst);
        //         //             Navigator.pushReplacement(
        //         //               context,
        //         //               MaterialPageRoute(builder: (context) {
        //         //                 return LoginPage(
        //         //                     // userModel: widget.userModel,
        //         //                     // firebaseUser: widget.firebaseUser
        //         //                 );
        //         //               }),
        //         //             );
        //         //           },
        //         //           style: ElevatedButton.styleFrom(
        //         //               minimumSize: Size(300, 60),
        //         //               primary: Colors.white,
        //         //               shape: RoundedRectangleBorder(
        //         //                   borderRadius:
        //         //                       BorderRadius.all(Radius.circular(60)))),
        //         //           child: Text(
        //         //             "Student",
        //         //             style: TextStyle(
        //         //               fontSize: 28,
        //         //               color: Colors.black
        //         //             ),
        //         //           )),
        //         //     ),
        //         //   ],
        //         // ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
