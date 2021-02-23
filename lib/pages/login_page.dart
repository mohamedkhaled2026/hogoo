import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hogoo/config/firebase_helper.dart';
import 'package:hogoo/config/sign_in_methods.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/additional_user_data_page.dart';
import 'package:hogoo/pages/continue_with_phone.dart';
import 'package:hogoo/pages/phone_page.dart';
import 'package:hogoo/pages/profile_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SignInMethods signInMethodes = SignInMethods();
  bool isProgress = false;
  Firestore firestore = Firestore.instance;
  DocumentSnapshot documentSnapshot;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseHelper _firebaseHelper = FirebaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignedIn();
  }

  isSignedIn() async {
    setState(() {
      isProgress = true;
    });
    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      print('user signed in');
      UserInfo userProfile ;
      String userId = firebaseUser.uid;
      for (UserInfo profile in firebaseUser.providerData) {
        // check if the provider id matches "facebook.com"
        if(GoogleAuthProvider.providerId == profile.providerId) {
          userProfile = profile;
          userId = profile.uid;
          print(userProfile.uid);
        }
        if(FacebookAuthProvider.providerId == profile.providerId){
          userProfile = profile;
          userId = profile.uid;
          print(userProfile.uid);
        }
      }
      User currentUser = await _firebaseHelper.getUserInfo(userId);
      setState(() {
        isProgress = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ProfilePage(currentUser);
      }));
    } else {
      print('no user');
      setState(() {
        isProgress = false;
      });
    }
  }

  registerUserInFireStore(UserInfo userProfile) async {
    documentSnapshot =
        await firestore.collection('users').document(userProfile.uid).get();
    if (documentSnapshot.exists) {
      User currentUser = User.fromDocument(documentSnapshot.data);
      setState(() {
        isProgress = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ProfilePage(currentUser);
      }));
    } else {
      User userData = User(
        userId: userProfile.uid,
        userName: userProfile.displayName,
        userPhone: userProfile.phoneNumber,
        userEmail: userProfile.email,
        userPhoto: userProfile.photoUrl,
        providerId: userProfile.providerId,
        userStatus: 'online',
        diamonds: 0,
        beans: 0,
        carisma: 0,
        wealthLevel: 0,
      );
      Map userInfo = userData.toMap();
      print(userProfile.uid);
      firestore.collection('users').document(userProfile.uid).setData(userInfo);
      setState(() {
        isProgress = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AdditionalUserDataPage(userData.userId);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isProgress,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 123, 67, 1.0),
              Color.fromRGBO(245, 50, 111, 1.0),
            ],
          )),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Icon(
                    Icons.bubble_chart,
                    color: Colors.white,
                    size: 60,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Ho',
                        style: TextStyle(
                          color: Color.fromRGBO(245, 50, 111, 1.0),
                          fontWeight: FontWeight.bold,
                          fontSize: 45.0,
                        ),
                      ),
                      Text(
                        'Go',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 45.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ContinueWithPhone();
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mobileAlt,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          Text(
                            '  |  Sign in with Phone ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isProgress = true;
                      });
                      UserInfo user =
                          await signInMethodes.signInWithGoogle();
                      print(user.photoUrl);
                      print(user.email);
                      registerUserInFireStore(user);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                            size: 30.0,
                          ),
                          Text(
                            '  |  Sign in with Google ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String facebookUserId;
                      setState(() {
                        isProgress = true;
                      });
                      UserInfo user =
                          await signInMethodes.signInWithFacebook();
                      print(user.photoUrl);
                      registerUserInFireStore(user);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          Text(
                            '  |  Sign in with Facebook ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
