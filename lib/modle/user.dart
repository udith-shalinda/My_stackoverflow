import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String name;
  String mobile;
  String email;

  User(this.name,this.mobile,this.email);

  User.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        name = snapshot.value['name'],
        mobile = snapshot.value['mobile'],
        email = snapshot.value['email'];


  toJson(){
    return {
      "name" : name,
      "mobile" :mobile,
      "email" :email
    };
  }

}