import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:my_stackoverflow/ui/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';



class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  
  

  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("userDetails");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
            "Search",
            style: TextStyle(
              fontSize: 25,
            ),
        ),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          Text("hello"),
        ],
      ),
    );
  }
 
  
}
