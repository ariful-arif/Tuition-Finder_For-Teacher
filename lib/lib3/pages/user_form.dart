// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:diu_project1/lib3/pages/log_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class UserForm extends StatefulWidget {
//   static const String routeName = '/userForm';
//
//   @override
//   State<UserForm> createState() => _UserFormState();
// }
//
// class _UserFormState extends State<UserForm> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   List<String> gender = ["Male", "Female", "Others"];
//
//   Future<void> _selectDateFromPicker(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(DateTime.now().year - 20),
//       firstDate: DateTime(DateTime.now().year - 30),
//       lastDate: DateTime(DateTime.now().year),
//     );
//     if (picked != null)
//       setState(() {
//         dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
//       });
//   }
//
//   // sendUserDataToDB()async{
//   //
//   //   final FirebaseAuth _auth = FirebaseAuth.instance;
//   //   var  currentUser = _auth.currentUser;
//   //
//   //   CollectionReference _collectionRef = FirebaseFirestore.instance.collection("user-form-data");
//   //   return _collectionRef.doc(currentUser!.email).set({
//   //     "name":nameController.text,
//   //     "email":emailController.text,
//   //     "phone":phoneController.text,
//   //     "dob":dobController.text,
//   //     "gender":genderController.text,
//   //     "age":ageController.text,
//   //   }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=>LogIn()))).catchError((error)=>print("something is wrong. $error"));
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Teacher's Information"),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   hintText: "Name",
//                 ),
//               ),
//               const SizedBox(width: 15),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                 ),
//               ),
//               const SizedBox(width: 15),
//               TextField(
//                 controller: dobController,
//                 decoration: InputDecoration(
//                     hintText: "Date of Birth",
//                     suffixIcon: IconButton(
//                         onPressed: () => _selectDateFromPicker(context),
//                         icon: Icon(Icons.calendar_month_sharp))),
//               ),
//               const SizedBox(width: 15),
//               TextField(
//                 controller: phoneController,
//                 decoration: InputDecoration(
//                   hintText: "Phone number",
//                 ),
//               ),
//               const SizedBox(width: 15),
//               TextField(
//                 controller: genderController,
//                 decoration: InputDecoration(
//                   hintText: "select your gender",
//                   prefixIcon: DropdownButton<String>(
//                     items: gender.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: new Text(value),
//                         onTap: () {
//                           setState(
//                                 () {
//                               genderController.text=value;
//                             },
//                           );
//                         },
//                       );
//                     }).toList(),
//                     onChanged: (_){},
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(
//                   hintText: "Type your age",
//                 ),
//               ),
//               const SizedBox(width: 15),
//
//               CupertinoButton(
//                   child: Text("save"),
//                   onPressed: () {
//                     //saveUser();
//                     // sendUserDataToDB();
//                   }),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
