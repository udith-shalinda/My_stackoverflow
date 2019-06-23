import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/ui/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool incorrectPassword  = false;
  var _username = new TextEditingController();
  var _password = new TextEditingController();

  var _formKey = GlobalKey<FormState>();
  String _email;
  String _formpassword;


  @override
  void initState() {
    databaseReference = database.reference().child("user");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
            "Login",
            style: TextStyle(
              fontSize: 25,
            ),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.person_add),
              onPressed: (){
                var router = new MaterialPageRoute(
                    builder: (BuildContext context){
                      return new SignUp();
                    });
                Navigator.of(context).push(router);

              })
        ],
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
                      fontSize: 16,
                    ),
                    controller: _username,
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
                      fontSize: 16,
                    ),
                    obscureText: true,
                    controller: _password,
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
                  onPressed: loginButton ,
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

  void loginButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signInWithCredentials(_email, _formpassword);
    }
  }

  void signInWithCredentials(String email, String password) async {
    FirebaseUser user;
    final prefs = await SharedPreferences.getInstance();   //save username
    try{
      user = await _firebaseAuth.signInWithEmailAndPassword(
          email: _username.text,
          password: _password.text
      );
    }catch(e){
      print(e.toString());
    }finally{
      if(user != null){
        incorrectPassword = false;
        prefs.setString("userEmail", _email);
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new Home();
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
}
