import 'package:firebase_database/firebase_database.dart';

class Votes {
  String key;
  String userEmail;

  Votes(this.userEmail);

  Votes.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        userEmail = snapshot.value['userEmail'];


  toJson(){
    return {
      "userEmail" :userEmail,
    };
  }

}