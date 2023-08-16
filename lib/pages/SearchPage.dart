import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:diu_project2/main.dart';
import 'package:diu_project2/models/ChatRoomModel.dart';
import 'package:diu_project2/models/UserModel.dart';
import 'package:diu_project2/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../lib3/const/app_color.dart';
import 'LoginPage.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  var _student1;
  // final DocumentSnapshot documentSnapshot;
  SearchPage(
    this._student1, {
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.new_color,
        title: Text("Search Page",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
        actions: [
          PopupMenuButton<int>(
            // color: Colors.black,
              onSelected: (item) => onSelected(context, item),
              // color: Colors.black,
              itemBuilder: (context) =>
              [
                // PopupMenuItem(value: 0,
                //   child: Text("Search",)),
                PopupMenuItem(value: 1,
                    child: Text("Log Out",)),

              ]),

        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue[50],
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: ListView(
            children: [
              // TextField(
              //   controller: searchController,
              //   decoration: InputDecoration(labelText: "Email Address"),
              // ),
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: AppColors.new_color),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      "Please click the",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " 'Click Here' ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.deepOrange),
                    ),
                    Text(
                      "button",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        FlickerAnimatedText(
                          "v",
                          //icon.new_icon.toString(),
                          textStyle: TextStyle(
                            color: Colors.deepOrangeAccent,

                            fontSize: 20,
                            //fontWeight: FontWeight.bold
                          ),
                          speed: Duration(milliseconds: 300),
                          //colors: [Colors.red,Colors.blue,Colors.purple],
                        ),
                      ],
                      repeatForever: true,
                    ),
                  ],
                ),
                //color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return TextField(
                      enabled: true,
                      controller: searchController = TextEditingController(
                          text: widget._student1['teacher-email']
                          // snapshot.data['email']
                          ),
                      //obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: AppColors.new_color,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.new_color),
                        ),
                      ),
                    );

                    //   TextField(
                    //   controller: searchController =
                    //       TextEditingController(text: snapshot.data['email']),
                    //   decoration: InputDecoration(
                    //       hintText: "Email", border: OutlineInputBorder()),
                    // );
                  }),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      // color: AppColors.new_color,
                      child:  AnimatedTextKit(
                        animatedTexts: [
                          FlickerAnimatedText(
                            "-->",
                            //icon.new_icon.toString(),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent,

                              fontSize: 25,
                              //fontWeight: FontWeight.bold
                            ),
                            speed: Duration(milliseconds: 1000),
                            //colors: [Colors.red,Colors.blue,Colors.purple],
                          ),
                        ],
                        repeatForever: true,
                      ),
                  ),

                  CupertinoButton(
                    onPressed: () {
                      setState(() {});
                    },
                    color: AppColors.new_color,
                    child: Text("Click Here",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.deepOrangeAccent,

                      fontSize: 20,
                      //fontWeight: FontWeight.bold
                    ),)
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: searchController.text)
                      .where("email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        if (dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return Column(
                            children: [
                              // Card(
                              //   child: ListTile(
                              //     onTap: () async {
                              //       ChatRoomModel? chatroomModel =
                              //           await getChatroomModel(searchedUser);
                              //
                              //       if (chatroomModel != null) {
                              //         Navigator.pop(context);
                              //         Navigator.push(context,
                              //             MaterialPageRoute(builder: (context) {
                              //           return ChatRoomPage(
                              //             targetUser: searchedUser,
                              //             userModel: widget.userModel,
                              //             firebaseUser: widget.firebaseUser,
                              //             chatroom: chatroomModel,
                              //           );
                              //         }));
                              //       }
                              //     },
                              //     leading: CircleAvatar(
                              //       backgroundImage:
                              //           NetworkImage(searchedUser.profilepic!),
                              //       backgroundColor: Colors.grey[500],
                              //     ),
                              //     title: Text(searchedUser.fullname!),
                              //     subtitle: Text(searchedUser.email!),
                              //     // trailing:AnimatedTextKit(animatedTexts: [
                              //     //   FlickerAnimatedText(
                              //     //
                              //     //     "Click Here" ,
                              //     //     textStyle: TextStyle(
                              //     //       color: Colors.redAccent,
                              //     //
                              //     //         fontSize: 20,
                              //     //         fontWeight: FontWeight.bold),
                              //     //     speed: Duration(milliseconds: 500),
                              //     //     //colors: [Colors.red,Colors.blue,Colors.purple],
                              //     //   ),
                              //     // ],
                              //     // //repeatForever: true,
                              //     // ),
                              //
                              //     //trailing: Icon(Icons.arrow_forward),
                              //   ),
                              // ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        ChatRoomModel? chatroomModel =
                                            await getChatroomModel(
                                                searchedUser);

                                        if (chatroomModel != null) {
                                          Navigator.pop(context);
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ChatRoomPage(
                                              targetUser: searchedUser,
                                              userModel: widget.userModel,
                                              firebaseUser: widget.firebaseUser,
                                              chatroom: chatroomModel,
                                            );
                                          }));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.new_color),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),

                                        height: 150,
                                        //color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            searchedUser
                                                                .profilepic!),
                                                    backgroundColor:
                                                        Colors.grey[500],
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,

                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        child: Text(
                                                          searchedUser
                                                              .fullname!,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(searchedUser.email!),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            AnimatedTextKit(
                                              animatedTexts: [
                                                FlickerAnimatedText(
                                                  "Click Here",
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  speed: Duration(
                                                      milliseconds: 700),
                                                  //colors: [Colors.red,Colors.blue,Colors.purple],
                                                ),
                                                TyperAnimatedText(
                                                  "Click here to Chat",
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  speed: Duration(
                                                      milliseconds: 150),
                                                  //colors: [Colors.red,Colors.blue,Colors.purple],
                                                ),
                                              ],
                                              repeatForever: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        } else {
                          return Text("No results found!",textAlign: TextAlign.center,);
                        }
                      } else if (snapshot.hasError) {
                        return Text("An error occured!",textAlign: TextAlign.center,);
                      } else {
                        return Text("No results found!",textAlign: TextAlign.center,);
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
