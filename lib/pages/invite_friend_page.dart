import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class InviteFriendPage extends StatefulWidget {
  String userId;
  InviteFriendPage(this.userId);
  @override
  _InviteFriendPageState createState() => _InviteFriendPageState();
}

class _InviteFriendPageState extends State<InviteFriendPage> {
  String followingUserId;
  bool isfollowing = false;
  CollectionReference _collectionReference = Firestore.instance.collection('users');

  isUserAlreadyFollowing() async{
    DocumentSnapshot documentSnapshot= await _collectionReference.document(widget.userId).collection('following').document(followingUserId).get();
    if(documentSnapshot.exists){
      setState(() {
        isfollowing = true;
      });

    }else{
      setState(() {
        isfollowing = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserAlreadyFollowing();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(isfollowing == true ? 'following' : 'unfollow'),
            TextField(
              onChanged: (value){
                followingUserId = value;
              },
            ),
            FlatButton(
              onPressed: (){
                print(widget.userId);
                print(followingUserId);

                if(!isfollowing) {
                  _collectionReference.document(widget.userId).collection(
                      'followers').document(followingUserId).setData({
                    'user_id': followingUserId,
                  });
                  _collectionReference.document(followingUserId).collection(
                      'following').document(widget.userId).setData({
                    'user_id': widget.userId,
                  });
                }else{
                  print('already');
                }
              },
              child: Text('follow'),
            )
          ],
        ),
      ),
    );
  }
}
