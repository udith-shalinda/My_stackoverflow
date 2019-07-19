
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';


class ProfilePage extends StatefulWidget {

  final String questionUserKey;
  ProfilePage({Key  key, this.questionUserKey}):super(key:key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  String key;
  String useremail;


  User user = new User("","","","",0,"");
  int noOfUserQuestions = 0;



  @override
  void initState() {
    super.initState();
    getSharedPreference();
    databaseReference = database.reference().child("userDetails");
    databaseReference.onChildAdded.listen(_getUserDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52,66,86,.7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56,66,86,1),
        centerTitle: true,
        title: new Text(
          "User Details",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
          child: new ListView(
            children: <Widget>[
              CircleAvatar(
                radius: 65.0,
                child: profileImage(),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        Icons.person,
                        color: Colors.white,
                    ),
                    onPressed: (){},
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        FontAwesomeIcons.github,
                        color: Colors.white,
                    ),
                    onPressed: (){},
                  ),
                  Text(
                    user.github,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.white,
                    ),
                    onPressed: (){},
                  ),
                  Text(
                    user.linkedin,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.questionCircle,
                      color: Colors.white,
                    ),
                    onPressed: (){},
                  ),
                  Text(
                    noOfUserQuestions.toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        FontAwesomeIcons.handPointer,
                        color: Colors.white,
                    ),
                    onPressed: (){},
                  ),
                  Text(
                    "Points : "+user.points.toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),

                  ),
                ],
              ),
            ],
          )
      ),
    );
  }

  void getSharedPreference() async {
    final prefs = await SharedPreferences.getInstance(); //save username
    if (prefs.getString('userEmail') == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );
    } else {
      useremail = prefs.getString('userEmail');
      //userKey = prefs.getString("userKey");
    }
  }

  _getUserDetails(Event event) {
    if (event.snapshot.key == widget.questionUserKey) {
      print(widget.questionUserKey);
      setState(() {
        user = User.fromSnapshot(event.snapshot);
        if(event.snapshot.value['myQuestionList'] != null){
          setState(() {
            noOfUserQuestions =  event.snapshot.value['myQuestionList'].length;
          });
        }
      });
    }
  }

  Widget profileImage() {
    if (user.profileLink != null) {
      return Container(
        width: 130.0,
        height: 130.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(
                user.profileLink
            ),
          ),
        ),
      );
    } else {
      return Icon(Icons.person);
    }
  }
}