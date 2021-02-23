import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hogoo/config/firebase_helper.dart';
import 'package:hogoo/model/chat_room.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/create_room_page.dart';
import 'package:hogoo/pages/room_page.dart';
import 'package:hogoo/widget/party_card.dart';

class PartyPage extends StatefulWidget {
  @override
  _PartyPageState createState() => _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  Widget processing = Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.deepPurple,
      ));

  Future<List<ChatRoom>> getChatRooms() async{
    List<ChatRoom> chatRooms = List<ChatRoom>();
    QuerySnapshot querySnapshot = await _firebaseHelper.chatRoomCollectionReferance.getDocuments();
    List<DocumentSnapshot> docList  = querySnapshot.documents;
    int userCount=0;
    for(DocumentSnapshot doc in docList){

      QuerySnapshot querySnapshot = await _firebaseHelper.chatRoomCollectionReferance.document(doc.data['room_name'] + doc.data['room_owner_id']+doc.data['room_id']).collection('room_users').getDocuments();
      int counter = 0;
      for(DocumentSnapshot documentSnapshot in querySnapshot.documents){
        if(documentSnapshot.data['user_id'] != 'none'){
          counter++;
        }
      }
      userCount = counter;
      ChatRoom chatRoom = ChatRoom.fromDocument(doc.data);
      chatRoom.onlineUserCount = userCount;
      chatRooms.add(chatRoom);
    }
    return chatRooms;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Party',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ),
              Tab(
                child: Text(
                  'Live',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(.2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: IconButton(
              icon: Icon(Icons.add_circle_outline,color:Colors.deepOrange,),
              onPressed: ()async{
                User currentUser = await _firebaseHelper.getCurrentUser();
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CreateRoomPage(currentUser.userId);
                }));
              },
            ),
          ),
          body: TabBarView(children: [
            //Party
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                child: FutureBuilder<List<ChatRoom>>(
                  future: getChatRooms(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        addAutomaticKeepAlives: false,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: .7,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async{
                              User currentUser = await _firebaseHelper.getCurrentUser();
                              if(currentUser.userId == snapshot.data[index].roomOwnerId){
                                QuerySnapshot querySnapshot = await _firebaseHelper.chatRoomCollectionReferance
                                    .document(snapshot.data[index].roomName + snapshot.data[index].roomOwnerId+snapshot.data[index].roomId)
                                    .collection('room_users').getDocuments();
                                for(DocumentSnapshot doc in querySnapshot.documents){
                                  if(doc.data['seat_id'] == 1){
                                    doc.reference.updateData({'user_id': currentUser.userId,
                                      'seat_id': 1,
                                      'admin_mute': false,
                                      'user_mute': false,
                                    'is_locked':false});
                                  }
                                }
                              }else {
                                _firebaseHelper.chatRoomCollectionReferance
                                    .document(snapshot.data[index].roomName + snapshot.data[index].roomOwnerId+snapshot.data[index].roomId)
                                    .collection('room_users').document()
                                    .setData({
                                  'user_id': currentUser.userId,
                                  'seat_id': 0,
                                  'admin_mute': true,
                                  'user_mute': true,
                                });
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return RoomPage(snapshot.data[index]);
                              }));
                            },
                            child: PartyCard(
                              setColor1: Colors.deepOrange,
                              setColor2: Colors.pink,
                              img: "https://googleflutter.com/sample_image.jpg",
                              memberNum: snapshot.data[index].onlineUserCount.toString(),
                              title: snapshot.data[index].roomName,
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return processing;
                    }
                  },
                ),
              ),
            ),
            //Live
            Container(
              child: Text(
                'live',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
