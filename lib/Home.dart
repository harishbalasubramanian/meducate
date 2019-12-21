import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'auth.dart';
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Meducate"),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.vpn_key),
            onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(auth: Auth())));
            },
          ),
        ],
      ),
    );
  }
}
