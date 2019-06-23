import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String name;
  String github;
  String linkedin;
  String email;

  User(this.name,this.email,this.github,this.linkedin);

  User.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        name = snapshot.value['name'],
        email = snapshot.value['email'],
        github = snapshot.value['github'],
        linkedin = snapshot.value['linkedin'];


  toJson(){
    return {
      "name" : name,
      "email" :email,
      "github" : github,
      "linkedin" : linkedin,
    };
  }

}