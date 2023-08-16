import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diu_project2/lib3/pages/student_details_pahe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../const/app_color.dart';
import '../profile/edit_profile.dart';

class MyPost extends StatefulWidget {


  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {

  setData(data) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding:
        const EdgeInsets.only(top: 15.0, bottom: 40, left: 5, right: 5),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 20,
              child: Container(
                //height: 200,
                //width: 375,
                decoration: const BoxDecoration(
                    color: Color(0xff73c5e0),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      //color: Colors.white,
                      decoration: const BoxDecoration(
                          color: Color(0xff73c5e0),
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        data["title"],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 3.0, top: 0),
                          child: CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.school,size: 12,),
                            // backgroundImage: AssetImage("images/class.png"),
                            backgroundColor: Colors.white54,
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
                                width: 100,
                                child: Text(
                                  data["class"],
                                  style: TextStyle(fontSize: 15),
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
                            radius: 15,
                            child: Icon(Icons.location_on_outlined),
                            // backgroundImage: AssetImage("images/class.png"),
                            backgroundColor: Colors.white54,
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
                                width: 150,
                                child: Text(
                                  data["address"],
                                  style: TextStyle(fontSize: 15),
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
                            child: Icon(Icons.calendar_month_sharp,size: 12,),
                            // backgroundImage: AssetImage("images/class.png"),
                            backgroundColor: Colors.white54,
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
                              Text(
                                data["days"],
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 3.0, top: 0),
                          child: CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.menu_book_sharp,size: 12,),
                            // backgroundImage: AssetImage("images/class.png"),
                            backgroundColor: Colors.white54,
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
                                width: 150,
                                child: Text(
                                  data["subject"],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 3.0, top: 0),
                          child: CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.language,size: 12,),
                            // backgroundImage: AssetImage("images/class.png"),
                            backgroundColor: Colors.white54,
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
                                width: 120,
                                child: Text(
                               data["curriculum"],
                                  style: TextStyle(fontSize: 15),
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
                            child: Icon(Icons.money,size: 12,),
                            // backgroundImage: AssetImage("images/class.png"),
                            backgroundColor: Colors.white54,
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
                                width: 100,
                                child: Text(
                                  data["salary"],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => StudentDetailsPage(
                            //
                            //
                            //         )));
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              minimumSize: Size(150, 50),
                              primary: Colors.white38,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                          child: Text("Comment",style: TextStyle(
                              fontSize: 15
                          ),),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => StudentDetailsPage(
                            //           _teacher[index],
                            //           userModel: widget.userModel,
                            //           firebaseUser: widget.firebaseUser,
                            //         )));
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              minimumSize: Size(150, 50),
                              primary: Colors.white38,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                          child: Text("Details",style: TextStyle(
                              fontSize: 15
                          ),),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextField(
                    //   controller: text =
                    //       TextEditingController(text: _teacher[index]['teacher-subject']),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.new_color,
          centerTitle: true,
          title: Text(
            "My Request",
            //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
        //color: Colors.red,
        // child:
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
          child: SafeArea(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("students")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    var data = snapshot.data;

                    if (data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return setData(data);
                  })),
        )

    );
  }
}
