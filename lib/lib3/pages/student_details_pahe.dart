import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/UserModel.dart';
import '../../pages/SearchPage.dart';
import '../const/app_color.dart';
import 'dart:ui';

class StudentDetailsPage extends StatefulWidget {
  static const String routeName = '/studentDetails';
  final UserModel userModel;
  final User firebaseUser;
  final Timestamp date;
  var _student1;
  StudentDetailsPage(
    this._student1, {
    required this.userModel,
    required this.firebaseUser,
    required this.date,
  });

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {

  String formatDateAndTime(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('d MMMM, yyyy').format(date);
    String formattedTime = DateFormat('hh:mm a').format(date);
    return '$formattedTime $formattedDate';
  }

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
      "name": widget._student1["teacher-name"],
      "email": widget._student1["teacher-email"],
      "images": widget._student1["proimg"],
    }).then((value) => Fluttertoast.showToast(msg: "Added to favourite"));
  }

  var phone = "";
  var msg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.new_color,
          centerTitle: true,
          title: Text(
            "Student Details",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 40, left: 15, right: 15),
              child: Column(
                children: [
                  Container(
                    //margin: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    //height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.new_color),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    //color: Colors.black12,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.new_color,
                            child: CircleAvatar(
                              radius: 50,backgroundColor: AppColors.new_color,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                      widget._student1['proimg'])),
                            ),
                          ),
                        ),
                        Text(
                          widget._student1['teacher-name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget._student1['teacher-email'],
                              // widget._image1['email'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () async {
                                  String? encodeQueryParameters(
                                      Map<String, String> params) {
                                    return params.entries
                                        .map((MapEntry<String, String> e) =>
                                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                        .join('&');
                                  }

                                  final Uri emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: widget._student1['teacher-email'],
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject':
                                          'Example Subject & Symbols are allowed!',
                                    }),
                                  );
                                  if (await canLaunchUrl(emailLaunchUri)) {
                                    launchUrl(emailLaunchUri);
                                  }
                                },
                                icon: Icon(
                                  Icons.send_and_archive_outlined,
                                  color: AppColors.new_color,
                                ))
                          ],
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users_favourite")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .where("email",
                                  isEqualTo: widget._student1['teacher-email'])
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Text("");
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                backgroundColor: Colors.lightBlue,
                                child: IconButton(
                                  onPressed: () =>
                                      snapshot.data.docs.length == 0
                                          ? addToFavourite()
                                          : Fluttertoast.showToast(
                                              msg: "Already Added"),
                                  icon: snapshot.data.docs.length == 0
                                      ? Icon(
                                          Icons.favorite_outline,
                                          color: Colors.white,
                                        )
                                      : Icon(
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
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 40, left: 0, right: 0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                //shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: AppColors.new_color,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              widget._student1['teacher-details'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.end,
                            //mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: Icon(
                                        Icons.school,
                                        size: 20,
                                        color: AppColors.new_color,
                                      ),
                                      // backgroundImage: AssetImage("images/class.png"),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Class",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        Container(
                                          width: 90,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              widget._student1[
                                                  'teacher-department'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, top: 0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        size: 20,
                                        color: AppColors.new_color,
                                      ),
                                      // backgroundImage: AssetImage("images/class.png"),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        Container(
                                          width: 130,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              widget
                                                  ._student1['teacher-address'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, top: 0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: FaIcon(
                                        FontAwesomeIcons.calendarDays,
                                        color: AppColors.new_color,
                                        size: 15,
                                      ),
                                      // backgroundImage: AssetImage("images/class.png"),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Days",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        Container(
                                          width: 90,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              widget._student1['teacher-age'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, top: 0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: Icon(
                                        Icons.menu_book_sharp,
                                        size: 18,
                                        color: AppColors.new_color,
                                      ),
                                      // backgroundImage: AssetImage("images/class.png"),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Subject",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        Container(
                                          width: 148,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              widget
                                                  ._student1['teacher-subject'],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.man, size: 20,
                                        color: AppColors.new_color,
                                        //color: Colors.grey,
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
                                    widget._student1['teacher-gender'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      //fontWeight: FontWeight.bold,
                                      //color: Colors.black54
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Row(
                              //   children: [
                              //     CircleAvatar(
                              //         radius: 15,
                              //         backgroundColor: Colors.grey,
                              //         child: Icon(
                              //           Icons.calendar_today_sharp, size: 15,
                              //           color: AppColors.new_color,
                              //           // color: Colors.grey,
                              //         )),
                              //     SizedBox(
                              //       width: 8,
                              //     ),
                              //     Text(
                              //       "Age : ",
                              //       style: TextStyle(
                              //           fontSize: 15,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.black54),
                              //     ),
                              //     Text(
                              //       widget._student1['teacher-age'],
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         // fontWeight: FontWeight.bold,
                              //         // color: Colors.black54
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey,
                                      child: FaIcon(
                                        FontAwesomeIcons.calendarCheck,
                                        color: AppColors.new_color,
                                        size: 15,
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
                                  Text(
                                    widget._student1['teacher-dob'],
                                    style: TextStyle(
                                      fontSize: 14,
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
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.phone,
                                        size: 15,
                                        color: AppColors.new_color,
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
                                  Text(
                                    widget._student1['teacher-phone'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      // fontWeight: FontWeight.bold,
                                      // color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  // IconButton(
                                  //     onPressed: () async {
                                  //       final Uri call = Uri(
                                  //           scheme: 'tel',
                                  //           path: widget
                                  //               ._student1['teacher-phone']);
                                  //       if (await canLaunchUrl(call)) {
                                  //         await launchUrl(call);
                                  //       } else {
                                  //         print("cant launch url");
                                  //       }
                                  //       ;
                                  //     },
                                  //     icon: Icon(
                                  //       Icons.call,
                                  //       color: AppColors.new_color,
                                  //     )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.money,
                                        size: 15,
                                        color: AppColors.new_color,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Salary : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                  Container(
                                    width: 215,
                                    child: Text(
                                      widget._student1['teacher-taka'],
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
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.menu_book,
                                        size: 15,
                                        color: AppColors.new_color,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Subject : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                  Container(
                                    width: 215,
                                    child: Text(
                                      widget._student1['teacher-subject'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                        // color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ElevatedButton(
                              //   onPressed: () {
                              //     showDialog(
                              //         context: context,
                              //         builder: (context) {
                              //           return AlertDialog(
                              //             title: Text("Choose an option"),
                              //             content: Column(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: [
                              //                 ListTile(
                              //                   onTap: () async {
                              //                     Navigator.pop(context);
                              //                     final Uri call = Uri(
                              //                                 scheme:'sms',
                              //                                   path: widget._student1['teacher-phone']);
                              //                               if(await canLaunchUrl(call)){
                              //                                 await launchUrl(call);
                              //                               }else{
                              //                                 print("cant launch url");
                              //                               };
                              //
                              //                   },
                              //                   leading:
                              //                       Icon(Icons.sms),
                              //                   title: Text(
                              //                       "Send sms via Number"),
                              //                 ),
                              //                 ListTile(
                              //                   onTap: () {
                              //                     Navigator.pop(context);
                              //                     // Navigator.push(context,
                              //                     //     MaterialPageRoute(
                              //                     //         builder: (context) {
                              //                     //   return SearchPage(
                              //                     //     widget._student1[''],
                              //                     //       userModel:
                              //                     //           widget.userModel,
                              //                     //       firebaseUser: widget
                              //                     //           .firebaseUser);
                              //                     // }));
                              //                   },
                              //                   leading: Icon(Icons.chat),
                              //                   title: Text("Chat"),
                              //                 ),
                              //               ],
                              //             ),
                              //           );
                              //         });
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //       minimumSize: Size(300, 60),
                              //       backgroundColor: AppColors.new_color,
                              //       //primary: Colors.white38,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)))),
                              //   child: Text(
                              //     "Chat",
                              //     style: TextStyle(fontSize: 20),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            String? encodeQueryParameters(
                                                Map<String, String> params) {
                                              return params.entries
                                                  .map((MapEntry<String, String>
                                                          e) =>
                                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                  .join('&');
                                            }

                                            final Uri emailLaunchUri = Uri(
                                              scheme: 'mailto',
                                              path: widget
                                                  ._student1['teacher-email'],
                                              query: encodeQueryParameters(<
                                                  String, String>{
                                                'subject':
                                                    'Example Subject & Symbols are allowed!',
                                              }),
                                            );
                                            if (await canLaunchUrl(
                                                emailLaunchUri)) {
                                              launchUrl(emailLaunchUri);
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: AppColors.new_color,
                                              ),
                                              Text(
                                                "Email",
                                                style: TextStyle(fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri call = Uri(
                                          scheme: 'tel',
                                          path:
                                              widget._student1['teacher-phone'],
                                        );
                                        if (await canLaunchUrl(call)) {
                                          await launchUrl(call);
                                        } else {
                                          print("cant launch url");
                                        }
                                        ;
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            "call",
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          final Uri call = Uri(
                                            scheme: 'sms',
                                            path: widget
                                                ._student1['teacher-phone'],
                                          );
                                          if (await canLaunchUrl(call)) {
                                            await launchUrl(call);
                                          } else {
                                            print("cant launch url");
                                          }
                                          ;
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.sms,
                                              color: AppColors.new_color,
                                            ),
                                            Text(
                                              "SMS",
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        )),
                                    GestureDetector(
                                        onTap: () async {
                                          final Uri call = Uri(
                                            scheme: 'sms',
                                            path: widget
                                                ._student1['teacher-phone'],
                                          );
                                          if (await canLaunchUrl(call)) {
                                            await launchUrl(call);
                                          } else {
                                            print("cant launch url");
                                          }
                                          ;
                                        },
                                        child: Column(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.squareWhatsapp,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              "WhatsApp",
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 200.0,top: 10),
                                child: Container(
                                  child: Text(
                                    'Posted IN:  ${formatDateAndTime(widget.date)}',
                                    style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),

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
        ));
  }
}
