import 'package:flutter/material.dart';
import 'package:my_stackoverflow/ui/userdetailsform.dart';

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
                        icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 34,
                        ),
                        onPressed: editProfile,
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
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){},
                  ),
                ],
              ),
              body: Container(
                child: Text("sfsfsfs"),
              ),
    );
  }

  void editProfile(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new UserDetailsForm();
        });
    Navigator.of(context).push(router);
  }
}
