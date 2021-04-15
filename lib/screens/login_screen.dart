import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooducate/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_database/firebase_database.dart';//not present yet
import 'signup_screen.dart';
import '../main.dart';
import 'home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

class LogInScreen extends StatefulWidget {
  static String id = 'logInScreen';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _fireBaseStore = FirebaseFirestore.instance;
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("FOODUCATE LOGIN"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 21.0),
                child: Center(
                  child: Container(
                    width: 500,
                    height: 300,
                    /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image(
                      image: AssetImage('images/start_img.png'),
                    ),
                  ),
                ),
              ),
              Container(
                child: Form(
                  //key: _formKey, //commented on 6.11pm 17-3-21
                  child: Column(
                    children: <Widget>[
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText:
                                  'Enter valid email id as abc@gmail.com'),
                          onChanged: (value) => _email = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          // ignore: missing_return

                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter secure password'),
                          onChanged: (value) => _password = value,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20)),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () async {
                            // Navigator.push(
                            //     context, MaterialPageRoute(builder: (_) => Login()));
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final cUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email, password: _password);
                              if (cUser != null) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreen.id,
                                );
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // FlatButton(
              //   onPressed: () {},
              //   child: Text(
              //     'FORGOT PASSWORD',
              //     style: TextStyle(color: Colors.purple, fontSize: 15),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
class LogInScreen extends StatelessWidget {
  static String id = 'logInScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('FOODUCATE LOGIN'),
        ),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SafeArea(
        child: Card(
          child: Column(
            children: <Widget>[
              Center(
                child: Image(
                  image: AssetImage('images/start_img.png'),
                ),
              ),
              ElevatedButton(
                child: ListTile(
                  leading: Icon(
                    Icons.login,
                    color: Colors.deepPurpleAccent,
                  ),
                  tileColor: Colors.deepPurple[200],
                  title: Text('Sign-Up'),
                ),
                onPressed: () {},
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                child: ListTile(
                  leading: Icon(
                    Icons.login,
                    color: Colors.deepPurpleAccent,
                  ),
                  tileColor: Colors.deepPurple[200],
                  title: Text('Log-In'),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference dbref =
      FirebaseDatabase.instance.reference().child("Users");

  String _email;
  String _password;

  // checkAuthentication() async {
  //   //as soon as auth state changes from sign in to sign out, flutter fires up a listener here
  //   _auth.onAuthStateChanged.listen((user) {
  //     if (user != null) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Login(),
  //           ));
  //     }
  //   });
  // }

  @override
  // void InitState() {
  //   super.initState();
  //   this.checkAuthentication();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("LOGIN"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 500,
                  height: 300,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image(
                    image: AssetImage('images/start_img.png'),
                  ),
                ),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Valid Email Address";
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.purple),
                            hintText: 'Enter valid email id as abc@gmail.com'),
                        onSaved: (value) => _email = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (value) {
                          if (value.length < 5) {
                            return "Enter Minimum 15 Characters";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.purple),
                            hintText: 'Enter secure password'),
                        onSaved: (value) => _password = value,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) => Login()));
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // FlatButton(
            //   onPressed: () {},
            //   child: Text(
            //     'FORGOT PASSWORD',
            //     style: TextStyle(color: Colors.purple, fontSize: 15),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
*/
