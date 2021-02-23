import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hogoo/model/user.dart';

class FirebaseHelper{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollectionReferance = Firestore.instance.collection('users');
  final CollectionReference chatRoomCollectionReferance = Firestore.instance.collection('chat_rooms');


  Future<User> getUserInfo(String userId) async {
    if(userId != 'none') {
      DocumentSnapshot documentSnapshot =
      await userCollectionReferance.document(userId).get();
      return User.fromDocument(documentSnapshot.data);
    }else{
      return User(userId: 'none');
    }
  }

  Future<User> getCurrentUser() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser != null) {
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
      User currentUser = await getUserInfo(userId);
      return currentUser;
    } else {
      print('no user');
      return null;
    }
  }

}