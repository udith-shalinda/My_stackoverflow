import 'package:firebase_database/firebase_database.dart';

import 'Answer.dart';



class Question {
  String key;
  String email;
  String question;
  String description;
  List<Answer> answer ;

  Question(this.email,this.question,this.description,this.answer);

  Question.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        email = snapshot.value['email'],
        question = snapshot.value['question'],
        description = snapshot.value['description'],
        answer = snapshot.value['answer'];


  toJson(){
    return {
      "email" : email,
      "question" : question,
      "description" :description,
      "answer" : answer
    };
  }

}