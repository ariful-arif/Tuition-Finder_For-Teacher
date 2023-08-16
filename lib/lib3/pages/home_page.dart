// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:diu_project1/lib3/custom_wigets/main_drawer.dart';
// import 'package:diu_project1/lib3/custom_wigets/student_scrolling.dart';
// import 'package:diu_project1/lib3/pages/log_in.dart';
// import 'package:diu_project1/lib3/pages/student_information.dart';
// import 'package:diu_project1/lib3/pages/teacher_information.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../custom_wigets/teacher_scrolling.dart';
// import '../notes/note_page.dart';
//
// class HomePage1 extends StatefulWidget {
//   static const String routeName = '/home';
//
//
//   @override
//   State<HomePage1> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage1> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      // drawer: const MainDrawer(),
//       // appBar: AppBar(
//       //   title: const Text("Tutor Finder"),
//       //   actions: [
//       //     GestureDetector(
//       //       onTap: () {
//       //         FirebaseAuth.instance.signOut();
//       //         Navigator.push(
//       //             context, MaterialPageRoute(builder: (_) => LogIn()));
//       //         //Get.off(()=>LogIn());
//       //       },
//       //       child: Padding(
//       //         padding: const EdgeInsets.only(right: 15.0),
//       //         child: Icon(Icons.logout),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//       // body: SafeArea(
//       //     child: SingleChildScrollView(
//       //   physics: BouncingScrollPhysics(),
//       //   padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Container(
//       //         decoration: BoxDecoration(
//       //             color: Colors.black12,
//       //             borderRadius: BorderRadius.only(
//       //               topLeft: Radius.circular(15),
//       //               topRight: Radius.circular(15),//color: Colors.green
//       //               bottomLeft: Radius.circular(15),
//       //             ) //color: Colors.green
//       //             ),
//       //         child: Column(
//       //           crossAxisAlignment: CrossAxisAlignment.start,
//       //           children: [
//       //             Text(
//       //               'Activity',
//       //               style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//       //                   color: Colors.black, fontWeight: FontWeight.w600),
//       //             ),
//       //             const SizedBox(height: 5),
//       //             SingleChildScrollView(
//       //               physics: BouncingScrollPhysics(),
//       //               scrollDirection: Axis.horizontal,
//       //               child: Row(
//       //                 children: [
//       //                   Container(
//       //                     height: 200,
//       //                     width: 150,
//       //                     decoration: const BoxDecoration(
//       //                         color: Colors.yellow,
//       //                         borderRadius:
//       //                             BorderRadius.all(Radius.circular(20))),
//       //                     child: Column(
//       //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //                       children: [
//       //                         Image.asset(
//       //                           'images/s1.png',
//       //                           height: 60,
//       //                           width: 60,
//       //                         ),
//       //                         Text(
//       //                           "For    Teachers",
//       //                           textAlign: TextAlign.center,
//       //                           style: Theme.of(context).textTheme.headline5,
//       //                         ),
//       //                         //ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios), label: Text("data"))
//       //                         //OutlinedButton.icon(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios), label: Text("data"))
//       //                         TextButton.icon(
//       //                             onPressed: () {
//       //                               Navigator.push(
//       //                                   context,
//       //                                   MaterialPageRoute(
//       //                                       builder: (_) =>
//       //                                           TeacherInformation()));
//       //                             },
//       //                             icon: Icon(Icons.arrow_forward_ios),
//       //                             label: Text("clcik hare"))
//       //                       ],
//       //                     ),
//       //                   ),
//       //                   const SizedBox(width: 15),
//       //                   Container(
//       //                     height: 200,
//       //                     width: 150,
//       //                     decoration: const BoxDecoration(
//       //                         color: Colors.grey,
//       //                         borderRadius:
//       //                             BorderRadius.all(Radius.circular(20))),
//       //                     child: Column(
//       //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //                       children: [
//       //                         Image.asset(
//       //                           'images/s1.png',
//       //                           height: 60,
//       //                           width: 60,
//       //                         ),
//       //                         Text(
//       //                           "For     Students",
//       //                           textAlign: TextAlign.center,
//       //                           style: Theme.of(context).textTheme.headline5,
//       //                         ),
//       //                         TextButton.icon(
//       //                             onPressed: () {
//       //                               Navigator.push(
//       //                                   context,
//       //                                   MaterialPageRoute(
//       //                                       builder: (_) =>
//       //                                           StudentInformation()));
//       //                             },
//       //                             icon: Icon(Icons.arrow_forward_ios),
//       //                             label: Text("clcik hare"))
//       //                       ],
//       //                     ),
//       //                   ),
//       //                   const SizedBox(width: 15),
//       //                   Container(
//       //                     height: 200,
//       //                     width: 150,
//       //                     decoration: const BoxDecoration(
//       //                         color: Colors.orangeAccent,
//       //                         borderRadius:
//       //                             BorderRadius.all(Radius.circular(20))),
//       //                     child: Column(
//       //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //                       children: [
//       //                         Image.asset(
//       //                           'images/s1.png',
//       //                           height: 60,
//       //                           width: 60,
//       //                         ),
//       //                         Text(
//       //                           "Notes",
//       //                           textAlign: TextAlign.center,
//       //                           style: Theme.of(context).textTheme.headline5,
//       //                         ),
//       //                         // TextButton.icon(
//       //                         //     onPressed: () {
//       //                         //       Navigator.push(
//       //                         //           context,
//       //                         //           MaterialPageRoute(
//       //                         //               builder: (_) =>
//       //                         //                   NotePage()));
//       //                         //     },
//       //                         //     icon: Icon(Icons.arrow_forward_ios),
//       //                         //     label: Text("clcik hare"))
//       //                       ],
//       //                     ),
//       //                   ),
//       //                   const SizedBox(width: 15),
//       //                   Container(
//       //                     height: 200,
//       //                     width: 150,
//       //                     decoration: const BoxDecoration(
//       //                         color: Colors.blueGrey,
//       //                         borderRadius:
//       //                             BorderRadius.all(Radius.circular(20))),
//       //                     child: Column(
//       //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //                       children: [
//       //                         Image.asset(
//       //                           'images/s1.png',
//       //                           height: 60,
//       //                           width: 60,
//       //                         ),
//       //                         Text(
//       //                           "Courses",
//       //                           textAlign: TextAlign.center,
//       //                           style: Theme.of(context).textTheme.headline5,
//       //                         ),
//       //                       ],
//       //                     ),
//       //                   ),
//       //                 ],
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //       const SizedBox(height: 10),
//       //       Container(
//       //         decoration: BoxDecoration(
//       //             color: Colors.black12,
//       //             borderRadius: BorderRadius.only(
//       //               topLeft: Radius.circular(15),
//       //               topRight: Radius.circular(15),//color: Colors.green
//       //               bottomLeft: Radius.circular(15),
//       //             ) //color: Colors.green
//       //             ),
//       //         child: Column(
//       //           crossAxisAlignment: CrossAxisAlignment.start,
//       //           children: [
//       //             Text(
//       //               'Find Your Tutor',
//       //               style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//       //                   color: Colors.black, fontWeight: FontWeight.w600),
//       //             ),
//       //             const SizedBox(height: 5),
//       //             TeacherScroll(),
//       //           ],
//       //         ),
//       //       ),
//       //       const SizedBox(height: 10),
//       //       Container(
//       //         decoration: BoxDecoration(
//       //             color: Colors.black12,
//       //             borderRadius: BorderRadius.only(
//       //               topLeft: Radius.circular(15), //color: Colors.green
//       //               topRight: Radius.circular(15), //color: Colors.green
//       //               bottomLeft: Radius.circular(15),
//       //             ) //color: Colors.green
//       //             ),
//       //         child: Column(
//       //           crossAxisAlignment: CrossAxisAlignment.start,
//       //           children: [
//       //             Text(
//       //               'Find Your Tutee',
//       //               style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//       //                   color: Colors.black, fontWeight: FontWeight.w600),
//       //             ),
//       //             const SizedBox(height: 5),
//       //             //StudentScrolling(),
//       //           ],
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // )),
//     );
//   }
// }
