import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hogoo/config/firebase_helper.dart';
import 'package:hogoo/model/chat_room.dart';
import 'package:hogoo/model/user.dart';

class RoomPage extends StatefulWidget {
  ChatRoom chatRoom;
  RoomPage(this.chatRoom);
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  String roomUniqeId;
  User currentUser;
  int userCount = 0;
  bool bol = true;
  Widget processing = Center(
      child: CircularProgressIndicator(
    backgroundColor: Colors.deepPurple,
  ));

  Future<List<Widget>> createMenuItems(
      int seatNo, BuildContext buildContext) async {
    List<Widget> menuItems = List<Widget>();
    DocumentSnapshot documentSnapshot = (await _firebaseHelper
            .chatRoomCollectionReferance
            .document(roomUniqeId)
            .collection('room_users')
            .where('seat_id', isEqualTo: seatNo)
            .getDocuments())
        .documents
        .first;
    if (currentUser.userId == widget.chatRoom.roomOwnerId) {
      print(seatNo.toString() +
          '   ' +
          documentSnapshot.data['user_id'] +
          '    ' +
          documentSnapshot.data['is_locked'].toString());
      if (documentSnapshot.data['user_id'] == 'none' &&
          documentSnapshot.data['is_locked'] == false) {
        menuItems = [
          GestureDetector(
            onTap: () {
              onSelected(1, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "invite",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(2, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Lock",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(3, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Switch",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ];
      } else if (documentSnapshot.data['user_id'] == 'none' &&
          documentSnapshot.data['is_locked'] == true) {
        menuItems = [
          GestureDetector(
            onTap: () {
              onSelected(1, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "invite",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(4, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Unlock",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ];
      } else {
        menuItems = [
          GestureDetector(
            onTap: () {
              onSelected(5, seatNo, buildContext);
              Navigator.pop(context);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Leave",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(8, seatNo, buildContext);
              Navigator.pop(context);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Kick",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(2, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Lock",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(6, seatNo, buildContext);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "View Profile",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelected(7, seatNo, buildContext);
              Navigator.pop(context);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              height: 30,
              child: Text(
                "Mute",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ];
      }
    }
    return menuItems;
  }

  onSelected(int value, int seatNo, BuildContext con) async {
    print(value.toString() + seatNo.toString());
    QuerySnapshot querySnapshot =
        await _firebaseHelper.chatRoomCollectionReferance
            .document(roomUniqeId)
            .collection('room_users')
            .orderBy(
              'seat_id',
            )
            .getDocuments();
    if (currentUser.userId == widget.chatRoom.roomOwnerId) {
      if (value == 1) {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 100,
                child: FutureBuilder<List<User>>(
                    future: getNonSeatUserOnline(),
                    builder: (BuildContext context, snapshot) {
                      print(snapshot);
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            return GestureDetector(
                              onTap: () async {
                                DocumentReference documentReference;
                                for (DocumentSnapshot doc
                                    in querySnapshot.documents) {
                                  print(doc.data['seat_id'].toString() +
                                      '    ' +
                                      snapshot.data[index].userId);
                                  if (doc.data['seat_id'] == 0 &&
                                      snapshot.data[index].userId ==
                                          doc.data['user_id']) {
                                    documentReference = doc.reference;
                                  }
                                  if (doc.data['seat_id'] == seatNo) {
                                    doc.reference.updateData({
                                      'admin_mute': false,
                                      'user_mute': false,
                                      'user_id': snapshot.data[index].userId,
                                      'is_locked': false,
                                    });
                                    documentReference.delete();
                                  }
                                }
                                Navigator.pop(context);
                                Navigator.pop(con);
                              },
                              child: Container(
                                child: Text(snapshot.data[index].userName),
                              ),
                            );
                          },
                          itemCount: snapshot.data.length,
                        );
                      } else {
                        return processing;
                      }
                    }),
              );
            });
      } else if (value == 2) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['seat_id'] == seatNo) {
            if (doc.data['user_id'] != 'none') {
              _firebaseHelper.chatRoomCollectionReferance
                  .document(roomUniqeId)
                  .collection('room_users')
                  .document()
                  .setData({
                'admin_mute': true,
                'user_mute': true,
                'user_id': doc.data['user_id'],
                'seat_id': 0,
              });
            }
            doc.reference.updateData({
              'admin_mute': true,
              'user_mute': true,
              'user_id': 'none',
              'is_locked': true,
            });
          }
        }
        Navigator.pop(con);
      } else if (value == 3) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['user_id'] == currentUser.userId) {
            doc.reference.updateData({
              'admin_mute': false,
              'user_mute': false,
              'user_id': 'none',
              'is_locked': false,
            });
          }
          if (doc.data['seat_id'] == seatNo) {
            doc.reference.updateData({
              'admin_mute': false,
              'user_mute': false,
              'user_id': currentUser.userId,
              'is_locked': false,
            });
          }
        }
        Navigator.pop(con);
      } else if (value == 4) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['seat_id'] == seatNo) {
            doc.reference.updateData({
              'admin_mute': false,
              'user_mute': false,
              'is_locked': false,
            });
          }
        }
        Navigator.pop(con);
      } else if (value == 5) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['seat_id'] == seatNo) {
            _firebaseHelper.chatRoomCollectionReferance
                .document(roomUniqeId)
                .collection('room_users')
                .document()
                .setData({
              'admin_mute': true,
              'user_mute': true,
              'user_id': doc.data['user_id'],
              'seat_id': 0,
            });

            doc.reference.updateData({
              'admin_mute': false,
              'user_mute': false,
              'user_id': 'none',
            });
          }
        }
      } else if (value == 6) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['seat_id'] == seatNo) {
            User user = await _firebaseHelper.getUserInfo(doc.data['user_id']);
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Image.network(user.userPhoto),
                      Text(user.userName)
                    ],
                  ),
                );
              },
            );
          }
        }
      } else if (value == 7) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['seat_id'] == seatNo) {
            doc.reference.updateData({
              'admin_mute': true,
              'user_mute': false,
            });
          }
        }
      } else if (value == 8) {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          if (doc.data['seat_id'] == seatNo) {
            doc.reference.updateData({
              'user_id': 'none',
            });
          }
        }
      }
    } else {
      for (DocumentSnapshot doc in querySnapshot.documents) {
        if (doc.data['seat_id'] == seatNo) {
          if (doc.data['user_id'] != 'none') {
            User user = await _firebaseHelper.getUserInfo(doc.data['user_id']);
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Image.network(user.userPhoto),
                      Text(user.userName)
                    ],
                  ),
                );
              },
            );
          } else {
            if (doc.data['is_locked']) {
              print('seat is locked');
            } else {
              doc.reference.updateData({
                'user_id': currentUser.userId,
                'admin_mute': false,
                'user_mute': false
              });
            }
          }
        }
      }
    }
  }

  Widget _childPopup(int seatNo, Widget widgett) => PopupMenuButton<int>(
        itemBuilder: (context) {
          //createMenuItems(seatNo);
          return null; //menuItems;
        },
        onCanceled: () {
          //createMenuItems(seatNo);
        },
        onSelected: (value) async {
          print(value.toString() + seatNo.toString());
          QuerySnapshot querySnapshot =
              await _firebaseHelper.chatRoomCollectionReferance
                  .document(roomUniqeId)
                  .collection('room_users')
                  .orderBy(
                    'seat_id',
                  )
                  .getDocuments();
          if (currentUser.userId == widget.chatRoom.roomOwnerId) {
            if (value == 1) {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 100,
                      child: FutureBuilder<List<User>>(
                          future: getNonSeatUserOnline(),
                          builder: (BuildContext context, snapshot) {
                            print(snapshot);
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemBuilder: (BuildContext context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      DocumentReference documentReference;
                                      for (DocumentSnapshot doc
                                          in querySnapshot.documents) {
                                        print(doc.data['seat_id'].toString() +
                                            '    ' +
                                            snapshot.data[index].userId);
                                        if (doc.data['seat_id'] == 0 &&
                                            snapshot.data[index].userId ==
                                                doc.data['user_id']) {
                                          documentReference = doc.reference;
                                        }
                                        if (doc.data['seat_id'] == seatNo) {
                                          doc.reference.updateData({
                                            'is_seat_user': true,
                                            'user_id':
                                                snapshot.data[index].userId,
                                            'is_locked': false,
                                          });
                                          documentReference.delete();
                                        }
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child:
                                          Text(snapshot.data[index].userName),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.length,
                              );
                            } else {
                              return processing;
                            }
                          }),
                    );
                  });
            } else if (value == 2) {
              for (DocumentSnapshot doc in querySnapshot.documents) {
                if (doc.data['seat_id'] == seatNo) {
                  doc.reference.updateData({
                    'is_seat_user': true,
                    'mute': false,
                    'user_id': 'none',
                    'is_locked': true,
                  });
                }
              }
            } else if (value == 3) {
              for (DocumentSnapshot doc in querySnapshot.documents) {
                if (doc.data['user_id'] == currentUser.userId) {
                  doc.reference.updateData({
                    'is_seat_user': true,
                    'mute': false,
                    'user_id': 'none',
                    'is_locked': false,
                  });
                }
                if (doc.data['seat_id'] == seatNo) {
                  doc.reference.updateData({
                    'is_seat_user': true,
                    'mute': false,
                    'user_id': currentUser.userId,
                    'is_locked': false,
                  });
                }
              }
            } else if (value == 4) {
              for (DocumentSnapshot doc in querySnapshot.documents) {
                if (doc.data['seat_id'] == seatNo) {
                  doc.reference.updateData({
                    'is_seat_user': true,
                    'mute': false,
                    'is_locked': false,
                  });
                }
              }
            }
          }
        },
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(child: widgett),
              ),
              Text(
                'No.$seatNo',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );

  Widget _childPopupp(int seatNo, Widget widgett) => GestureDetector(
        onTap: () async {
          QuerySnapshot querySnapshot =
              await _firebaseHelper.chatRoomCollectionReferance
                  .document(roomUniqeId)
                  .collection('room_users')
                  .orderBy(
                    'seat_id',
                  )
                  .getDocuments();
          if (currentUser.userId == widget.chatRoom.roomOwnerId) {
            List<Widget> menuItems = List<Widget>();
            menuItems = await createMenuItems(seatNo, context);
            AlertDialog alertDialog = AlertDialog(
              content: Container(
                width: (MediaQuery.of(context).size.width) / 2,
                height: (30 * (menuItems.length)).toDouble(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: menuItems,
                ),
              ),
            );
            showDialog(
                context: context,
                builder: (context) {
                  return alertDialog;
                });
          } else {
            for (DocumentSnapshot doc in querySnapshot.documents) {
              if (doc.data['seat_id'] == seatNo) {
                if (doc.data['user_id'] != 'none') {
                  User user =
                      await _firebaseHelper.getUserInfo(doc.data['user_id']);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Image.network(user.userPhoto),
                            Text(user.userName)
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  if (doc.data['is_locked']) {
                    print('seat is locked');
                  } else {
                    if (doc.data['seat_id'] != 1) {
                      for (DocumentSnapshot docc in querySnapshot.documents) {
                        if (currentUser.userId == docc.data['user_id'] &&
                            docc.data['seat_id'] != 0) {
                          doc.reference.updateData({
                            'user_id': currentUser.userId,
                            'admin_mute': false,
                            'user_mute': false
                          });
                          docc.reference.updateData({
                            'user_id': 'none'
                          });
                        } else if (currentUser.userId == docc.data['user_id'] &&
                            docc.data['seat_id'] == 0) {
                          doc.reference.updateData({
                            'user_id': currentUser.userId,
                            'admin_mute': false,
                            'user_mute': false
                          });
                          docc.reference.delete();
                        }
                      }
                    }else{
                      print('not allow');
                    }
                  }
                }
              }
            }
          }
        },
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(child: widgett),
              ),
              Text(
                'No.$seatNo',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );

  getUserInfo() async {
    currentUser = await _firebaseHelper.getCurrentUser();

    _firebaseHelper.chatRoomCollectionReferance
        .document(roomUniqeId)
        .collection('room_users')
        .snapshots()
        .listen((querySnapshot) {
      for (DocumentSnapshot doc in querySnapshot.documents) {
        if (doc.data['user_id'] == currentUser.userId) {
          doc.reference
              .snapshots(includeMetadataChanges: true)
              .listen((document) {
            print('lllllllllllllllllllllll' + document.exists.toString());
            if (document.exists) {
              setState(() {
                print('oooooooooooooooooooooooooooooooooooooo');
                print(roomUniqeId +
                    '   ' +
                    document.data['is_seat_user'].toString());
                if (bol) {
                  if (document.data['admin_mute'] == false &&
                      document.data['user_mute'] == false) {
                    joinChannel(roomUniqeId, true);
                  } else {
                    joinChannel(roomUniqeId, false);
                  }
                  bol = false;
                } else {
                  if (document.data['admin_mute'] == false &&
                      document.data['user_mute'] == false) {
                    AgoraRtcEngine.enableLocalAudio(true);
                  } else {
                    AgoraRtcEngine.enableLocalAudio(false);
                  }
                }
              });
            } else {
              print('error join channel');
            }
          });
        }
      }
    });
  }

  getUserOnlineCount() async {
    _firebaseHelper.chatRoomCollectionReferance
        .document(roomUniqeId)
        .collection('room_users')
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      int counter = 0;
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        if (documentSnapshot.data['user_id'] != 'none') {
          counter++;
        }
      }
      setState(() {
        userCount = counter;
      });
    });
  }

  Future<List<User>> getUserOnline() async {
    List<User> onlineUsers = List<User>();
    QuerySnapshot querySnapshot = await _firebaseHelper
        .chatRoomCollectionReferance
        .document(roomUniqeId)
        .collection('room_users')
        .orderBy('seat_id')
        .getDocuments();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      if (doc.data['user_id'] != 'none') {
        User user = await _firebaseHelper.getUserInfo(doc.data['user_id']);
        onlineUsers.add(user);
      }
    }
    return onlineUsers;
  }

  Future<List<User>> getNonSeatUserOnline() async {
    List<User> onlineUsers = List<User>();
    QuerySnapshot querySnapshot =
        await _firebaseHelper.chatRoomCollectionReferance
            .document(roomUniqeId)
            .collection('room_users')
            //.where('seat_id', isEqualTo: 0)
            .orderBy('seat_id')
            .getDocuments();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      if (doc.data['user_id'] != 'none' && doc.data['seat_id'] == 0) {
        User user = await _firebaseHelper.getUserInfo(doc.data['user_id']);
        onlineUsers.add(user);
      }
    }
    return onlineUsers;
  }

  Future<List<User>> getSeatUsers() async {
    List<User> seatUsers = List<User>();
    QuerySnapshot querySnapshot = await _firebaseHelper
        .chatRoomCollectionReferance
        .document(roomUniqeId)
        .collection('room_users')
        .where('seat_id', isGreaterThanOrEqualTo: 1, isLessThanOrEqualTo: 8)
        .orderBy('seat_id', descending: false)
        .getDocuments();
    for (DocumentSnapshot docSnap in querySnapshot.documents) {
      User user = await _firebaseHelper.getUserInfo(docSnap.data['user_id']);
      user.seatId = docSnap.data['seat_id'];
      user.isLocked = docSnap.data['is_locked'];
      user.adminMute = docSnap.data['admin_mute'];
      user.userMute = docSnap.data['user_mute'];
      seatUsers.add(user);
    }
    return seatUsers;
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
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {});
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
      });
    };
  }

  void joinChannel(String roomId, bool isUserSeat) async {
    await AgoraRtcEngine.joinChannel(null, roomId, null, 0);
    AgoraRtcEngine.enableLocalAudio(isUserSeat);
  }

  void leaveChannel() async {
    await AgoraRtcEngine.leaveChannel();
    QuerySnapshot querySnapshot = await _firebaseHelper
        .chatRoomCollectionReferance
        .document(roomUniqeId)
        .collection('room_users')
        .getDocuments();
    User currentUser = await _firebaseHelper.getCurrentUser();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      if (doc.data['seat_id'] == 0 &&
          doc.data['user_id'] == currentUser.userId) {
        doc.reference.delete();
      } else if (doc.data['seat_id'] != 0 &&
          doc.data['user_id'] == currentUser.userId) {
        doc.reference.updateData({
          'user_id': 'none',
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomUniqeId = widget.chatRoom.roomName +
        widget.chatRoom.roomOwnerId +
        widget.chatRoom.roomId;
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    getUserInfo();
    getUserOnlineCount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 123, 67, 1.0),
              Color.fromRGBO(245, 50, 111, 1.0),
            ],
          )),
          padding: EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              //Row1
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.chatRoom.roomName,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Cairo'),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 100,
                                      child: FutureBuilder<List<User>>(
                                          future: getUserOnline(),
                                          builder:
                                              (BuildContext context, snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  return Container(
                                                    child: Text(snapshot
                                                        .data[index].userName),
                                                  );
                                                },
                                                itemCount: snapshot.data.length,
                                              );
                                            } else {
                                              return processing;
                                            }
                                          }),
                                    );
                                  });
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.lock,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Online :',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Cairo'),
                                ),
                                Text(
                                  userCount.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Cairo'),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(.2),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Colors.pink,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Lv.',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '1',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Heart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(.2),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.solidEdit,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Lv.',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '1',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Heart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: FutureBuilder<List<User>>(
                      future: getSeatUsers(),
                      builder: (context, snapshot) {
                        print(snapshot.hasData);
                        if (snapshot.hasData) {
                          return GridView.builder(
                            addAutomaticKeepAlives: false,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              childAspectRatio: .7,
                            ),
                            itemBuilder: (context, index) {
                              if (snapshot.data[index].userId == 'none') {
                                if (snapshot.data[index].isLocked == false) {
                                  return _childPopupp(
                                      snapshot.data[index].seatId,
                                      Icon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.deepPurple[500],
                                        size: 15,
                                      ));
                                } else {
                                  return _childPopupp(
                                      snapshot.data[index].seatId,
                                      Icon(
                                        FontAwesomeIcons.userLock,
                                        color: Colors.deepPurple[500],
                                        size: 15,
                                      ));
                                }
                              } else {
                                if (snapshot.data[index].adminMute) {
                                  return _childPopupp(
                                    snapshot.data[index].seatId,
                                    Column(
                                      children: <Widget>[
                                        Image.network(
                                            snapshot.data[index].userPhoto),
                                        Text(
                                          'admin_mute',
                                          style: TextStyle(fontSize: 3),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.data[index].userMute) {
                                  return _childPopupp(
                                    snapshot.data[index].seatId,
                                    Column(
                                      children: <Widget>[
                                        Image.network(
                                            snapshot.data[index].userPhoto),
                                        Text(
                                          'user mute',
                                          style: TextStyle(fontSize: 3),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return _childPopupp(
                                    snapshot.data[index].seatId,
                                    Image.network(
                                        snapshot.data[index].userPhoto),
                                  );
                                }
                              }
                            },
                            itemCount: 8,
                          );
                        } else {
                          return processing;
                        }
                      }),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(.2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "send a message...",
                    hintStyle:
                        TextStyle(color: Colors.black12.withOpacity(.2))),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.attach_file,
              ),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.alternate_email),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
