import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:my_stackoverflow/ui/userdetailsform.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool incorrectPassword  = false;
  var _formKey = GlobalKey<FormState>();
  String _email;
  String _formpassword;
  String newUserKey ="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
//          new Center(
//            child: new Image.asset(
//              'images/cover_two.jpg',
//              fit: BoxFit.fill,
//              width: 500,
//              height: 1000,
//            ),
//          ),
          new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                    validator: (value){
                      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(p);
                      if(value.length == 0 || !regExp.hasMatch(value)){
                        return "Invalid email";
                      }
                    },
                    onSaved: (value){
                      _email = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the email",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                    obscureText: true,
                    validator: (value){

                      if(value.length == 0){
                        return "Password is empty";
                      }
                    },
                    onSaved: (value){
                      _formpassword = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the password",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      errorText: incorrectPassword ? "User email or password is incorrect":null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: signupButton ,
                  color: Color.fromRGBO(52, 66, 86, 1),
                  child: Text(
                    'Login',
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
      ),
    );
  }

  void signupButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signupwithEmail(_email, _formpassword);
    }
  }

  void signupwithEmail(String email, String password) async {
    FirebaseUser user;
    final prefs = await SharedPreferences.getInstance();   //save username
    try{
      user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }catch(e){
      print(e.toString());
    }finally{
      if(user != null){
        createUser();
        incorrectPassword = false;
        prefs.setString("userEmail", _email);
        prefs.setString("userKey",newUserKey);
        
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new UserDetailsForm();
            });
        Navigator.of(context).push(router);
      }else{
        print("Authentication failed");
        setState(() {
          incorrectPassword = true;
        });
      }
    }
  }
  void createUser(){
    databaseReference = database.reference().child("userDetails");
    User user = new User("",_email,"","",0,"");
    newUserKey = databaseReference.push().key;
    databaseReference.child(newUserKey).set(user.toJson());
  }
}
