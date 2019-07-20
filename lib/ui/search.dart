import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/Question.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:my_stackoverflow/ui/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'giveAnswer.dart';
import 'home.dart';



class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  var searchKey = new TextEditingController();
  String filter;
  List<Question> questionList = new List();
  
  

  @override
  void initState() {
    super.initState();
    searchKey.text = "";
    databaseReference = database.reference().child("Questions");
    databaseReference.onChildAdded.listen(setQuestions);
    // filter = "";
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
      body:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: TextField(
              controller: searchKey,
              decoration: InputDecoration(
              suffixIcon:IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: searchButtonPressed,
                ),
                hintText: "Enter the Name",
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
          //start of the result
          resultBody(),
        ],

      ),




    );
  }
  void setQuestions(Event event){
    questionList.add(Question.fromSnapshot(event.snapshot));
  }
  Widget testSearchResult(){
    return Flexible(
            child: FirebaseAnimatedList(
              query: database.reference().child("Questions"),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return  questionList[index].question.contains(filter) || questionList[index].description.contains(filter) ? ListTile(
                  leading: Icon(Icons.message),
                  title: Text(
                    questionList[index].question,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  subtitle: Text
                  (questionList[index].description,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onTap:(){
                     showQuestion(questionList[index].key);
                  },
                ) : new Container();
              },
            ),
          );
  }
 
 
  Widget resultBody(){
    if(filter != null){
      return testSearchResult();
    }else{
      return Center(
        child: Text("Search a question"),
        );
    }
  }

  void showQuestion(String key){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new GiveAnswer(questionKey: key);
        });
    Navigator.of(context).push(router);
  }
  
  searchButtonPressed(){
    setState(() {
     filter = searchKey.text; 
    });
  }
}
