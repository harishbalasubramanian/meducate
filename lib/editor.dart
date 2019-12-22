import 'package:flutter/material.dart';
import 'auth.dart';
import 'Home.dart';
import 'writer.dart';
import 'admin.dart';
import 'rootpage.dart';
class Editor extends StatefulWidget {
  BaseAuth auth;
  VoidCallback onSignedOut;
  Editor({this.auth, this.onSignedOut});
  @override
  EditorState createState() => EditorState();
  void signOut()async{
    try{
      await auth.signOut();
      onSignedOut();
    }catch(e){
      debugPrint(e.toString());
    }
  }
}

class EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Editor Page"),
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
