import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String name;
  String github;
  String linkin;
  String email;

  User(this.name,this.email,this.github,this.linkin);

  User.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        name = snapshot.value['name'],
        email = snapshot.value['email'],
        github = snapshot.value['github'],
        linkin = snapshot.value['linkin'];


  toJson(){
    return {
      "name" : name,
      "email" :email,
      "github" : github,
      "linkin" : linkin,
    };
  }

}