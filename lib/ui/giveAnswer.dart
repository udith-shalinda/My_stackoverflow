import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/Answer.dart';
import 'package:my_stackoverflow/modle/Question.dart';
import 'package:my_stackoverflow/modle/votes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class GiveAnswer extends StatefulWidget {

  String QuestionKey;
  GiveAnswer({Key  key, this.QuestionKey}):super(key:key);


  @override
  _GiveAnswerState createState() => _GiveAnswerState();
}

class _GiveAnswerState extends State<GiveAnswer> {

  Question question;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  bool addAnswer = false;
  var answer = new TextEditingController();
  var answerDescription = new TextEditingController();
  Answer finalAnswer = new Answer("","",0);
  List<Answer> answerList = new List();
  List<Votes> voteList = new List();
  String email;
  String upVoted= "";
  String downVoted = "";
  int questionVotes =0;


  @override
  void initState() {
    super.initState();
    getSharedPreference();
    question = new Question("fsfs", "", "", null,0,0,null);
    databaseReference = database.reference().child("Questions");
    databaseReference.onChildAdded.listen(setQuestion);
    databaseReference.child(widget.QuestionKey).child("answer").onChildAdded.listen(setAnswers);
    databaseReference.child(widget.QuestionKey).child("questionVotes").onChildAdded.listen(setVotes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        centerTitle: true,
        title: new Text(
          "question page",
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
            Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  title: Container(
                      padding: EdgeInsets.only(top: 10),
                      child:Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.black,
                            child: new Text("sgsfsf"),
                          ),
                          Text(
                            "  " + question.email,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )
                  ),
                  subtitle: Container(
                      alignment: FractionalOffset.topRight,
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                  Flexible(
                                    child: voteupdownQuestion(question.key,question.votes),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          question.question,
                                          style: TextStyle(color: Colors.blueAccent, fontSize: 35),
                                        ),
                                        Text(
                                          question.description,
                                          style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          displayAnswer(),
                          Container(
                            child: addAnswer ? answerForm() : RaisedButton(
                                    child: Text("Add an answer"),
                                    onPressed: addAnswerButtonClicked,
                            )
                          )
                        ],
                      ),
                  ),

                ),
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
    }
  }

  void setQuestion(Event event){
    if(event.snapshot.key == widget.QuestionKey){
      setState(() {
        question = Question.fromSnapshot(event.snapshot);
      });
    }
  }
  void setAnswers(Event event){
    setState(() {
      answerList.add(Answer.fromSnapshot(event.snapshot));
    });
  }
  void setVotes(Event event){
      Votes oneVote = Votes.fromSnapshot(event.snapshot);
      voteList.add(oneVote);
      if(oneVote.updown ==1 ){
        questionVotes++;
        if(oneVote.userEmail == email){
          upVoted = oneVote.key;
        }
      }else{
        questionVotes--;
        if(oneVote.userEmail == email){
          downVoted = oneVote.key;
        }
      }
  }
  
  Widget voteupdownQuestion(String key,int votes){
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            iconSize: 50,
            color: upVoted != "" ? Colors.orange: Colors.blueGrey,
            onPressed: (){
              Votes newVote = new Votes(1, email);
              setState(() {
                if(upVoted == ""){
                  databaseReference.child(key).child('questionVotes').push().set(newVote.toJson());
                  databaseReference.child(key).child('votes').set(votes++);
                  question.votes++;
                }
              });
            },
          ),
          Text(
            questionVotes.toString(),
            style: TextStyle(
                fontSize: 25
            ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 50,
            color: downVoted != "" ? Colors.orange:Colors.blueGrey,
            onPressed: (){
              if(upVoted != ""){
                databaseReference.child(key).child("questionVotes").child(upVoted).remove();
              }else if(downVoted == ""){
                Votes vote = new Votes(-1, email);
                databaseReference.child(key).child("questionVotes").push().set(vote.toJson());
              }
              databaseReference.child(key).child('votes').set(votes--);
              setState(() {
                question.votes--;
              });
              },
          )
        ],
      ),
    );
  }

  Widget voteupdownAnswers(int answerIndex){
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            iconSize: 50,
            color: Colors.blueGrey,
            onPressed: (){
              setState(() {
                databaseReference.child(widget.QuestionKey).child("answer")
                    .child(answerList[answerIndex].key).child("votes").set(answerList[answerIndex].votes++);
              });
            },
          ),
          Text(
            answerList[answerIndex].votes.toString(),
            style: TextStyle(
                fontSize: 25
            ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 50,
            color: Colors.blueGrey,
            onPressed: (){
              setState(() {
                databaseReference.child(widget.QuestionKey).child("answer")
                    .child(answerList[answerIndex].key).child("votes").set(answerList[answerIndex].votes--);
              });
            },
          )
        ],
      ),
    );
  }

  Widget displayAnswer(){
    if(answerList.length == 0){
      return Container();
    }
    return Container(    //answers shown here;
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: ListView.builder(
          itemCount: answerList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Row(
              children: <Widget>[
                Flexible(
                  child: voteupdownAnswers(index),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      new Text(
                          answerList[index].answer,
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 22,
                          ),
                      ),
                      new Text(
                          answerList[index].comment,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
      )
    );
  }

  Widget answerForm(){
    return Column(
      children: <Widget>[
        TextField(
          controller: answer,
          decoration: new InputDecoration(
              labelText: "Enter your answer"
          ),
        ),
        TextField(
          controller: answerDescription,
          decoration: new InputDecoration(
              labelText: "Enter your answer"
          ),
        ),
        RaisedButton(
          onPressed: postAnswer,
          child: Text("post it"),
        ),
      ],
    );
  }
  void addAnswerButtonClicked(){
    setState(() {
      addAnswer = true;
    });
  }
  void postAnswer(){
    if(answer.text.length != 0){
      setState(() {
        addAnswer = false;
      });

      finalAnswer.answer = answer.text;
      finalAnswer.comment = answerDescription.text;
      databaseReference.child(widget.QuestionKey).child("answer").push().set(finalAnswer.toJson());
      databaseReference.child(widget.QuestionKey).child('answercount').set(++question.answercount);
    }
  }
}
