import 'package:flutter/material.dart';
import 'auth.dart';
import 'Home.dart';
import 'rootpage.dart';
import 'admin.dart';
import 'editor.dart';
class Writer extends StatefulWidget {
  BaseAuth auth;
  VoidCallback onSignedOut;
  Writer({this.auth, this.onSignedOut});
  @override
  WriterState createState() => WriterState();
  void signOut()async{
   try{
      await auth.signOut();
      onSignedOut();
   }catch(e){
      debugPrint(e.toString());
   }
  }
}

class WriterState extends State<Writer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Writer Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){

              }
          ),
        ],
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

                  }
                  else if (RootPageState.status == Status.editor){
                    Navigator.pop(context, MaterialPageRoute(builder: (context) => Editor(auth: widget.auth, onSignedOut: widget.signOut)));
                  }
                  else if (RootPageState.status == Status.admin){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Admin(auth: widget.auth, onSignedOut: widget.signOut)));
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
