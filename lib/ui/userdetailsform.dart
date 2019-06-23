import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference ;
  User user;
  String key;
  List<User> userList = List();
  String useremail;
  var _formKey = GlobalKey<FormState>();
  String _username="ss";
  String _github="";
  String _linkedIn="";


  @override
  void initState() {
    super.initState();
    getSharedPreference();
    databaseReference = database.reference().child("userDetails");
    databaseReference.onChildAdded.listen(_getUserDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        centerTitle: true,
        title: new Text(
          "User Details",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
          child: new ListView(
            children: <Widget>[
              new Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        initialValue: _username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        validator: (value){
                          if(value.length == 0){
                            return "Must be filled";
                          }
                        },
                        onSaved: (value){
                         _username = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter the Name",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        initialValue: _github,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        validator: (value){
                          if(value.length == 0){
                            return "Must be filled";
                          }
                        },
                        onSaved: (value){
                           _github = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter the github link",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        initialValue: _linkedIn,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        validator: (value){
                          if(value.length == 0){
                            return "Must be filled";
                          }
                        },
                        onSaved: (value){
                          _linkedIn = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter the linked in profile",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                            ),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: saveButtonClickec,
                      color: Color.fromRGBO(52, 66, 86, 1),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      textColor: Colors.white70,
                    ),
                    RaisedButton(
                      onPressed: _pickSaveImage,
                      color: Color.fromRGBO(52, 66, 86, 1),
                      child: Text(
                        'upload image',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      textColor: Colors.white70,
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  void getSharedPreference() async{
    final prefs = await SharedPreferences.getInstance();   //save username
    if(prefs.getString('userEmail') == null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );
    }else{
      useremail =  prefs.getString('userEmail');
    }
  }
  _getUserDetails(Event event){
    userList.add(User.fromSnapshot(event.snapshot));
    if(event.snapshot.value['email'] == useremail){
      setState(() {
        _username = event.snapshot.value['name'];
        _github = event.snapshot.value['github'];
        _linkedIn = event.snapshot.value['linkedin'];
        key = event.snapshot.key;
      });
    }
  }
  void uploadUserDetails(){
    databaseReference.child(key).child('name').set(_username);
    databaseReference.child(key).child('github').set(_github);
    databaseReference.child(key).child('linkedin').set(_linkedIn);

    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new Home();
        });
    Navigator.of(context).push(router);
  }


  Future<String> _pickSaveImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference ref =
    FirebaseStorage.instance.ref().child(useremail);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    print(await (await uploadTask.onComplete).ref.getDownloadURL());
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }
  void saveButtonClickec(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      uploadUserDetails();
    }
  }
}

// details not get updated when load;