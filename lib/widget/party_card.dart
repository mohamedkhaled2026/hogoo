import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PartyCard extends StatelessWidget {
  final String img;
  final String memberNum;
  final String title;
  final Color setColor1;
  final Color setColor2;
  final Function press;
  const PartyCard({
    Key key,
    this.img,
    this.title,
    this.press,
    this.memberNum,
    this.setColor1,
    this.setColor2,
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              setColor1,
              setColor2,
            ],
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    "https://googleflutter.com/sample_image.jpg",
                  height: 100,
                  width: 100,),
                ),
                SizedBox(height: 10,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 100,
                    height: 30,
                    color: Colors.black12.withOpacity(.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.supervisor_account,
                        color: Colors.white),
                        Text(
                          memberNum,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 2,
                        left: 2,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            "https://googleflutter.com/sample_image.jpg",
                            height: 30,
                            width: 30,),
                        ),
                      ),
                    ],
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}


