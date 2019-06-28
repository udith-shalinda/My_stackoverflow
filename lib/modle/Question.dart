import 'package:firebase_database/firebase_database.dart';

import 'Answer.dart';



class Question {
  String key;
  int votes;
  String email;
  String question;
  String description;
  Answer answer ;

  Question(this.email,this.question,this.description,this.answer,this.votes);

  Question.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        email = snapshot.value['email'],
        question = snapshot.value['question'],
        description = snapshot.value['description'],
        answer = snapshot.value['answer'],
        votes = snapshot.value['votes'];


  toJson(){
    return {
      "email" : email,
      "question" : question,
      "description" :description,
      "answer" : answer,
      "votes" : votes
    };
  }

}