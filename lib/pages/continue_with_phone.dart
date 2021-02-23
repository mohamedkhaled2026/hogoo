import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hogoo/config/sign_in_methods.dart';
import 'package:hogoo/pages/verifty_phone.dart';
import 'package:hogoo/widget/numeric_pad.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class ContinueWithPhone extends StatefulWidget {
  @override
  _ContinueWithPhoneState createState() => _ContinueWithPhoneState();
}

class _ContinueWithPhoneState extends State<ContinueWithPhone> {
  String phoneNumber = "";
  final SignInMethods signInMethods = SignInMethods();
  bool isProgress = false;
  // final TextEditingController controller = TextEditingController();
  // String initialCountry = 'NG';
  // PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return ModalProgressHUD(
      inAsyncCall: isProgress,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              size: 30,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Continue with phone",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
        ),
        body: SafeArea(
            child: Column(
              children: <Widget>[
                //Image and Text
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.7, 0.9],
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFF7F7F7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(
                          height: 140,
                          child: Image.asset(
                              'assets/images/holding-phone.png'
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                          child: Text(
                            "You'll receive a 6 digit code to verify next.",
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF818181),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                //phone number and Continue Button
                Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    // Row of phone number and Continue Button
                    child: Row(
                      children: <Widget>[
                        //Text of phone number
                        Container(
                          width: 230,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Text(
                                "Enter your phone",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(
                                height: 8,
                              ),

                              Row(
                                children: <Widget>[
                                  // InternationalPhoneNumberInput(
                                  //   onInputChanged: (PhoneNumber number) {
                                  //     print(number.phoneNumber);
                                  //   },
                                  //   onInputValidated: (bool value) {
                                  //     print(value);
                                  //   },
                                  //   ignoreBlank: false,
                                  //   autoValidate: false,
                                  //   selectorTextStyle: TextStyle(color: Colors.black),
                                  //   initialValue: number,
                                  //   textFieldController: controller,
                                  //   inputBorder: OutlineInputBorder(),
                                  // ),
                                  Text(
                                    phoneNumber,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        // Continue Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              setState(() {
                                isProgress = true;
                              });
                              await signInMethods.signInWithPhone('+2'+phoneNumber);
                              setState(() {
                                isProgress = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VerifyPhone(phoneNumber: phoneNumber,signInMethods: signInMethods,)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFd0325f),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                //Number Bord
                NumericPad(
                  onNumberSelected: (value) {
                    setState(() {
                      if(value != -1){
                        phoneNumber = phoneNumber + value.toString();
                      }
                      else{
                        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
                      }
                    });
                  },
                ),

              ],
            )
        ),
      ),
    );
  }
}