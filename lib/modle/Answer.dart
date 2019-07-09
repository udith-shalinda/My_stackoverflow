import 'package:firebase_database/firebase_database.dart';
import 'package:my_stackoverflow/modle/votes.dart';

class Answer {
  String key;
  String answer;
  String comment;
  int votes;
  List<Votes> answerVotes;

  Answer(this.answer,this.comment,this.votes,this.answerVotes);

  Answer.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        answer = snapshot.value['answer'],
        comment = snapshot.value['comment'],
        votes = snapshot.value['votes'];



  toJson(){
    return {
      "answer" : answer,
      "comment" :comment,
      "votes" : votes,
      "anwerVotes" : answerVotes,
    };
  }

}