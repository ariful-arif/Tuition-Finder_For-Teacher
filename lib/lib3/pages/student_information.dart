import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../models/UIHelper.dart';
import '../../models/UserModel.dart';
import '../../pages/HomePage.dart';
import '../const/app_color.dart';
import '../custom_wigets/student_scrolling.dart';

class StudentInformation extends StatefulWidget {
  static const String routeName = '/studentInformation';
  final UserModel userModel;
  final User firebaseUser;

  StudentInformation({required this.userModel, required this.firebaseUser});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  File? profilepic;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController curriculumController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  List<String> gender = ["Male", "Female", "All"];
  List<String> curriculum = ["Banglai-Medium", "English-Medium", "Others"];
  List<String> day = [
    "1 day",
    "2 days",
    "3 days",
    "4 days",
    "5 days",
    "6 days",
    "7 days"
  ];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
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

  sendUserDataToDB() async {

    UIHelper.showLoadingDialog(context, "Uploading image..,Uploading Data");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    UploadTask uploadTask= FirebaseStorage.instance.ref().child("student_profile")
        .child(Uuid().v1()).putFile(profilepic!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadurl= await taskSnapshot.ref.getDownloadURL();

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("students");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "profileStu": downloadurl,
          "title": titleController.text,
          "name": nameController.text,
          "address": addressController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "dob": dobController.text,
          "gender": genderController.text,
          "days": daysController.text,
          "class": classController.text,
          "curriculum": curriculumController.text,
          "subject": subjectController.text,
          "salary": salaryController.text,
          "date": DateTime.now(),
        })
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StudentScrolling(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser))))
        .catchError((error) => print("something is wrong. $error"));
  }

  void checkValues() {
    String salary = salaryController.text.trim();
    String address = addressController.text.trim();
    String phone = phoneController.text.trim();

    if (salary == "" ||address == "" ||phone == "" || profilepic == null) {
      print("Please fill all the fields");
      UIHelper.showAlertDialog(context, "Incomplete Data",
          "Please fill all the fields and upload a profile picture");
    } else {
      log("Uploading data..");
      sendUserDataToDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.new_color,
        title: Text("Tutor Request",
          // style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 25),
        ),
       // backgroundColor: Colors.transparent,
        elevation: 0,
        //centerTitle: true,
      ),
      // body: Container(
      //     padding: EdgeInsets.only(top: 90),
      //     decoration: BoxDecoration(color: Colors.lightBlue
      //       // gradient: LinearGradient(colors: [
      //       //   Colors.deepPurple,
      //       //   Colors.deepOrange
      //       // ])
      //     ),
      //     //color: Colors.red,
      //     child:
        body:  Container(
            decoration: BoxDecoration(
                color: Colors.blue[50],
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(50),
                //   topRight: Radius.circular(50),
                // )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25,top: 15,right: 25,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 100.0),
                        child: CupertinoButton(
                          onPressed: ()async{
                            XFile? selectedImage= await ImagePicker().pickImage(source:
                            ImageSource.gallery);
                            if(selectedImage != null){
                              cropImage(selectedImage);
                            }
                          },
                          // padding: EdgeInsets.zero,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: (profilepic!= null)
                                ? FileImage(profilepic!):null,
                            //backgroundColor: Colors.blueGrey,
                            child: (profilepic == null) ? Icon(Icons.person,size: 60,): null,
                          ),
                        ),
                      ),
                      Text(
                        "Title:",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.black45),
                      ),
                      TextField(
                        minLines: 2,
                        maxLength: 250,
                        maxLines: 7,
                        enabled: true,
                        controller: titleController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: AppColors.new_color,
                          prefixIcon: Icon(Icons.title_rounded),
                          hintText: "Need a Tutor from DIU or DU etc...",
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
                      // TextField(
                      //   minLines: 2,
                      //   maxLength: 250,
                      //   maxLines: 5,
                      //   controller: titleController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       hintText: "Need a Tutor from DIU or DU etc...",
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.transparent))),
                      // ),
                      SizedBox(height: 5),
                      StreamBuilder<Object>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black45),
                                ),
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
                                // TextField(
                                //   controller: nameController = TextEditingController(
                                //       text: snapshot.data['fullname']),
                                //   decoration: InputDecoration(
                                //       filled: true,
                                //       fillColor: Colors.blue[50],
                                //       hintText: "Name",
                                //       border: OutlineInputBorder()),
                                // ),
                                SizedBox(height: 15),
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black45),
                                ),
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
                                // TextField(
                                //   readOnly: true,
                                //   controller: emailController = TextEditingController(
                                //       text: snapshot.data['email']),
                                //   decoration: InputDecoration(
                                //       filled: true,
                                //       fillColor: Colors.blue[50],
                                //       hintText: "Email",
                                //       border: OutlineInputBorder()),
                                // ),
                              ],
                            );
                          }),
                      const SizedBox(height: 15),
                      Text(
                        "Subjects:",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.black45),
                      ),
                      TextField(
                        enabled: true,
                        controller: subjectController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: AppColors.new_color,
                          prefixIcon: Icon(Icons.book),
                          hintText: "Bangla, English, Math etc..",
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
                      // TextField(
                      //   controller: subjectController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       hintText: "Bangla, English, Math etc..",
                      //       border: OutlineInputBorder()),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        enabled: true,
                        controller: classController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          icon: Text(
                            "Class:",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Colors.black45),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //prefixIconColor: AppColors.new_color,
                          //prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Eight, Nine..",
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
                      // TextField(
                      //   controller: classController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       icon: Text(
                      //         "Class:",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w800,
                      //             fontSize: 20,
                      //             color: Colors.black45),
                      //       ),
                      //       hintText: "Eight",
                      //       border: OutlineInputBorder()),
                      // ),
                      SizedBox(height: 15),
                      TextField(
                        readOnly: true,
                        enabled: true,
                        controller: curriculumController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          icon: Text(
                            "Curriculum:",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Colors.black45),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: Colors.grey,
                          //prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Select Medium",
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
                          suffixIcon: DropdownButton<String>(
                            items: curriculum.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                                onTap: () {
                                  setState(
                                        () {
                                      curriculumController.text = value;
                                    },
                                  );
                                },
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                      // TextField(
                      //   readOnly: true,
                      //   controller: curriculumController,
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.blue[50],
                      //     icon: Text(
                      //       "Curriculum:",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 20,
                      //           color: Colors.black45),
                      //     ),
                      //     hintText: "Select Medium",
                      //     border: OutlineInputBorder(),
                      //     //iconColor: Colors.red,
                      //
                      //     suffixIcon: DropdownButton<String>(
                      //       items: curriculum.map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: new Text(value),
                      //           onTap: () {
                      //             setState(
                      //                   () {
                      //                 curriculumController.text = value;
                      //               },
                      //             );
                      //           },
                      //         );
                      //       }).toList(),
                      //       onChanged: (_) {},
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      TextField(
                        readOnly: true,
                        enabled: true,
                        controller: genderController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          icon: Text(
                            "Tutor Gender:",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Colors.black45),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "select",
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
                          suffixIcon: DropdownButton<String>(
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
                      // TextField(
                      //   readOnly: true,
                      //   controller: genderController,
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.blue[50],
                      //     icon: Text(
                      //       "Tutor Gender:",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 20,
                      //           color: Colors.black45),
                      //     ),
                      //     //hintText: "Tutor Gender",
                      //     border: OutlineInputBorder(),
                      //     suffixIcon: DropdownButton<String>(
                      //       items: gender.map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: new Text(value),
                      //           onTap: () {
                      //             setState(
                      //                   () {
                      //                 genderController.text = value;
                      //               },
                      //             );
                      //           },
                      //         );
                      //       }).toList(),
                      //       onChanged: (_) {},
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      TextField(
                        readOnly: true,
                        enabled: true,
                        controller: daysController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          icon: Text(
                            "Days/Week:",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Colors.black45),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //prefixIconColor: Colors.grey,
                          //prefixIcon: Icon(Icons.email_outlined),
                          hintText: "select one",
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
                          suffixIcon: DropdownButton<String>(
                            items: day.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                                onTap: () {
                                  setState(
                                        () {
                                      daysController.text = value;
                                    },
                                  );
                                },
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                      // TextField(
                      //   readOnly: true,
                      //   controller: daysController,
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.blue[50],
                      //     icon: Text(
                      //       "Days/Week:",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 18,
                      //           color: Colors.black45),
                      //     ),
                      //     //hintText: "Tutor Gender",
                      //     border: OutlineInputBorder(),
                      //     suffixIcon: DropdownButton<String>(
                      //       items: day.map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: new Text(value),
                      //           onTap: () {
                      //             setState(
                      //                   () {
                      //                 daysController.text = value;
                      //               },
                      //             );
                      //           },
                      //         );
                      //       }).toList(),
                      //       onChanged: (_) {},
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      TextField(
                        readOnly: true,
                        enabled: true,
                        controller: dobController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          icon: Text(
                            "Date of Birth:",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.black45),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //prefixIconColor: Colors.grey,
                          //prefixIcon: Icon(Icons.email_outlined),
                          hintText: "select one",
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
                      // TextField(
                      //   readOnly: true,
                      //   controller: dobController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       icon: Text(
                      //         "Date of Birth:",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w800,
                      //             fontSize: 16,
                      //             color: Colors.black45),
                      //       ),
                      //       hintText: "Date of Birth",
                      //       border: OutlineInputBorder(),
                      //       suffixIcon: IconButton(
                      //           onPressed: () => _selectDateFromPicker(context),
                      //           icon: Icon(Icons.calendar_month_sharp))
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      Text(
                        "Phone number:",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.black45),
                      ),
                      TextField(
                        enabled: true,
                        controller: phoneController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          // icon: Text(
                          //   "Phone number:",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w800,
                          //       fontSize: 16,
                          //       color: Colors.black45),
                          // ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: AppColors.new_color,
                          prefixIcon: Icon(Icons.call),
                          hintText: "01xxxxxxxxx",
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
                      // TextField(
                      //   keyboardType: TextInputType.number,
                      //   controller: phoneController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       icon: Text(
                      //         "Phone number:",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w800,
                      //             fontSize: 16,
                      //             color: Colors.black45),
                      //       ),
                      //       hintText: "01xxxxx",
                      //       border: OutlineInputBorder()),
                      // ),
                      const SizedBox(height: 15),
                      Text(
                        "Select location:",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.black45),
                      ),
                      TextField(
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
                      // TextField(
                      //   controller: addressController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       hintText: "Mirpur, Dhanmondi etc..",
                      //       border: OutlineInputBorder()),
                      // ),
                      const SizedBox(height: 15),
                      Text(
                        "Salary:",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.black45),
                      ),
                      TextField(
                        enabled: true,
                        controller: salaryController,
                        //obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: AppColors.new_color,
                          prefixIcon: Icon(Icons.money),
                          hintText: "5000,6000 or negotiable",
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
                      // TextField(
                      //   controller: salaryController,
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.blue[50],
                      //       hintText: "5000,6000 or negotiable",
                      //       border: OutlineInputBorder()),
                      // ),
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
                      // CupertinoButton(
                      //     color: AppColors.new_color,
                      //     child: Text("save"),
                      //     onPressed: () {
                      //       sendUserDataToDB();
                      //       //saveUser();
                      //     }),
                    ],
                  ),
                ),
              ),
            ),
          )

    );
  }
}
// void saveUser() {
//   String name = nameController.text.trim();
//   String address = addressController.text.trim();
//
//   nameController.clear();
//   addressController.clear();
//
//   if (name != "" && address != "") {
//     Map<String, dynamic> userData = {"name": name, "address": address};
//     FirebaseFirestore.instance.collection("students").add(userData);
//     log("User created");
//   } else {
//     log("Please fill all the details");
//   }
// }
