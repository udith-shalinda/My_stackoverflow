import 'package:flutter/material.dart';

class GiveAnswer extends StatefulWidget {

  String QuestionKey;
  GiveAnswer({Key  key, this.QuestionKey}):super(key:key);


  @override
  _GiveAnswerState createState() => _GiveAnswerState();
}

class _GiveAnswerState extends State<GiveAnswer> {

  bool addAnswer = false;
  var answer = new TextEditingController();
  var answerDescription = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        centerTitle: true,
        title: new Text(
          "question page",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  title: Container(
                      padding: EdgeInsets.only(top: 10),
                      child:Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.black,
                            child: new Text("sgsfsf"),
                          ),
                          Text(
                            "   czczczczcz",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )
                  ),
                  subtitle: Container(
                      alignment: FractionalOffset.topLeft,
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "sfsfsfsf",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 25),
                          ),
                          Text(
                            "ssfsfsf",
                            style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                          Container(    //answers shown here;
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            child: addAnswer ? answerForm() : RaisedButton(
                                    child: Text("Add an answer"),
                                    onPressed: addAnswerButtonClicked,
                            )
                          )
                        ],
                      ),
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget answerForm(){
    return Column(
      children: <Widget>[
        TextField(
          controller: answer,
          decoration: new InputDecoration(
              labelText: "Enter your answer"
          ),
        ),
        TextField(
          controller: answer,
          decoration: new InputDecoration(
              labelText: "Enter your answer"
          ),
        ),
        RaisedButton(
          onPressed: (){},
          child: Text("post it"),
        ),
      ],
    );
  }
  void addAnswerButtonClicked(){
    setState(() {
      addAnswer = true;
    });

  }
}
