import 'package:firebase_database/firebase_database.dart';



class Question {
  String key;
  String question;
  String description;
  String answer;

  Question(this.question,this.description,this.answer);

  Question.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        question = snapshot.value['question'],
        description = snapshot.value['description'],
        answer = snapshot.value['answer'];


  toJson(){
    return {
      "question" : question,
      "description" :description,
      "answer" : answer
    };
  }

}