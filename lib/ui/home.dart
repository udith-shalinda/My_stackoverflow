
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/Question.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:my_stackoverflow/modle/votes.dart';
import 'package:my_stackoverflow/ui/profilePage.dart';
import 'package:my_stackoverflow/ui/userdetailsform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'AddQuestion.dart';
import 'giveAnswer.dart';
import 'login.dart';
import 'search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  String email;
  String userKey;
  User user = new User("","","","",0,"");
  List<User> questionUsers = new List();
  int noOfUserQuestions = 0;


  @override
  void initState() {
    super.initState();
    getSharedPreference();
    databaseReference = database.reference().child("Questions");
    databaseReference.onChildAdded.listen(getQuestionUsers);
    database.reference().child("userDetails").onChildAdded.listen(getTheUser);
    database.reference().child("userDetails").onChildChanged.listen(getTheUser);

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
                          child: userProfileImage(),
                        ),
                      ),
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
                      IconButton(
                        icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 34,
                        ),
                        onPressed: editProfile,
                      ),
                      IconButton(
                        icon: Icon(
                            FontAwesomeIcons.signOutAlt,
                            color: Colors.white,
                            size: 34,
                        ),
                        onPressed: signout,
                      ),
                      
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
                    onPressed: pressSearch,
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
                                      title: setTitleQuestion(snapshot,index),
                                      subtitle: Container(
                                        alignment: FractionalOffset.topLeft,
                                        padding: EdgeInsets.only(top: 30),
                                        child:Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child:voteupdown(snapshot,index),
                                                ),
                                                Flexible(
                                                  child: questionandAnswer(snapshot),
                                                ),
                                              ],
                                            ),
                                            buttonSet(snapshot,index),
                                          ],
                                        ),
                                      ),
                                      trailing: new Icon(Icons.arrow_right, color: Colors.grey, size: 50.0),

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
      userKey = prefs.getString('userKey');
     
    }
  }

   void getTheUser(Event event){
     User thisuser = User.fromSnapshot(event.snapshot);
     if(userKey == thisuser.key){
       setState(() {
        user = thisuser; 
       });
       if(event.snapshot.value['myQuestionList'] != null){
         setState(() {
           noOfUserQuestions =  event.snapshot.value['myQuestionList'].length;
          });
        }
     } 
  }
  void getQuestionUsers(Event event){
      database.reference().child("userDetails").child(event.snapshot.value['user']).once().then((result){
       setState(() {
        questionUsers.add(User.fromSnapshot(result)); 
       });
      });
  }

  Widget setTitleQuestion(DataSnapshot snapshot,int index){
    String userName;
    String questionProfileLink;
    if(questionUsers.length < index+1){
      userName = "";
      questionProfileLink = "";
    }else{
      userName = questionUsers[index].name;
      questionProfileLink = questionUsers[index].profileLink;
    }
    return Align(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child:Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.black,
              child: questionProfileImage(questionProfileLink),
            ),
            Text(
                "   " + userName,
                style: TextStyle(color: Colors.black),
              ),
          ],
        )
      ),
      alignment: FractionalOffset.topLeft,
    );
  }
  

  Widget voteupdown(DataSnapshot snapshot,int index){
    String upVoted = "";
    String downVoted = "";
    int voters;
    String questionOwner = "";
    Question question = Question.fromSnapshot(snapshot);
    voters = question.votes;

    //check wether the question is mine or not before voting
    if(questionUsers.length >= index+1){
      if(email == questionUsers[index].email){
        questionOwner = email;
      }
    }
    

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
              if(upVoted == "" && questionOwner == ""){
                if(downVoted != ""){
                    databaseReference.child(snapshot.key).child('downVoters').child(downVoted).remove();              
                }else{
                    Votes vote = new Votes(email);
                    databaseReference.child(snapshot.key).child('upVoters').push().set(vote.toJson());              
                    databaseReference.child(snapshot.key).child('votes').set(++snapshot.value['votes']);
                }
                //give points to the question owner;
                 database.reference().child("userDetails").child(question.user).once().then((result){
                   database.reference().child("userDetails").child(question.user).child("points").set(++result.value['points']);
                });

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
              if(downVoted == "" && questionOwner == ""){
                  if(upVoted != ""){
                    databaseReference.child(snapshot.key).child('upVoters').child(upVoted).remove();
                  }else{
                    Votes vote = new Votes(email);
                    databaseReference.child(snapshot.key).child('downVoters').push().set(vote.toJson());
                    databaseReference.child(snapshot.key).child('votes').set(--snapshot.value['votes']);
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
            snapshot.value['description'].toString(),
            style: TextStyle(color: Colors.blueGrey, fontSize: 15),
          ),
        ],
      );
  }
  Widget buttonSet(DataSnapshot snapshot ,int index){
    bool isQuestionOwner = false;
//check wether the question is mine or not before voting
    if(questionUsers.length >= index+1){
      if(email == questionUsers[index].email){
        isQuestionOwner = true;
      }
    }

    Question question = Question.fromSnapshot(snapshot);
    int voters = question.votes;
    String answerCount = snapshot.value['answer'] != null? snapshot.value['answer'].length.toString() : "0";
    
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Text("votes :" + voters.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Text(
              "Answers : "+ answerCount
              ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: !isQuestionOwner ? Container():
           IconButton(
            icon: Icon(Icons.delete,color: Colors.redAccent,),
            onPressed: (){
              databaseReference.child(question.key).remove();
              database.reference().child('userDetails').child(userKey).child('myQuestionList').child(question.key).remove();
            },
          ),
        ),
      ],
    );
  }
  Widget userProfileImage(){
     if(user.profileLink != null && user.profileLink != ""){
        return Container(
              width: 138.0,
              height: 138.0,
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
     }else{
       return Icon(
         Icons.person_outline,
         size: 55,
         color: Colors.white,
         );
     }
  }
  Widget questionProfileImage(String profileLink){
     if(profileLink != ""){
        return Container(
              width: 135.0,
              height: 135.0,
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
         color: Colors.white,
         );
     }
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
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new GiveAnswer(questionKey: key);
        });
    Navigator.of(context).push(router);
  }
  Future signout() async {
     await FirebaseAuth.instance.signOut();
     final prefs = await SharedPreferences.getInstance();
     prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
    );
  }
  void pressSearch(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new Search();
        });
    Navigator.of(context).push(router);
  }

}
