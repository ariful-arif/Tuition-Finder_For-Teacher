import 'package:diu_project2/lib3/pages/about.dart';
import 'package:diu_project2/lib3/pages/home_page.dart';
import 'package:diu_project2/lib3/profile/profile.dart';
import 'package:diu_project2/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({super.key, required UserModel userModel, required User firebaseUser});
  //static const Color deep_orange = Color(0xFFFF6B6B);

  @override
  State<BottomNavigationController> createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  //final _pages = [ Profile(), About(), NotePage()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: Color(0xFFFF6B6B),
        backgroundColor: Colors.white10,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",

              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "About",
             ),
          BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: "Notes",
              ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
    //   body: //_pages[_currentIndex],
    // );
      // CupertinoTabScaffold(
      //   tabBar: CupertinoTabBar(
      //       activeColor: Colors.cyan,
      //       items: <BottomNavigationBarItem>[
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.home),
      //             label: "Home",
      //             backgroundColor: Colors.grey),
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.account_circle),
      //             label: "Profile",
      //             backgroundColor: Colors.grey),
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.back_hand_rounded),
      //             label: "About",
      //             backgroundColor: Colors.grey),
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.note),
      //             label: "Notes",
      //             backgroundColor: Colors.amber),
      //       ]),
      //   tabBuilder: (context, index) {
      //     switch (index) {
      //       case 0:
      //         return CupertinoTabView(
      //           builder: (context) {
      //             return CupertinoPageScaffold(child: HomePage());
      //           },
      //         );
      //       case 1:
      //         return CupertinoTabView(
      //           builder: (context) {
      //             return CupertinoPageScaffold(child: Profile());
      //           },
      //         );
      //       case 2:
      //         return CupertinoTabView(
      //           builder: (context) {
      //             return CupertinoPageScaffold(child: About());
      //           },
      //         );
      //       case 3:
      //         return CupertinoTabView(
      //           builder: (context) {
      //             return CupertinoPageScaffold(child: NotePage());
      //           },
      //         );
      //     }
      //     return Container();

    ); //   });
  }
}


