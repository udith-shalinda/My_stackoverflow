
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/Answer.dart';
import 'package:my_stackoverflow/modle/Question.dart';
import 'package:my_stackoverflow/modle/votes.dart';
import 'package:my_stackoverflow/ui/userdetailsform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddQuestion.dart';
import 'giveAnswer.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference,databaseReferenceTwo;
  List<Answer> answerlist;
  String email;

  
  List<String> upVoters = new List();
  List<String> downVoters = new List();

  @override
  void initState() {
    super.initState();
    getSharedPreference();
    databaseReference = database.reference().child("Questions");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Color.fromRGBO(52, 66, 86, .7),
              drawer: Drawer(
                child:Container(
                  color: Color.fromRGBO(52, 66, 86, .9),
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(52, 66, 86, 1),
                        ),
                        child: new CircleAvatar(
                          radius: 45.0,
                          child: new Icon(Icons.person_outline,size: 55,color: Colors.white,),
                        ),
                      ),
                      Text("sfsfss"),
                      IconButton(
                        icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 34,
                        ),
                        onPressed: editProfile,
                      )
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
              backgroundColor: Color.fromRGBO(56, 66, 86, 1),
              centerTitle: true,
              title: new Text(
                "Home",
                style: TextStyle(
                  fontSize: 25,
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
                  child : new ListView(
                    children: <Widget>[
                      new Container(
                        height:  MediaQuery.of(context).size.height-50,
                        child: new FirebaseAnimatedList(
                            query: databaseReference,
                            itemBuilder: (_, DataSnapshot snapshot,Animation<double> animation , int index){
                              return new Card(
                                  elevation: 8.0,
                                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  child: new Container(
                                    decoration: BoxDecoration(color: Colors.white),
                                    child: new ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                                      leading: Container(
//                                        padding: EdgeInsets.only(right: 12.0),
////                                        decoration: new BoxDecoration(
////                                            border: new Border(
////                                                right: new BorderSide(width: 1.0, color: Colors.white24))),
//                                        child: CircleAvatar(
//                                          radius: 30.0,
//                                          backgroundColor: Colors.white,
//                                          child: new Text(snapshot.value['email'].substring(5,10)),
//                                        ),
//                                      ),
                                      title: Align(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child:Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: Colors.black,
                                                child: new Text(snapshot.value['email'].substring(5,10)),
                                              ),
                                              Text(
                                                "   "+snapshot.value['email'].toString(),
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ],
                                          )
                                        ),
                                        alignment: FractionalOffset.topLeft,
                                      ),
                                      subtitle: Container(
                                        alignment: FractionalOffset.topLeft,
                                        padding: EdgeInsets.only(top: 30),
                                        child:Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child:voteupdown(snapshot),
                                                ),
                                                Flexible(
                                                  child: questionandAnswer(snapshot),
                                                ),
                                              ],
                                            ),
                                            buttonSet(snapshot),
                                          ],
                                        ),
                                      ),
                                      //trailing: voteupdown(),

                                      onTap: (){
                                        showQuestion(snapshot.key);
                                      },
                                    ),
                                  )
                              );
                            }
                        ),
                      ),
                    ],
                  )
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: addAQuestion,
                //add a date
                child: Icon(Icons.add,
                  color: Colors.pinkAccent,),
                backgroundColor: Colors.white,
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
    }
  }

  Widget voteupdown(DataSnapshot snapshot){
    String upVoted = "";
    String downVoted = "";
    int voters;
    Question question = Question.fromSnapshot(snapshot);
    voters = question.votes;
    
  
    Map<dynamic,dynamic> mapUpVote = new Map();
      if(snapshot.value['upVoters'] != null){
        mapUpVote = snapshot.value['upVoters'];
        mapUpVote.forEach((key,vote){
          if(vote['userEmail'] == email){
            upVoted = key;
          }
      });
    }
    if(snapshot.value['downVoters'] != null){
        Map<dynamic,dynamic> mapDownVote = new Map();
        mapDownVote = snapshot.value['downVoters'];
        mapDownVote.forEach((key,vote){
          if(vote['userEmail'] == email){
            downVoted = key;
          }
        });
    }
    
    
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            iconSize: 50,
            color: upVoted != "" ? Colors.orange : Colors.blueGrey,
            onPressed: (){
              if(upVoted == ""){
                if(downVoted != ""){
                    databaseReference.child(snapshot.key).child('upVoters').child(downVoted).remove();              
                }else{
                    Votes vote = new Votes(email);
                    databaseReference.child(snapshot.key).child('upVoters').push().set(vote.toJson());              
                    databaseReference.child(snapshot.key).child('votes').set(++snapshot.value['votes']);
                }
              }
            },
          ),
          Text(
            voters.toString(),
              style: TextStyle(
                fontSize: 25
              ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 50,
            color: downVoted != "" ? Colors.orange : Colors.blueGrey,
            onPressed: (){
              if(downVoted == ""){
                  if(upVoted != ""){
                    databaseReference.child(snapshot.key).child('upVoters').child(upVoted).remove();
                  }else{
                    Votes vote = new Votes(email);
                    databaseReference.child(snapshot.key).child('downVoters').push().set(vote.toJson());
                    databaseReference.child(snapshot.key).child('votes').set(--snapshot.value['votes']);
                  }
              }
            },
          )
        ],
      ),
    );
  }


  Widget questionandAnswer(DataSnapshot snapshot){
      return Column(
        children: <Widget>[
          Container(
            child: Text(
              snapshot.value['question'].toString(),
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 25),
            ),
          ),
          Text(
            snapshot.value['question'].toString(),
            style: TextStyle(color: Colors.blueGrey, fontSize: 15),
          ),
        ],
      );
  }
  Widget buttonSet(DataSnapshot snapshot){
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Text("votes :" + snapshot.value['votes'].toString()),
          ),
        ),
        Container(
          color: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
          child: Text("Answers : "+ snapshot.value['answercount'].toString()),
        ),
      ],
    );
  }
  void editProfile(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new UserDetailsForm();
        });
    Navigator.of(context).push(router);
  }
  void addAQuestion(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new AddQuestion();
        });
    Navigator.of(context).push(router);
  }
  void showQuestion(String key){
    print("key is "+key);
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new GiveAnswer(QuestionKey: key,);
        });
    Navigator.of(context).push(router);
  }
}
