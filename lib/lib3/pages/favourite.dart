import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/UserModel.dart';
import '../../pages/LoginPage.dart';
import '../const/app_color.dart';
import '../custom_wigets/fetchdata.dart';

class Favourite extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  Favourite({
    required this.userModel,
    required this.firebaseUser,
  });
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {

  void onSelected(BuildContext context, item) {
    switch (item) {
      case 1:
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.TOPSLIDE,
          showCloseIcon: true,
          btnOkText: 'Yes',
          btnCancelText: 'No',
          title: "Warning",
          desc: "Do You want to LogOut?",
          btnCancelOnPress: () {
            //Navigator.pop(context);
          },
          btnOkOnPress: () {
            //Navigator.pop(context);
            FirebaseAuth.instance.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LoginPage(
                      // userModel: userModel, firebaseUser: firebaseUser,
                    )));
          },
        ).show();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Favourite List",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          actions: [
            PopupMenuButton<int>(
              // color: Colors.black,
                onSelected: (item) => onSelected(context, item),
                //color: Colors.black,
                itemBuilder: (context) =>
                [
                  // PopupMenuItem(value: 0,
                  //   child: Text("Search",)),
                  PopupMenuItem(value: 1,
                      child: Text("Log Out",)),

                ]),

          ],

          //backgroundColor: Colors.transparent,
          backgroundColor: AppColors.new_color,
          elevation: 0,
        ),
        // body: Container(
        //     padding: EdgeInsets.only(top: 90),
        //     decoration: BoxDecoration(color: Colors.lightBlue
        //         // gradient: LinearGradient(colors: [
        //         //   Colors.deepPurple,
        //         //   Colors.deepOrange
        //         // ])
        //         ),
        //     //color: Colors.red,
        //     child:
         body: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(50),
                  //   topRight: Radius.circular(50),
                  // )
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: fetchData("users_favourite"),
              ),
            )
    );
  }
}
