import 'package:firebase_database/firebase_database.dart';

class Votes {
  String key;
  String userEmail;
  int updown;

  Votes(this.updown,this.userEmail);

  Votes.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        updown = snapshot.value['updown'],
        userEmail = snapshot.value['userEmail'];


  toJson(){
    return {
      "updown" : updown,
      "userEmail" :userEmail,
    };
  }

}