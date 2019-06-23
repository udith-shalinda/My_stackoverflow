import 'package:firebase_database/firebase_database.dart';

class Answer {
  String key;
  String answer;
  String comment;

  Answer(this.answer,this.comment);

  Answer.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        answer = snapshot.value['answer'],
        comment = snapshot.value['comment'];



  toJson(){
    return {
      "answer" : answer,
      "comment" :comment,

    };
  }

}