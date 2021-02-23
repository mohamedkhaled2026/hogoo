import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hogoo/config/firebase_helper.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/profile_page.dart';

class AdditionalUserDataPage extends StatefulWidget {
  String userId;
  AdditionalUserDataPage(this.userId);
  @override
  _AdditionalUserDataPageState createState() => _AdditionalUserDataPageState();
}

class _AdditionalUserDataPageState extends State<AdditionalUserDataPage> {
  String userGender;
  DateTime birthDate = DateTime.now();
  CollectionReference firestoreReference = Firestore.instance.collection('users');
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(
                fontSize: 26,
              ),
              onChanged: (value) {
                userGender = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(birthDate.toString()),
            FlatButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1950, 1, 1),
                      maxTime: DateTime.now(),
                      onChanged: (date) {}, onConfirm: (date) {
                    print('confirm $date');
                    setState(() {
                      birthDate = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.ar);
                },
                child: Text(
                  'show date time picker',
                  style: TextStyle(color: Colors.blue),
                )),
            SizedBox(height: 20,),
            FlatButton(
              onPressed: () async{
                  _firebaseHelper.userCollectionReferance.document(widget.userId).updateData({
                  'birth_date' : birthDate,
                  'user_gender':userGender,
                });
                User currentUser = await _firebaseHelper.getUserInfo(widget.userId);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return ProfilePage(currentUser);
                }));
              },
              child: Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}
