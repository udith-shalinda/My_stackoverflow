import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Color.fromRGBO(52, 66, 86, .7),
              drawer: Drawer(
                child:Container(
                  color: Color.fromRGBO(52, 66, 86, .9),
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(52, 66, 86, 1),
                        ),
                        child: new CircleAvatar(
                          radius: 45.0,
                          child: new Icon(Icons.person_outline,size: 55,color: Colors.white,),
                        ),
                      ),
                      Text("sfsfss"),
                      IconButton(
                        icon: Icon(Icons.library_add),
                      )
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
              backgroundColor: Color.fromRGBO(56, 66, 86, 1),
              centerTitle: true,
              title: new Text(
                "Home",
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
