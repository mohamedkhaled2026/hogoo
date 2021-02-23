import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hogoo/config/sign_in_methods.dart';
import 'package:hogoo/model/user.dart';
import 'package:hogoo/pages/create_room_page.dart';
import 'package:hogoo/pages/invite_friend_page.dart';
import 'package:hogoo/pages/login_page.dart';
import 'package:hogoo/pages/party_page.dart';

class ProfilePage extends StatefulWidget {
  User _currentUser;
  ProfilePage(this._currentUser);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget holder;
  int _currentIndex = 0;
  SignInMethods signInMethods = SignInMethods();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    holder = Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(

                    image:widget._currentUser.providerId =='phone'? NetworkImage(widget._currentUser.userPhoto) : NetworkImage(widget._currentUser.userPhoto+"?height=500"),
                    fit: BoxFit.fill
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(widget._currentUser.userName,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Text('ID : ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),),
                          Text(widget._currentUser.userId,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),),
                        ],
                      )

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(right: 8.0,left: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[

                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text('0',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text('0',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text('0',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[

                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text('Fans',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text('Following',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text('Friends',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              thickness: 3,
              color: Colors.black38,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return InviteFriendPage(widget._currentUser.userId);
                }));
              },
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.share,
                  color: Colors.grey,
                ),
                title: Text(
                  'Invite Friends',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CreateRoomPage(widget._currentUser.userId);
                }));
              },
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.shopify,
                  color: Colors.grey,
                ),
                title: Text(
                  'Privilage Shop',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: Colors.grey,
              ),
              title: Text(
                'Wallet',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.cog,
                color: Colors.grey,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.solidQuestionCircle,
                color: Colors.grey,
              ),
              title: Text(
                'Help Center',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                signInMethods.googleSignout();
                signInMethods.facebookSignout();
                Navigator.pushReplacement(context, MaterialPageRoute( builder: (context){
                  return LoginPage();
                }));
              },
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.userShield,
                  color: Colors.grey,
                ),
                title: Text(
                  'Rules and Policies',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 40, 40, 1.0),
      body: holder,
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1.0),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          //currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidUserCircle,size: 25,),
              title: Text("Me", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.facebookMessenger,size: 25),
              title: Text("Message", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.discourse,size: 25),
              title: Text("Discover", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gift,size: 25),
              title: Text("party", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
          ],
          onTap: (index){
            setState(() {
              _currentIndex = index;
              if(index == 0){
                  holder = Directionality(
                    textDirection: TextDirection.ltr,
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(

                                  image:widget._currentUser.providerId =='phone'? NetworkImage(widget._currentUser.userPhoto) : NetworkImage(widget._currentUser.userPhoto+"?height=500"),
                                  fit: BoxFit.fill
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 20,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(widget._currentUser.userName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: <Widget>[
                                        Text('ID : ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        Text(widget._currentUser.userId,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                      ],
                                    )

                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(right: 8.0,left: 8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[

                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text('0',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text('0',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text('0',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[

                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text('Fans',
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text('Following',
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text('Friends',
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 20,
                            thickness: 3,
                            color: Colors.black38,
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return InviteFriendPage(widget._currentUser.userId);
                              }));
                            },
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.share,
                                color: Colors.grey,
                              ),
                              title: Text(
                                'Invite Friends',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return CreateRoomPage(widget._currentUser.userId);
                              }));
                            },
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.shopify,
                                color: Colors.grey,
                              ),
                              title: Text(
                                'Privilage Shop',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.grey,
                            ),
                            title: Text(
                              'Wallet',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              FontAwesomeIcons.cog,
                              color: Colors.grey,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              FontAwesomeIcons.solidQuestionCircle,
                              color: Colors.grey,
                            ),
                            title: Text(
                              'Help Center',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              signInMethods.googleSignout();
                              signInMethods.facebookSignout();
                              Navigator.pushReplacement(context, MaterialPageRoute( builder: (context){
                                return LoginPage();
                              }));
                            },
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.userShield,
                                color: Colors.grey,
                              ),
                              title: Text(
                                'Rules and Policies',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              }
              else if(index ==1){

              }
              else if(index ==2){

              }
              else if(index ==3){
                holder = PartyPage();
              }
            });

          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
