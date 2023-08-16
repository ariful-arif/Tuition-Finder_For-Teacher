import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diu_project2/lib3/const/app_color.dart';
import 'package:diu_project2/pages/SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

import '../../models/UserModel.dart';
import '../pages/student_details_pahe.dart';

class StudentScrolling extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  StudentScrolling({required this.userModel, required this.firebaseUser});

  @override
  State<StudentScrolling> createState() => _StudentScrollingState();
}

class _StudentScrollingState extends State<StudentScrolling> {
  TextEditingController text = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;

  List _teacher = [];
  fetchTeacher() async {
    var fireStoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await fireStoreInstance.collection("students").orderBy("date",descending: true).get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _teacher.add({
          "teacher-name": qn.docs[i]["name"],
          "teacher-email": qn.docs[i]["email"],
          "teacher-address": qn.docs[i]["address"],
          "teacher-phone": qn.docs[i]["phone"],
          "teacher-gender": qn.docs[i]["gender"],
          "teacher-dob": qn.docs[i]["dob"],
          "teacher-age": qn.docs[i]["days"],
          "teacher-details": qn.docs[i]["title"],
          "teacher-department": qn.docs[i]["class"],
          "teacher-institute": qn.docs[i]["curriculum"],
          "teacher-taka": qn.docs[i]["salary"],
          "teacher-subject": qn.docs[i]["subject"],
          "date": qn.docs[i]["date"],
          //"date": DateTime.now().toString(),
          "proimg": qn.docs[i]['profileStu'],
        });
      }
    });
  }
  // List _image = [];
  // var fireStoreInstance = FirebaseFirestore.instance;
  // fetchImage() async {
  //   QuerySnapshot qn = await fireStoreInstance.collection("users").get();
  //   setState(() {
  //     for (int i = 0; i < qn.docs.length; i++) {
  //       _image.add({
  //         "proimg": qn.docs[i]['profilepic'],
  //       });
  //     }
  //   });
  //   return qn.docs;
  // }

  String getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();

    final difference = now.difference(date);

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Format the date in 'd MMMM, yyyy' format
      final formattedDate = DateFormat('d MMMM, yyyy').format(date);
      return formattedDate;
    }
  }


  // String getTimeAgo(Timestamp timestamp) {
  //   final now = DateTime.now();
  //   final date = timestamp.toDate();
  //
  //   final difference = now.difference(date);
  //
  //   if (difference.inSeconds < 5) {
  //     return 'Just now';
  //   } else if (difference.inSeconds < 60) {
  //     return '${difference.inSeconds} seconds ago';
  //   } else if (difference.inMinutes < 60) {
  //     return '${difference.inMinutes} minutes ago';
  //   } else if (difference.inHours < 24) {
  //     return '${difference.inHours} hours ago';
  //   } else if (difference.inDays < 7) {
  //     return '${difference.inDays} days ago';
  //   } else {
  //     // Format the date in 'dd-MM-yyyy hh:mm a' format
  //     return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ';
  //         // '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  //   }
  // }


  @override
  void initState() {
    fetchTeacher();
    //fetchImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
    // return Scaffold(
    //  // extendBodyBehindAppBar: true,
    //   // appBar: AppBar(
    //   //   centerTitle: true,
    //   //   title: Text(
    //   //     "Student's",
    //   //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    //   //   ),
    //   //   backgroundColor: Colors.transparent,
    //   //   elevation: 0,
    //   // ),
    //   body: //Container(
        // padding: EdgeInsets.only(top: 120),
        // decoration: BoxDecoration(color: Colors.lightBlue
        //     // gradient: LinearGradient(colors: [
        //     //   Colors.deepPurple,
        //     //   Colors.deepOrange
        //     // ])
        //     ),
        //color: Colors.red,
       // child:
        //Container(
          // decoration: BoxDecoration(
          //     color: Colors.blue[50],
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(50),
          //       topRight: Radius.circular(50),
              //)),
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          //color: Colors.black,
         // child:
        ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: _teacher.length,
            itemBuilder: (_, index) {

              Timestamp timestamp = _teacher[index]["date"] as Timestamp;
              String formattedTime = getTimeAgo(timestamp); // Format the timestamp using custom method

              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => StudentDetailsPage(_teacher[index],
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                              date: timestamp,
                            )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 20,
                    child: Container(
                      //height: 200,
                      //width: 375,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(width: 1,color: AppColors.new_color) ,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            //color: Colors.white,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              _teacher[index]["teacher-details"],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.new_color),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 3.0, top: 0),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.school,size: 15,color: AppColors.new_color,),
                                  // backgroundImage: AssetImage("images/class.png"),
                                  backgroundColor: Colors.blue[50],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _teacher[index]["teacher-department"],
                                          style: TextStyle(fontSize: 13),
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
                                padding:
                                    const EdgeInsets.only(left: 3.0, top: 0),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.location_on_outlined,size: 18,),
                                  // backgroundImage: AssetImage("images/class.png"),
                                  backgroundColor: Colors.blue[50],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Location",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      width: 170,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _teacher[index]["teacher-address"],
                                          style: TextStyle(fontSize: 13),
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
                                padding:
                                    const EdgeInsets.only(left: 3.0, top: 0),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.calendar_month_sharp,size: 12,color: AppColors.new_color,),
                                  // backgroundImage: AssetImage("images/class.png"),
                                  backgroundColor: Colors.blue[50],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _teacher[index]["teacher-age"],
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 3.0, top: 0),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.menu_book_sharp,size: 12,color: AppColors.new_color,),
                                  // backgroundImage: AssetImage("images/class.png"),
                                  backgroundColor: Colors.blue[50],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Subject",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      width: 180,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _teacher[index]["teacher-subject"],
                                          style: TextStyle(fontSize: 13),
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
                                padding:
                                const EdgeInsets.only(left: 3.0, top: 0),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.money,size: 12,color: AppColors.new_color,),
                                  // backgroundImage: AssetImage("images/class.png"),
                                  backgroundColor: Colors.blue[50],
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Salary",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      width: 90,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _teacher[index]["teacher-taka"],
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 3.0, top: 0),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.language,size: 12,color: AppColors.new_color,),
                                  // backgroundImage: AssetImage("images/class.png"),
                                  backgroundColor: Colors.blue[50],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Curriculum",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      width: 180,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _teacher[index]["teacher-institute"],
                                          style: TextStyle(fontSize: 13),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SearchPage(
                                            _teacher[index],
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser,
                                          )));
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                    minimumSize: Size(140, 45),
                                    primary: AppColors.new_color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                                child: Text("Chat",style: TextStyle(
                                    fontSize: 15,color: Colors.white,
                                ),),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => StudentDetailsPage(
                                            _teacher[index],
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser,
                                            date: timestamp,
                                          )));
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                    minimumSize: Size(140, 45),
                                     primary: AppColors.new_color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                                child: Text("Details",style: TextStyle(
                                  fontSize: 15,color: Colors.white,
                                ),),
                              )
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10.0,left: 230,bottom: 10),
                            child: Container(
                              child: Text(
                                formattedTime, // Display the time in "time ago" format
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),


                           // Text(DateFormat('dd/MM/yyyy').format())
                          // TextField(
                          //   controller: text =
                          //       TextEditingController(text: _teacher[index]['teacher-subject']),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
       // ),
     // );
    //);
  }
}
