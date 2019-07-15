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
  String key;
  String useremail;
  var _formKey = GlobalKey<FormState>();
  String _username="";
  String _github="";
  String _linkedIn="";
  String userKey;
  var userNameControler = new TextEditingController();
  var githubControler = new TextEditingController();
  var linkedInControler = new TextEditingController();
  String profileImageLink;


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
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 45.0,
                        backgroundColor: Colors.black,
                        child: profileImage(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: (){
                        _pickSaveImage();
                      },
                      ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: userNameControler,
                        // initialValue: _username,
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
                        controller: githubControler,
                        // initialValue: _github,
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
                        controller: linkedInControler,
                        // initialValue: _linkedIn,
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
      userKey = prefs.getString("userKey");
    }
  }
  _getUserDetails(Event event){
    if(event.snapshot.value['email'] == useremail){
      setState(() {
        key = event.snapshot.key;
        userNameControler.text = event.snapshot.value['name'];
        githubControler.text = event.snapshot.value['github'];
        linkedInControler.text = event.snapshot.value['linkedin'];
        profileImageLink = event.snapshot.value['profileLink'];
      });
    }
  }
  Widget profileImage(){
     if(profileImageLink != null){
        return Container(
              width: 135.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          profileImageLink
                      ),
                  ),
              ),
          );
     }else{
       return Icon(Icons.person);
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
    if(imageFile != null){
      StorageUploadTask uploadTask = ref.putFile(imageFile);
      profileImageLink = await (await uploadTask.onComplete).ref.getDownloadURL();
      databaseReference.child(key).child('profileLink').set(profileImageLink);
      return profileImageLink;
    }else{
      return "error";
    }
  }

  void saveButtonClickec(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      uploadUserDetails();
    }
  }
}

// details not get updated when load;