import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/Question.dart';
import 'package:my_stackoverflow/modle/myQuestionKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class AddQuestion extends StatefulWidget {
  @override
  AddQuestionState createState() => AddQuestionState();
}

class AddQuestionState extends State<AddQuestion> {

  String email;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  var _formKey = GlobalKey<FormState>();
  Question createQuestion;
  String userKey;


  @override
  void initState() {
    super.initState();
    getSharedPreference();
    databaseReference = database.reference().child("Questions");
    createQuestion = new Question("", "", "", null,0,0,null,null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        centerTitle: true,
        title: new Text(
          "Add a question",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            new Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      validator: (value){
                        if(value.length == 0){
                          return "Invalid question";
                        }
                      },
                      onSaved: (value){
                        createQuestion.question = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the Question",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      //obscureText: true,
                      validator: (value){

                        if(value.length == 0){
                          return "Description cannot be empty";
                        }
                      },
                      onSaved: (value){
                        createQuestion.description = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the description",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        //errorText: incorrectPassword ? "User email or password is incorrect":null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: addQuestionButton ,
                    color: Color.fromRGBO(52, 66, 86, 1),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    textColor: Colors.white70,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getSharedPreference() async{
    final prefs = await SharedPreferences.getInstance();   //save username
    if(prefs.getString('userEmail') == null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
      );
    }else{
      email =  prefs.getString('userEmail');
      userKey = prefs.getString('userKey');
    }
  }

  void addQuestionButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      createQuestion.user = userKey;
        uploadQuestion();
    }
  }

  void uploadQuestion(){
    String questionKey = databaseReference.push().key;
    databaseReference.child(questionKey).set(createQuestion.toJson());
    //add a question key to owners qustionList
    MyQuestionKey myQuestionKey = new MyQuestionKey(questionKey);
    database.reference().child('userDetails').child(userKey).child('myQuestionList').child(questionKey).set(myQuestionKey.toJson());
      

    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new Home();
        });
    Navigator.of(context).push(router);
  }
}
