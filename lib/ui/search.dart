import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_stackoverflow/modle/user.dart';
import 'package:my_stackoverflow/ui/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'giveAnswer.dart';
import 'home.dart';



class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  var searchKey = new TextEditingController();
  
  

  @override
  void initState() {
    super.initState();
    searchKey.text = "";

    databaseReference = database.reference().child("userDetails");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
            "Search",
            style: TextStyle(
              fontSize: 25,
            ),
        ),
        centerTitle: true,
      ),
      body:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: TextField(
              controller: searchKey,
              decoration: InputDecoration(
              suffixIcon:IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: (){},
                ),
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
          
        ],

      ),




    );
  }
 
  Widget searchResultBody(){
    return Container(
                  child : new ListView(
                    children: <Widget>[
                      new Container(
                        height:  MediaQuery.of(context).size.height-50,
                        child: new FirebaseAnimatedList(
                            query: databaseReference,
                            itemBuilder: (_, DataSnapshot snapshot,Animation<double> animation , int index){
                              return new Card(
                                  elevation: 8.0,
                                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  child: new Container(
                                    decoration: BoxDecoration(color: Colors.white),
                                    child: new ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                                      leading: Container(
//                                        padding: EdgeInsets.only(right: 12.0),
////                                        decoration: new BoxDecoration(
////                                            border: new Border(
////                                                right: new BorderSide(width: 1.0, color: Colors.white24))),
//                                        child: CircleAvatar(
//                                          radius: 30.0,
//                                          backgroundColor: Colors.white,
//                                          child: new Text(snapshot.value['email'].substring(5,10)),
//                                        ),
//                                      ),
                                      title: Text("title"),
                                      subtitle: Container(
                                        alignment: FractionalOffset.topLeft,
                                        padding: EdgeInsets.only(top: 30),
                                        child:Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                // Flexible(
                                                //   child:voteupdown(snapshot,index),
                                                // ),
                                                Flexible(
                                                  child: questionandAnswer(snapshot),
                                                ),
                                              ],
                                            ),
                                            // buttonSet(snapshot,index),
                                          ],
                                        ),
                                      ),
                                      trailing: new Icon(Icons.arrow_right, color: Colors.grey, size: 50.0),

                                      onTap: (){
                                        showQuestion(snapshot.key);
                                      },
                                    ),
                                  )
                              );
                            }
                        ),
                      ),
                    ],
                  )
              );
  }
  Widget questionandAnswer(DataSnapshot snapshot){
      return Column(
        children: <Widget>[
          Container(
            child: Text(
              snapshot.value['question'].toString(),
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 25),
            ),
          ),
          Text(
            snapshot.value['question'].toString(),
            style: TextStyle(color: Colors.blueGrey, fontSize: 15),
          ),
        ],
      );
  }

  void showQuestion(String key){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new GiveAnswer(questionKey: key);
        });
    Navigator.of(context).push(router);
  }
  
}
