import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/UserModel.dart';
import '../../pages/SearchPage.dart';
import '../const/app_color.dart';

class TeacherDetailsPage extends StatefulWidget {
  static const String routeName = '/teacherDetails';
  final UserModel userModel;
  final User firebaseUser;
  var _teacher1;
  TeacherDetailsPage(this._teacher1, {required this.userModel,required this.firebaseUser,});

  @override
  State<TeacherDetailsPage> createState() => _TeacherDetailsPageState();
}

class _TeacherDetailsPageState extends State<TeacherDetailsPage> {

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users_favourite");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._teacher1["teacher-name"],
      "email": widget._teacher1["teacher-email"],
      "images": widget._teacher1["proimg"],
    }).then((value) => Fluttertoast.showToast(msg: "Added to favourite"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.new_color,
       // centerTitle: true,
        title: Text(
          "Tutor Details",
         // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
      // Container(
      //     padding: EdgeInsets.only(top: 90),
      //     decoration: BoxDecoration(color: Colors.lightBlue
      //       // gradient: LinearGradient(colors: [
      //       //   Colors.deepPurple,
      //       //   Colors.deepOrange
      //       // ])
      //     ),
      //     //color: Colors.red,
      //     child:
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[50],
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(50),
                //   topRight: Radius.circular(50),
                // )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top:15.0,bottom: 40,left: 15,right: 15),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)
                          )),
                      //margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      //height: 200,
                      //color: Colors.black12,
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: CircleAvatar(
                              radius: 50,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(widget._teacher1['proimg'])) ,
                            ),
                          ),
                          Text(
                            widget._teacher1['teacher-name'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget._teacher1['teacher-email'],
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("users_favourite").doc(FirebaseAuth.instance.currentUser!.email)
                                .collection("items").where("email",isEqualTo: widget._teacher1['teacher-email']).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              if(snapshot.data==null){
                                return Text("");
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.lightBlue,
                                  child: IconButton(
                                    onPressed: () => snapshot.data.docs.length==0?addToFavourite()
                                        :Fluttertoast.showToast(msg: "Already Added") ,
                                    icon: snapshot.data.docs.length==0? Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white,
                                    ):Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },

                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        // color: Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(widget._teacher1['teacher-details'],
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              //mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Department : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                Container(
                                  width: 300,
                                  child: Text(widget._teacher1['teacher-department'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold,
                                        // color: Colors.black54
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Institute : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                Container(
                                  width: 300,
                                  child: Text(widget._teacher1['teacher-institute'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold,
                                        // color: Colors.black54
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.man,size: 15,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Gender : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      widget._teacher1['teacher-gender'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          // color: Colors.black54
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.date_range_sharp,
                                          color: Colors.grey,size: 15,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Age : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      widget._teacher1['teacher-age'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          // color: Colors.black54
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.date_range,size: 15,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Date of birth : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Text(
                                    widget._teacher1['teacher-dob'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold,
                                        // color: Colors.black54
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.phone,size: 15,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Phone : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      width:150,
                                      child: Text(
                                        widget._teacher1['teacher-phone'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            // fontWeight: FontWeight.bold,
                                            // color: Colors.black54
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.wrong_location_outlined,size: 15,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Prefarable area : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Container(
                                    width: 300,
                                    child: Text(
                                      widget._teacher1['teacher-address'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          // color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.menu_book,size: 15,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Preferable Subject : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50,bottom: 20),
                                  child: Container(
                                    width: 300,
                                    child: Text(
                                      widget._teacher1['teacher-subject'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          // color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.menu_book,size: 15,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Preferable Class : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50,bottom: 20),
                                  child: Container(
                                    width: 300,
                                    child: Text(
                                      widget._teacher1['teacher-class'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          // color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                // ElevatedButton(
                                //   onPressed: () {
                                //     Navigator.push(context,
                                //         MaterialPageRoute(builder: (context) {
                                //           return SearchPage(
                                //               userModel: widget.userModel,
                                //               firebaseUser: widget.firebaseUser);
                                //         }));
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //       minimumSize: Size(300, 60),
                                //       backgroundColor: AppColors.new_color,
                                //       //primary: Colors.white38,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //           BorderRadius.all(Radius.circular(20)))),
                                //   child: Text("Chat",style: TextStyle(
                                //       fontSize: 20
                                //   ),),
                                // ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

    );
  }
}
