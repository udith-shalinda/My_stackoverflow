import 'package:firebase_database/firebase_database.dart';

class MyQuestionKey {
  String key;
  String questionKey;

  MyQuestionKey(this.questionKey);

  MyQuestionKey.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        questionKey = snapshot.value['questionKey'];


  toJson(){
    return {
      "userEmail" :questionKey,
    };
  }

}