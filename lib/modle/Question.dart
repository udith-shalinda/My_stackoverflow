import 'package:firebase_database/firebase_database.dart';
import 'package:my_stackoverflow/modle/votes.dart';

import 'Answer.dart';



class Question {
  String key;
  int votes;
  String user;
  String question;
  String description;
  List<Answer> answer;
  int answercount;
  List<Votes> upVoters;
  List<Votes> downVoters;
  List<String> voters;

  Question(this.user,this.question,this.description,this.answer,this.votes,this.answercount,this.upVoters,this.downVoters);

  Question.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        user = snapshot.value['user'],
        question = snapshot.value['question'],
        description = snapshot.value['description'],
        votes = (snapshot.value['upVoters'] != null) ?
         snapshot.value['upVoters'].length 
         -((snapshot.value['downVoters'] != null)? snapshot.value['downVoters'].length:0) :0 -
          ((snapshot.value['downVoters'] != null)? snapshot.value['downVoters'].length:0),
        answercount = snapshot.value['answercount'];
      


  toJson(){
    return {
      "user" : user,
      "question" : question,
      "description" :description,
      "answer" : answer,
      "votes" : votes,
      "answercount" : answercount,
      "upVoters" : upVoters,
      "downVoters" : downVoters
    };
  }

}