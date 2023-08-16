import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diu_project2/lib3/const/app_color.dart';
import 'package:diu_project2/lib3/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/UIHelper.dart';
import '../../models/UserModel.dart';
import '../../pages/HomePage.dart';
import '../../pages/HomePage.dart';
import '../../pages/LoginPage.dart';

class TeacherInformation extends StatefulWidget {
  //static const String routeName = '/teacherInformation';
  final UserModel userModel;
  final User firebaseUser;

  TeacherInformation({required this.userModel, required this.firebaseUser});

  @override
  State<TeacherInformation> createState() => _TeacherInformationState();
}

class _TeacherInformationState extends State<TeacherInformation> {
  File? profilepic;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController instituteController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  List<String> gender = ["Male", "Female", "Others"];

  // Future<void> _selectDateFromPicker(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime
  //         .now(),
  //     firstDate: DateTime(DateTime
  //         .now()
  //         .year - 70),
  //     lastDate: DateTime
  //         .now()
  //         ,
  //   );
  //   if (picked != null)
  //     setState(() {
  //       dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
  //     });
  // }
  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 70),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('d MMMM, y').format(picked);
        dobController.text = formattedDate;
      });
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage= await ImageCropper().cropImage(
        sourcePath: file.path,
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50
    );

    if(croppedImage!= null){
      setState(() {
        profilepic =croppedImage;
      });
    }
  }

  void checkValues() {

    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      if ( profilepic == null) {
        print("Please fill all the fields");
        UIHelper.showAlertDialog(context, "Incomplete Data",
            "Please upload a picture");
      } else {
        log("Uploading data..");
        sendUserDataToDB();
      }
    }

  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    UploadTask uploadTask= FirebaseStorage.instance.ref().child("teacher_profile")
        .child(Uuid().v1()).putFile(profilepic!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadurl= await taskSnapshot.ref.getDownloadURL();

    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("teachers");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
      "profileTea": downloadurl,
      "name": nameController.text,
      "email": emailController.text,
      "address": addressController.text,
      "phone": phoneController.text,
      "dob": dobController.text,
      "gender": genderController.text,
      "age": ageController.text,
      "details": detailsController.text,
      "department": departmentController.text,
      "institute": instituteController.text,
      "class": classController.text,
      "subject": subjectController.text,
      "time": DateTime.now(),
    })
        .then((value) =>
    Navigator.pop(context),
    )
        .catchError((error) => Fluttertoast.showToast(msg: "something is wrong. $error"));
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.new_color,
        title: Text("Job Request",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
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
      ),
      body: Form(
        key: _formKey,
        //physics: BouncingScrollPhysics(),
        child: ListView(
          children: [
            Container(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius:55,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: AppColors.new_color,
                              backgroundImage: (profilepic!= null)
                                  ? FileImage(profilepic!):null,
                              //backgroundColor: Colors.blueGrey,
                              child: (profilepic == null) ? Icon(Icons.person,size: 60,color: Colors.white,): null,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 70.0,left: 75),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                                radius: 20,
                                child: IconButton(
                                  onPressed: ()async{
                                    XFile? selectedImage= await ImagePicker().pickImage(source:
                                    ImageSource.gallery);
                                    if(selectedImage != null){
                                      cropImage(selectedImage);
                                    }
                                  },
                                  icon: Icon(Icons.camera_enhance_sharp,size: 20,color: Colors.black,),)),
                          ),
              ]
                      ),
                    ),
                    StreamBuilder<Object>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Full name:",
                                style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 15,
                                color: Colors.black45
                              ),),
                              TextField(
                                enabled: true,
                                controller: nameController = TextEditingController(
                                    text: snapshot.data['fullname']),
                                //obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIconColor: AppColors.new_color,
                                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                                  //hintText: "Email",
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
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Text("Email:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,fontSize: 15,
                                    color: Colors.black45
                                ),),
                              TextField(
                                enabled: true,
                                controller: emailController = TextEditingController(
                                    text: snapshot.data['email']),
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
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Text("Phone Number:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,fontSize: 15,
                                    color: Colors.black45
                                ),),
                              TextField(
                                enabled: true,
                                controller: phoneController = TextEditingController(
                                    text: snapshot.data['phone']),
                                //obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIconColor: AppColors.new_color,
                                  prefixIcon: Icon(Icons.phone),
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
                              ),
                            ],
                          );
                        }
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("About your self:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 15,
                          color: Colors.black45
                      ),),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      minLines: 2,
                      maxLength: 250,
                      maxLines: 7,
                      enabled: true,
                      controller: detailsController,
                      //obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.title_rounded),
                        hintText: "Write some good side about you! ",
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
                    ),
                    Text("Department:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 15,
                          color: Colors.black45
                      ),),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      enabled: true,
                      controller: departmentController,
                      //obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.class_sharp),
                        hintText: "CSE",
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
                    ),
                    SizedBox(height: 10),
                    Text("Institute:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 15,
                          color: Colors.black45
                      ),),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      enabled: true,
                      controller: instituteController,
                      //obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.school),
                        hintText: "Daffodil International University",
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
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Gender:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black45),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      readOnly: true,
                      enabled: true,
                      controller: genderController,
                      //obscureText: true,
                      decoration: InputDecoration(

                        filled: true,
                        fillColor: Colors.white,
                        hintText: "select Gender",
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
                        prefixIcon: Icon(Icons.transgender,color: AppColors.new_color,),
                        suffixIcon: DropdownButton<String>(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.arrow_drop_down_circle_outlined,color: AppColors.new_color,),
                          ),
                          items: gender.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                              onTap: () {
                                setState(
                                      () {
                                    genderController.text = value;
                                  },
                                );
                              },
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                     Text(
                      "Date of Birth:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black45),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      readOnly: true,
                      enabled: true,
                      controller: dobController,
                      //obscureText: true,
                      decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.white,
                          //prefixIconColor: Colors.grey,
                          //prefixIcon: Icon(Icons.email_outlined),
                          hintText: "select date",
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
                          suffixIconColor: AppColors.new_color,
                          suffixIcon: IconButton(
                              onPressed: () => _selectDateFromPicker(context),
                              icon: Icon(Icons.calendar_month_sharp))
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Preferable Class:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 15,
                          color: Colors.black45
                      ),),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      enabled: true,
                      controller: classController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.class_outlined),
                        hintText: "1-12 or ( one to twelve )",
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
                    ),
                    const SizedBox(height: 10),
                    Text("Preferable area:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 15,
                          color: Colors.black45
                      ),),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      enabled: true,
                      controller: addressController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.add_location_alt_rounded),
                        hintText: "Mirpur, Dhanmondi etc..",
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
                    ),
                    const SizedBox(height: 10),
                    Text("Preferable Subjects:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 15,
                          color: Colors.black45
                      ),),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      enabled: true,
                      controller: subjectController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIconColor: AppColors.new_color,
                        prefixIcon: Icon(Icons.book_online),
                        hintText: "Bangla, English, Math etc.",
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
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        checkValues();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(500, 50),
                          primary: AppColors.new_color,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//   void saveUser() {
//     String name = nameController.text.trim();
//     String address = addressController.text.trim();
//     String phone = phoneController.text.trim();
//     String dob = dobController.text.trim();
//     String gender = genderController.text.trim();
//     String age = ageController.text.trim();
//     String details = detailsController.text.trim();
//     String department = departmentController.text.trim();
//     String institute = instituteController.text.trim();
//     String subject = subjectController.text.trim();
//
//     nameController.clear();
//     addressController.clear();
//     phoneController.clear();
//     dobController.clear();
//     genderController.clear();
//     ageController.clear();
//
//     if (name != "" &&
//         address != "" &&
//         phone != "" &&
//         dob != "" &&
//         gender != "" &&
//         age != "") {
//       Map<String, dynamic> userData = {
//         "name": name,
//         "address": address,
//         "phone": phone,
//         "dob": dob,
//         "gender": gender,
//         "age": age,
//         "details": details,
//         "department": department,
//         "institute": institute,
//         "subject": subject,
//       };
//       FirebaseFirestore.instance.collection("teachers").add(userData);
//       log("User created");
//     } else {
//       log("Please fill all the details");
//     }
//   }
// }
// StreamBuilder<QuerySnapshot>(
//   stream: FirebaseFirestore.instance
//       .collection("users")
//       .snapshots(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.active) {
//       if (snapshot.hasData && snapshot.data != null) {
//         return Expanded(
//           child: ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               Map<String, dynamic> userMap =
//               snapshot.data!.docs[index].data()
//               as Map<String, dynamic>;
//
//               return ListTile(
//                 title: Text(userMap["name"]),
//                 subtitle: Text(userMap["address"]),
//               );
//             },
//           ),
//         );
//       }else{
//         return Text(" no data");
//       }
//     } else {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//   },
// ),
