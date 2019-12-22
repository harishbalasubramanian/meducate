import 'package:flutter/material.dart';
import 'auth.dart';
import 'Home.dart';
import 'rootpage.dart';
import 'editor.dart';
import 'writer.dart';
class Admin extends StatefulWidget {
  BaseAuth auth;
  VoidCallback onSignedOut;
  Admin({this.auth, this.onSignedOut});
  @override
  AdminState createState() => AdminState();
  void signOut()async{
    try{
      await auth.signOut();
      onSignedOut();
    }catch(e){
      debugPrint(e.toString());
    }
  }
}

class AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Admin Page"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Go to Home"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(auth: widget.auth)));
              },
            ),
            ListTile(
                leading: Icon(Icons.book),
                title: Text("View your articles"),
                onTap: (){
                  Navigator.pop(context);
                  if(RootPageState.status == Status.writer){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Writer(auth: widget.auth, onSignedOut: widget.signOut)));
                  }
                  else if (RootPageState.status == Status.editor){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Editor(auth: widget.auth, onSignedOut: widget.signOut)));
                  }
                  else if (RootPageState.status == Status.admin){


                  }
                }
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sign Out"),
              onTap: widget.signOut,
            ),
          ],
        ),
      ),
    );
  }
}
