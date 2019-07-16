import 'package:firebase_database/firebase_database.dart';
import 'package:my_stackoverflow/modle/myQuestionKey.dart';

class User {
  String key;
  String name;
  String github;
  String linkedin;
  String email;
  int points;
  String profileLink;
  List<MyQuestionKey> myQuestionList;

  User(this.name,this.email,this.github,this.linkedin,this.points,this.profileLink);

  User.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        name = snapshot.value['name'],
        email = snapshot.value['email'],
        github = snapshot.value['github'],
        points = snapshot.value['points'],
        linkedin = snapshot.value['linkedin'],
        profileLink = snapshot.value['profileLink'];


  toJson(){
    return {
      "name" : name,
      "email" :email,
      "github" : github,
      "linkedin" : linkedin,
      "points" : points,
      "profileLink" : profileLink
    };
  }

}