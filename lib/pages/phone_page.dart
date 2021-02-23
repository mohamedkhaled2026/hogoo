import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hogoo/config/sign_in_methods.dart';
import 'package:hogoo/pages/phone_signup_page.dart';
import 'package:hogoo/pages/profile_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart' as intll;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhonePage extends StatefulWidget {
  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  intll.PhoneNumber _phoneNumber;
  TextEditingController smsController = TextEditingController();
  final SignInMethods signInMethods = SignInMethods();
  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModalProgressHUD(
        inAsyncCall: isProgress,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                intll.InternationalPhoneNumberInput(
                  onInputChanged:(phone){
                    _phoneNumber = phone;
                  },
                  inputBorder: OutlineInputBorder(),
                  initialCountry2LetterCode: 'EG',
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async{
                    await signInMethods.signInWithPhone(_phoneNumber.phoneNumber);
                    print(_phoneNumber.phoneNumber);
                  },
                  child: Text('Phone',style: TextStyle(color: Colors.blueAccent,fontSize: 26.0,fontWeight: FontWeight.bold),),
                ),
                TextField(
                  controller: smsController,
                  style: TextStyle(color: Colors.red),
                ),
                GestureDetector(
                  onTap: () async{
                    setState(() {
                      isProgress = true;
                    });
                    FirebaseUser user = await signInMethods.verifyPhone(smsController.text);
                    if(user != null){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return PhoneSignupPage(_phoneNumber.phoneNumber,user.uid);
                      }));
                    }
//                    Navigator.pushReplacement(context,
//                        MaterialPageRoute(builder: (context) {
//                          return ProfilePage(user);
//                        }));
                    setState(() {
                      isProgress = false;
                    });
                  },
                  child: Text('verify',style: TextStyle(color: Colors.blueAccent,fontSize: 26.0,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
