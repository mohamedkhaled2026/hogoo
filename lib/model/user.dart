import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String userId;
  String userName;
  String userEmail;
  String userPhone;
  String userPhoto;
  String providerId;
  String userGender;
  Timestamp birthDate;
  String userStatus;
  int diamonds;
  int beans;
  int carisma;
  int wealthLevel;
  int seatId;
  bool isLocked;
  bool adminMute;
  bool userMute;

  User({this.userId,this.userName,this.userEmail,this.userPhone,this.userPhoto,this.providerId,this.userGender,this.birthDate,this.userStatus,this.diamonds,this.beans,this.carisma,this.wealthLevel});

  factory User.fromDocument(Map m){
    return User(
      userId: m['user_id'],
      userName: m['user_name'],
      userEmail: m['user_email'],
      userPhone: m['user_phone'],
      userPhoto: m['user_photo'],
      providerId: m['provider_id'],
      userGender: m['user_gender'],
      birthDate: m['birth_date'],
      userStatus: m['user_status'],
      diamonds: m['diamond'],
      beans: m['beans'],
      carisma: m['carisma'],
      wealthLevel: m['wealth_level'],
    );
  }
  dynamic toMap(){
    return {
      'user_id' : this.userId,
      'user_name' : this.userName,
      'user_email' : this.userEmail,
      'user_phone' : this.userPhone,
      'user_photo' : this.userPhoto,
      'provider_id' : this.providerId,
      'user_gender' : this.userGender,
      'birth_date' : this.birthDate,
      'user_status' : this.userStatus,
      'diamond' : this.diamonds,
      'beans' : this.beans,
      'carisma' : this.carisma,
      'wealth_level' : this.wealthLevel,
    };
  }

}