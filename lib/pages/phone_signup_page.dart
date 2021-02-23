import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/profile_page.dart';
import 'package:image_picker/image_picker.dart';
class PhoneSignupPage extends StatefulWidget {
  String phoneNumber;
  String userId;
  PhoneSignupPage(this.phoneNumber,this.userId);
  @override
  _PhoneSignupPageState createState() => _PhoneSignupPageState();
}

class _PhoneSignupPageState extends State<PhoneSignupPage> {
  File _image;
  String userName;
  String userGender;
  DateTime birthDate = DateTime.now();

  final picker = ImagePicker();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<dynamic> uploadImage(File image) async{
    StorageReference storageReference = firebaseStorage.ref().child('profile_images');
    StorageUploadTask storageUploadTask  = storageReference.child('user_${widget.userId}.jpg').putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: getImage,
              child: CircleAvatar(
                child: _image == null ?Icon(Icons.add_a_photo):Image.file(_image),
              ),
            ),
            TextField(style: TextStyle(fontSize: 26),
            onChanged: (value){
              userName = value;
            },),
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
                String userPhoto = await uploadImage(_image);
                CollectionReference firestoreReference = Firestore.instance.collection('users');
                User userData = User(
                  userId: widget.userId,
                  userName: userName,
                  userPhone: '+2'+widget.phoneNumber,
                  userEmail: null,
                  userPhoto: userPhoto,
                  userGender: userGender,
                  birthDate: Timestamp.fromDate(birthDate),
                  providerId: 'phone',
                  userStatus: 'online',
                  diamonds: 0,
                  beans: 0,
                  carisma: 0,
                  wealthLevel: 0,
                );
                Map userInfo = userData.toMap();
                await firestoreReference.document(widget.userId).setData(userInfo);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return ProfilePage(userData);
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
