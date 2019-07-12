import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String name;
  String github;
  String linkedin;
  String email;
  int points;

  User(this.name,this.email,this.github,this.linkedin,this.points);

  User.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        name = snapshot.value['name'],
        email = snapshot.value['email'],
        github = snapshot.value['github'],
        points = snapshot.value['points'],
        linkedin = snapshot.value['linkedin'];


  toJson(){
    return {
      "name" : name,
      "email" :email,
      "github" : github,
      "linkedin" : linkedin,
      "points" : points
    };
  }

}