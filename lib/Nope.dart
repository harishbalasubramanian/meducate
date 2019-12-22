import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rootpage.dart';
class Nope extends StatefulWidget {
  BaseAuth auth;
  VoidCallback onSignedOut;
  Nope({this.auth, this.onSignedOut});
  @override
  NopeState createState() => NopeState();
  void signOut()async{
    try{
      await auth.signOut();
      onSignedOut();
    }catch(e){
      debugPrint(e.toString());
    }
  }
}

class NopeState extends State<Nope> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("users").where('uid', isEqualTo: RootPageState.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        Map<String, dynamic> map = snapshot.hasData ? snapshot.data.documents[0].data : null;
        if(map == null){
          return Scaffold(
              appBar: AppBar(
                title: Text("Loading"),
                backgroundColor: Colors.deepPurpleAccent,
              ),
              body: Center(child: CircularProgressIndicator(),)
          );
        }
        if(!map['approved']) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent,
              title: Text("You are not approved"),
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("Go to home"),
                    leading: Icon(Icons.home),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Sign Out"),
                    onTap: (){
                      widget.signOut();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: Text(
                  "You have not been approved by the administrator. Please come back at a later time to see if you have been approved",textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Serif", fontSize: 20.0,
                  )),
            ),
          );
        }
        return RootPage(auth: widget.auth);
      },
    );
  }
}
