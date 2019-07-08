import 'package:firebase_database/firebase_database.dart';
import 'package:my_stackoverflow/modle/votes.dart';

import 'Answer.dart';



class Question {
  String key;
  int votes;
  String email;
  String question;
  String description;
  List<Answer> answer;
  int answercount;
  List<Votes> questionVotes;

  Question(this.email,this.question,this.description,this.answer,this.votes,this.answercount,this.questionVotes);

  Question.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        email = snapshot.value['email'],
        question = snapshot.value['question'],
        description = snapshot.value['description'],
        votes = snapshot.value['votes'],
        answercount = snapshot.value['answercount'];


  toJson(){
    return {
      "email" : email,
      "question" : question,
      "description" :description,
      "answer" : answer,
      "votes" : votes,
      "answercount" : answercount,
      "questionVotes" : questionVotes
    };
  }

}