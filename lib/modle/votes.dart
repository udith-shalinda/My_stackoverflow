import 'package:firebase_database/firebase_database.dart';

class Votes {
  String key;
  String userEmail;

  Votes(this.userEmail);

  // factory Votes.fromJson(Map<String, dynamic> json) {
  //   if (json == null) {
  //     throw FormatException("Null JSON provided to SimpleObject");
  //   }
    
  //   return Votes(
  //         json['userEmail'].toString()
        
  //   );
  // }

  // Votes.fromJson(Map<String, dynamic> json)
  //     : userEmail = json['userEmail'];
      
  // Map<String, dynamic> toJson() =>
  //   {
  //     'userEmail': userEmail
  //   };

  Votes.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        userEmail = snapshot.value['userEmail'];


  toJson(){
    return {
      "userEmail" :userEmail,
    };
  }

}