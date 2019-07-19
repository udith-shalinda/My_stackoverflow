import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class profilePage extends StatefulWidget {

  final String questionUserKey;
  profilePage({Key  key, this.questionUserKey}):super(key:key);

  @override
  profilePageState createState() => profilePageState();
}

class profilePageState extends State<profilePage> {

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
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: (){},
                  ),
                  Text(
                    user.name,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.github),
                    onPressed: (){},
                  ),
                  Text(
                    user.github,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.linkedin),
                    onPressed: (){},
                  ),
                  Text(
                    user.linkedin,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.questionCircle),
                    onPressed: (){},
                  ),
                  Text(
                    noOfUserQuestions.toString(),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.handPointer),
                    onPressed: (){},
                  ),
                  Text(
                    "Points : "+user.points.toString(),
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
        width: 135.0,
        height: 190.0,
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