import 'package:flutter/material.dart';

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
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
        child: Text("sfsfsfs"),
      ),
    );
  }
}
