import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hogoo/config/firebase_helper.dart';
import 'package:hogoo/model/chat_room.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/chat_room_page.dart';
import 'package:hogoo/pages/room_page.dart';

class CreateRoomPage extends StatefulWidget {
  String userID;
  CreateRoomPage(this.userID);
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  String roomName = 'room_name_';
  String roomId = Random().nextInt(200).toString();
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(style: TextStyle(color: Colors.black,fontSize: 26),onChanged: (value){
                roomName = value;
              },),
              FlatButton(
                onPressed: () async {
                  ChatRoom chatRoom = ChatRoom(
                      roomId: roomId,
                      roomName: roomName,
                      roomCat: 'chat',
                      roomType: 'public',
                      roomOwnerId: widget.userID);
                  _firebaseHelper.chatRoomCollectionReferance
                      .document('$roomName${widget.userID}$roomId')
                      .setData(chatRoom.toMap());
                  _firebaseHelper.chatRoomCollectionReferance
                      .document('$roomName${widget.userID}$roomId')
                      .collection('room_users')
                      .document()
                      .setData({
                    'user_id': widget.userID,
                    'seat_id': 1,
                    'admin_mute': false,
                    'user_mute': false,
                    'is_locked':false,
                  });
                  for(int i = 2;i <= 8;i++){
                    _firebaseHelper.chatRoomCollectionReferance
                        .document('$roomName${widget.userID}$roomId')
                        .setData(chatRoom.toMap());
                    _firebaseHelper.chatRoomCollectionReferance
                        .document('$roomName${widget.userID}$roomId')
                        .collection('room_users').document()
                        .setData({
                      'user_id': 'none',
                      'seat_id': i,
                      'admin_mute': false,
                      'user_mute': false,
                      'is_locked':false,
                    });
                  }

                  DocumentSnapshot documentSnapshot = await _firebaseHelper
                      .chatRoomCollectionReferance
                      .document('$roomName${widget.userID}$roomId')
                      .get();
                  ChatRoom chatroom =
                      ChatRoom.fromDocument(documentSnapshot.data);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return RoomPage(chatroom);
                  }));
                },
                child: Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
