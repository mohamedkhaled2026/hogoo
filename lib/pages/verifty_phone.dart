import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hogoo/config/firebase_helper.dart';
import 'package:hogoo/config/sign_in_methods.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/phone_signup_page.dart';
import 'package:hogoo/pages/profile_page.dart';
import 'package:hogoo/widget/numeric_pad.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VerifyPhone extends StatefulWidget {
  final String phoneNumber;
  SignInMethods signInMethods;

  VerifyPhone({this.phoneNumber, this.signInMethods});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  String code = "";
  bool isProgress = false;
  FirebaseHelper _firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ModalProgressHUD(
      inAsyncCall: isProgress,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Verify phone",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
        ),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Code is sent to
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Code is sent to " + widget.phoneNumber,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF818181),
                        ),
                      ),
                    ),

                    //code box
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: buildCodeNumberBox(
                                  code.length > 0 ? code.substring(0, 1) : "")),
                          Expanded(
                              child: buildCodeNumberBox(
                                  code.length > 1 ? code.substring(1, 2) : "")),
                          Expanded(
                              child: buildCodeNumberBox(
                                  code.length > 2 ? code.substring(2, 3) : "")),
                          Expanded(
                              child: buildCodeNumberBox(
                                  code.length > 3 ? code.substring(3, 4) : "")),
                          Expanded(
                              child: buildCodeNumberBox(
                                  code.length > 4 ? code.substring(4, 5) : "")),
                          Expanded(
                              child: buildCodeNumberBox(
                                  code.length > 5 ? code.substring(5, 6) : "")),
                        ],
                      ),
                    ),

                    // didn't recieve code
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Didn't recieve code? ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF818181),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Resend the code to the user");
                            },
                            child: Text(
                              "Request again",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            isProgress = true;
                          });
                          print(code);
                          FirebaseUser user =
                              await widget.signInMethods.verifyPhone(code);
                          if (user != null) {
                            DocumentSnapshot documentSnapshot =
                                await _firebaseHelper.userCollectionReferance
                                    .document(user.uid)
                                    .get();
                            if (documentSnapshot.exists) {
                              User currentUser =
                                  User.fromDocument(documentSnapshot.data);
                              setState(() {
                                isProgress = false;
                              });
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProfilePage(currentUser);
                              }));
                            } else {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return PhoneSignupPage(
                                    widget.phoneNumber, user.uid);
                              }));
                            }
                          }
//                    Navigator.pushReplacement(context,
//                        MaterialPageRoute(builder: (context) {
//                          return ProfilePage(user);
//                        }));
                          setState(() {
                            isProgress = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFd0325f),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Verify and Create Account",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NumericPad(
              onNumberSelected: (value) {
                print(value);
                setState(() {
                  if (value != -1) {
                    if (code.length < 6) {
                      code = code + value.toString();
                    }
                  } else {
                    code = code.substring(0, code.length - 1);
                  }
                  print(code);
                });
              },
            ),
          ],
        )),
      ),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 45,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
