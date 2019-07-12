import 'package:firebase_database/firebase_database.dart';
import 'package:my_stackoverflow/modle/votes.dart';

class Answer {
  String key;
  String answer;
  String comment;
  int votes;
  List<Votes> upVoters;
  List<Votes> downVoters;
  String upVote = "";
  String downVote = "";

  Answer(this.answer,this.comment,this.votes,this.upVoters,this.downVoters);

  Answer.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        answer = snapshot.value['answer'],
        comment = snapshot.value['comment'],
        votes = (snapshot.value['upVoters'] != null) ?
         snapshot.value['upVoters'].length 
         -((snapshot.value['downVoters'] != null)? snapshot.value['downVoters'].length:0) :0 -
          ((snapshot.value['downVoters'] != null)? snapshot.value['downVoters'].length:0);



  toJson(){
    return {
      "answer" : answer,
      "comment" :comment,
      "votes" : votes,
      "anwerVoters" : upVoters,
      "downVoters" : downVoters,
    };
  }

}