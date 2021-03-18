import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_database/firebase_database.dart';//not present yet
import 'signup_screen.dart';
import 'login_screen.dart';
import 'main.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'homeScreen';
  //FirebaseUser currentUser;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        //currentUser = user;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          centerTitle: true,
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  await _auth.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {
                    showSpinner = false;
                  });
                }),
          ],
          title: Text(
            'FOODUCATE HOME',
          ),
        ),
        body: SafeArea(
          child: Container(
              child: Column(
            children: <Widget>[
              Text('Home Screen'),
              Image(
                image: AssetImage('images/start_img.png'),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
