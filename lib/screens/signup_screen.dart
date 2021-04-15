import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_database/firebase_database.dart';//not present yet
import 'login_screen.dart';
import '../main.dart';
import 'home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

class SignUpScreen extends StatefulWidget {
  static String id = 'signUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TextEditingController _emailController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  User _user = FirebaseAuth.instance.currentUser;
  String _email, _password, _username;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("FOODUCATE SIGN-UP"),
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
                    height: 288,
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
                  //key: _formKey,//commented on 6.11pm 17-3-21
                  child: Column(
                    children: <Widget>[
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          textAlign: TextAlign.center,
                          // ignore: missing_return
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter a User Name'),
                          //onSaved: (newValue) => _nameController.text = newValue,//commented on 6.11pm 17-3-21
                          onChanged: (value) => _username = value,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter a Valid Email as abc@gmail.com'),
                          //onSaved: (newValue) => _emailController.text = newValue,//commented on 6.11pm 17-3-21
                          onChanged: (value) => _email = value,
                        ),
                        /*TextFormField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (value) => value.isEmpty ? 'isnotEmpty' : null,
                          /*(value) {
                            if (value.isEmpty) {
                              return "Enter a valid Email";
                            }
                          },*/
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter a Valid Email as abc@gmail.com'),
                          //onSaved: (newValue) => _emailController.text = newValue,//commented on 6.11pm 17-3-21
                          onSaved: (newValue) => email = newValue,
                        ),*/
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          // ignore: missing_return
                          /*(value) {
                            if (value.length < 5) {
                              return "Enter Minimum 8 Characters";
                            }
                          },*/
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter secure password'),
                          //onSaved: (newValue) => _passwordController.text = newValue,//commented on 6.11pm 17-3-21
                          onChanged: (value) => _password = value,
                        ),
                        /*TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          // ignore: missing_return
                          validator: (value) => value.isEmpty ? 'isnotEmpty' : null,
                              /*(value) {
                            if (value.length < 5) {
                              return "Enter Minimum 8 Characters";
                            }
                          },*/
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter secure password'),
                          //onSaved: (newValue) => _passwordController.text = newValue,//commented on 6.11pm 17-3-21
                          onSaved: (newValue) => password = newValue,
                        ),
                        */
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 48,
                        width: 237,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            /*if (_formKey.currentState.validate()) {
                              registerToFireBase();
                            }*/ //commented on 6.11pm 17-3-21
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              print(_email);
                              print(_password);
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);
                              //UserCredential user = newUser.user;
                              if (newUser != null) {
                                //Navigator.pushNamed(context,GenderSelect.id);
                                Navigator.pushReplacementNamed(context, GenderSelect.id,arguments: {'email':_email,'newAppUser':true,'CurrentAppUserData': AppUser()});
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                              setState(() {
                                print('do some thing');
                                showSpinner = false;
                              });
                            }
                          },
                          child: Text(
                            'SIGN UP',
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
class SignUpScreen extends StatelessWidget {
  static String id = 'signUpScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('FOODUCATE SIGNUP'),
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
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference dbref = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void registerToFireBase() async {
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) {
      dbref.child(result.user.uid).set({
        "username": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text
      }).then((res) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(uid: result.user.uid)));
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                // ignore: deprecated_member_use
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("FOODUCATE SIGN-UP"),
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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (value) {
                          if (value.length < 6) {
                            return "Enter a minimum of 5 characters";
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.purple),
                            hintText: 'Enter a UserName'),
                        onSaved: (newValue) => _nameController.text = newValue,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter a valid Email";
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
                        onSaved: (newValue) => _emailController.text = newValue,
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
                            return "Enter Minimum 4 Characters";
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
                        onSaved: (newValue) =>
                            _passwordController.text = newValue,
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
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            registerToFireBase();
                          }
                        },
                        child: Text(
                          'SIGN-UP',
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
