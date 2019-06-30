import 'package:firebase_database/firebase_database.dart';

class Answer {
  String key;
  String answer;
  String comment;
  int votes;

  Answer(this.answer,this.comment,this.votes);

  Answer.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        answer = snapshot.value['answer'],
        comment = snapshot.value['comment'],
        votes = snapshot.value['votes'];



  toJson(){
    return {
      "answer" : answer,
      "comment" :comment,
      "votes" : votes

    };
  }

}