import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hogoo/model/chat_room.dart';
class ChatRoomPage extends StatefulWidget {
  String roomId;
  String userId;
  ChatRoomPage(this.roomId,this.userId);
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  CollectionReference _collectionReference = Firestore.instance.collection('chat_rooms');
  ChatRoom chatRoomInfo = ChatRoom(roomOwnerId: '22',roomType: 'ss',roomCat: 'sd',roomName: 'dssd',roomId: 'sdsd');
  bool _isInChannel = false;

  Future<ChatRoom> getRoomInfo() async{
    _collectionReference.document(widget.roomId).snapshots(includeMetadataChanges: true).listen((doc){
      print('oooooooooooooooo');
      if(doc.exists) {
        setState(() {
          chatRoomInfo = ChatRoom.fromDocument(doc.data);
        });

      }else{
      print('iiiiiiiiiiiiiiiiiiiii');
      }
      return true;
    });
  }
  getUserInfo() async{


    _collectionReference.document(widget.roomId).collection('room_users').document(widget.userId).snapshots(includeMetadataChanges: true).listen((doc){
      if(doc.exists){
        print(doc.data['is_seat_user']);
        setState(() {
          joinChannel(widget.roomId, doc.data['is_seat_user']);
        });
      }else{
        print('error join channel');
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoomInfo();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    getUserInfo();
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create('6c8bc5c7724547fc8615c5fb976ca528');

    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
    //AgoraRtcEngine.setEnableSpeakerphone(true);
  }


  void _addAgoraEventHandlers() {

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        print('onJoinChannel: ' + channel + ', uid: ' + uid.toString());
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        print('leave');
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {

        String info = 'userJoined: ' + uid.toString();
        print(info);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        print(info);
      });
    };

  }

  void joinChannel(String roomId,bool isUserSeat) async {
     print(roomId);
      await AgoraRtcEngine.joinChannel(null, roomId, null, 0);
      AgoraRtcEngine.enableLocalAudio(isUserSeat);
      print(isUserSeat);
      //AgoraRtcEngine.enableAudio();
      // AgoraRtcEngine.enableVideo();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(chatRoomInfo.roomId),
            Text(chatRoomInfo.roomName),
            Text(chatRoomInfo.roomOwnerId),
            Text(chatRoomInfo.roomType),
            Text(chatRoomInfo.roomCat),
          ],
        ),
      ),
    );
  }
}
