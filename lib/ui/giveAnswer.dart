import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/Answer.dart';
import 'package:my_stackoverflow/modle/Question.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:my_stackoverflow/modle/votes.dart';
import 'package:my_stackoverflow/ui/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class GiveAnswer extends StatefulWidget {

  final String questionKey;
  GiveAnswer({Key  key, @required this.questionKey}):super(key:key);


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
  Answer finalAnswer = new Answer("","",0,null,null,'');
  List<Answer> answerList = new List();
  String upVoted= "";
  String downVoted = "";
  String profileLink;
  String userName;
  bool isMyQuestion = false;

  String email;
  String userKey;

  
  int questionVotes =0;
  


  @override
  void initState() {
    super.initState();
    getSharedPreference();
    question = new Question("fsfs", "", "", null,0,0,null,null);
    databaseReference = database.reference().child("Questions");
    databaseReference.onChildAdded.listen(setQuestion);
    databaseReference.child(widget.questionKey).child("answer").onChildAdded.listen(setAnswers);
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
                            child: profileImage(),
                          ),
                          GestureDetector(
                            onTap: (){
                              goToProfile(question.user);
                            },
                            child: Text(
                              userName!= null? "  " + userName:(" " + question.user),
                              style: TextStyle(color: Colors.black),
                            ),
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
      userKey = prefs.getString('userKey');
    }
  }

  void setQuestion(Event event){
    if(event.snapshot.key == widget.questionKey){
      // setState(() {
        question = Question.fromSnapshot(event.snapshot);
      // });
        Map<dynamic,dynamic> mapUpVote = new Map();
        if(event.snapshot.value['upVoters'] != null){
          mapUpVote = event.snapshot.value['upVoters'];
          mapUpVote.forEach((key,vote){
            if(vote['userEmail'] == email){
              upVoted = key;
            }
        });
      }
      if(event.snapshot.value['downVoters'] != null){
          Map<dynamic,dynamic> mapDownVote = new Map();
          mapDownVote = event.snapshot.value['downVoters'];
          mapDownVote.forEach((key,vote){
            if(vote['userEmail'] == email){
              downVoted = key;
            }
          });
      }
    }
    //set profile picture
    database.reference().child("userDetails").child(question.user).once().then((result){
      if(result.value != null){
        User userone = User.fromSnapshot(result); 
        setState(() {
          userName = userone.name;
          profileLink = userone.profileLink;          
        });
        if(userone.email == email){
          isMyQuestion = true;
        }
      }
    });
  }
  void setAnswers(Event event){
    
      Answer oneAnswer = Answer.fromSnapshot(event.snapshot);

       Map<dynamic,dynamic> mapUpVote = new Map();
        if(event.snapshot.value['upVoters'] != null){
          mapUpVote = event.snapshot.value['upVoters'];
          mapUpVote.forEach((key,vote){
            if(vote['userEmail'] == email){
              oneAnswer.upVote = key;
            }
        });
      }
      if(event.snapshot.value['downVoters'] != null){
          Map<dynamic,dynamic> mapDownVote = new Map();
          mapDownVote = event.snapshot.value['downVoters'];
          mapDownVote.forEach((key,vote){
            if(vote['userEmail'] == email){
              oneAnswer.downVote = key;
            }
          });
      }
    setState(() {
      answerList.add(oneAnswer);
    });
  }
  Widget profileImage(){
     if(profileLink != null && profileLink != ""){
        return Container(
              width: 135.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          profileLink
                      ),
                  ),
              ),
          );
     }else{
       return Icon(
         Icons.person_outline,
         size: 25,
         color: Colors.white,
         );
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
              setState(() {
                if(upVoted == "" && !isMyQuestion){
                  if(downVoted != ""){
                    databaseReference.child(widget.questionKey).child('downVoters').child(downVoted).remove();
                    downVoted = "";
                    question.votes++;
                  }else{
                    Votes vote = new Votes(email);
                    upVoted = databaseReference.child(widget.questionKey).child('upVoters').push().key;
                    databaseReference.child(widget.questionKey).child('upVoters').child(upVoted).set(vote.toJson());
                    question.votes++;
                  }
                  //give points to the question owner;
                  database.reference().child("userDetails").child(question.user).once().then((result){
                    database.reference().child("userDetails").child(question.user).child("points").set(++result.value['points']);
                  });
                }
              });
            },
          ),
          Text(
            question.votes.toString(),
            style: TextStyle(
                fontSize: 25
            ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 50,
            color: downVoted != "" ? Colors.orange:Colors.blueGrey,
            onPressed: (){
              if(downVoted == "" && !isMyQuestion){
                if(upVoted != ""){
                      databaseReference.child(widget.questionKey).child('upVoters').child(upVoted).remove();
                      upVoted = "";
                      setState(() {
                      question.votes--;
                    });
                }else{
                    Votes vote = new Votes(email);
                    downVoted = databaseReference.child(widget.questionKey).child('downVoters').push().key;
                    databaseReference.child(widget.questionKey).child('downVoters').child(downVoted).set(vote.toJson());
                    setState(() {
                      question.votes--;
                    });
                }
                //give points to the question owner;
                database.reference().child("userDetails").child(question.user).once().then((result){
                  database.reference().child("userDetails").child(question.user).child("points").set(--result.value['points']);
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget voteupdownAnswers(int answerIndex){
    bool isMyAnswer= false;
    if(answerList[answerIndex].user == userKey){
      isMyAnswer = true;
    }

    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            iconSize: 50,
            color:  answerList[answerIndex].upVote  != "" ? Colors.orange:Colors.blueGrey,
            onPressed: (){
              if(answerList[answerIndex].upVote == "" && !isMyAnswer){
                setState(() {
                  answerList[answerIndex].votes++;
                });
                if(answerList[answerIndex].downVote != ""){
                      databaseReference.child(widget.questionKey).child("answer")
                      .child(answerList[answerIndex].key).child('upVoters').child(answerList[answerIndex].downVote).remove();
                      setState(() {
                        answerList[answerIndex].downVote = "";
                    });
                }else{
                    Votes vote = new Votes(email);
                    setState(() {
                      answerList[answerIndex].upVote = databaseReference.child(widget.questionKey).child("answer")
                        .child(answerList[answerIndex].key).child('upVoters').push().key; 
                    });
                    databaseReference.child(widget.questionKey).child("answer")
                      .child(answerList[answerIndex].key).child('upVoters').child(answerList[answerIndex].upVote).set(vote.toJson());  
                }
                //give points to the question owner;
                database.reference().child("userDetails").child(answerList[answerIndex].user).once().then((result){
                  database.reference().child("userDetails").child(answerList[answerIndex].user).child("points").set(++result.value['points']);
                });
              }
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
            color: answerList[answerIndex].downVote != "" ? Colors.orange:Colors.blueGrey,
            onPressed: (){
              if(answerList[answerIndex].downVote == "" && !isMyAnswer){
                answerList[answerIndex].votes--;
                if(answerList[answerIndex].upVote != ""){
                      databaseReference.child(widget.questionKey).child("answer")
                      .child(answerList[answerIndex].key).child('upVoters').child(answerList[answerIndex].upVote).remove();
                      setState(() {
                        answerList[answerIndex].upVote = "";
                    });
                }else{
                    Votes vote = new Votes(email);
                    setState(() {
                      answerList[answerIndex].downVote = databaseReference.child(widget.questionKey).child("answer")
                        .child(answerList[answerIndex].key).child('downVoters').push().key;
                    });
                    databaseReference.child(widget.questionKey).child("answer")
                      .child(answerList[answerIndex].key).child('downVoters').child(answerList[answerIndex].downVote).set(vote.toJson());  
                }
                database.reference().child("userDetails").child(answerList[answerIndex].user).once().then((result){
                  database.reference().child("userDetails").child(answerList[answerIndex].user).child("points").set(--result.value['points']);
                });
              }
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
              labelText: "Enter your answer",
              border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.teal),
              // borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          
        ),
        Padding(
          padding: const EdgeInsets.only(top:12.0),
          child: TextField(
            controller: answerDescription,
            decoration: new InputDecoration(
                labelText: "Enter your answer description",
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.white),
                // borderRadius: BorderRadius.circular(25.0),
              ),
            ),
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
      finalAnswer.answer = answer.text;
      finalAnswer.comment = answerDescription.text;
      finalAnswer.user = userKey;
      databaseReference.child(widget.questionKey).child("answer").push().set(finalAnswer.toJson());
      answer.text = "";
      answerDescription.text = "";
      addAnswer = false;
     
    }
  }
  void goToProfile(String key){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new ProfilePage(questionUserKey: key);
        });
    Navigator.of(context).push(router);
  }
}
