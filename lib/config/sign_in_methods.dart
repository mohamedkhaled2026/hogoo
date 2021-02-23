import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignInMethods{
  final googleSignin = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  String verificationId;
  bool isSMSsent = false;
  AuthCredential authCredential;

  Future<UserInfo> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      // Create a new credential
       authCredential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);


      // Once signed in, return the UserCredential
      final FirebaseUser user = (await _auth
          .signInWithCredential(authCredential));
      UserInfo userProfile ;
      for (UserInfo profile in user.providerData) {
        // check if the provider id matches "facebook.com"
        if (GoogleAuthProvider.providerId == profile.providerId) {
          userProfile = profile;

          print(userProfile.uid);
        }
      }
      return userProfile;
    }catch(e){
      print(e);
    }

  }

  void googleSignout(){
    _auth.signOut();
    googleSignin.signOut();
  }

  Future<UserInfo> signInWithFacebook() async {
    //final result = await facebookLogin.logInWithReadPermissions(['email','public_profile']);
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    print(result.accessToken);
    print(result.errorMessage);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        authCredential = FacebookAuthProvider
            .getCredential(accessToken: result.accessToken.token);
        final FirebaseUser user = (await _auth
            .signInWithCredential(authCredential));
        UserInfo userProfile ;
        for (UserInfo profile in user.providerData) {
          // check if the provider id matches "facebook.com"
          if (FacebookAuthProvider.providerId == profile.providerId) {
            userProfile = profile;
          }
        }
        return userProfile;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelled');
        break;
      case FacebookLoginStatus.error:
        print('error');
        print(result.errorMessage);
        break;
    }
  }

  void facebookSignout(){
    _auth.signOut();
    facebookLogin.logOut();
  }

  signInWithPhone(String phoneNumber)async{
    final PhoneCodeAutoRetrievalTimeout autoRetrieval=(String verId){
      verificationId=verId;
      print('Timeout');
    };

    final PhoneCodeSent smsCodeSent=(String verId, [int forceCodeResend]){
      verificationId=verId;
      print("Signed in");
    };

    final PhoneVerificationCompleted verificationCompleted = (AuthCredential credential) {
      print('verified');
    };



    final PhoneVerificationFailed verfifailed=(AuthException exception){
      print("${exception.message}");
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeAutoRetrievalTimeout: autoRetrieval,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verfifailed
    );
  }

  Future<FirebaseUser> verifyPhone(smsCode) async{
    try {
      authCredential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: smsCode);
      final FirebaseUser user = (await _auth.signInWithCredential(authCredential));
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      if (user != null) {
          return user;
      } else {
          print('fail');
          return null;
      }
    }catch(e){
        print(e.toString());
    }
  }

  phoneSignout(){
    _auth.signOut();
  }






}