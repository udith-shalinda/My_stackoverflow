import 'package:firebase_database/firebase_database.dart';

class votes {
  String key;
  String questionKey;
  List<String> userEmail;

  votes(this.questionKey,this.userEmail);

  votes.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        questionKey = snapshot.value['questionKey'],
        userEmail = snapshot.value['userEmail'];


  toJson(){
    return {
      "questionKey" : questionKey,
      "userEmail" :userEmail,
    };
  }

}