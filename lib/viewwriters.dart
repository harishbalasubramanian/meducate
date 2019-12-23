import 'package:flutter/material.dart';
import 'auth.dart';
import 'rootpage.dart';
import 'admin.dart';
import 'viewarticles.dart';
import 'writer.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ViewWriters extends StatefulWidget {
  BaseAuth auth;
  ViewWriters({this.auth});
  @override
  ViewWritersState createState() => ViewWritersState();
}

class ViewWritersState extends State<ViewWriters> {
  void signOut()async{
    try{
      await widget.auth.signOut();
      setState(() {
        RootPageState.authStatus = AuthStatus.notSignedIn;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }catch(e){
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("View Writers"),

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Writer(auth: widget.auth, onSignedOut: signOut)));
                  }
                  else if (RootPageState.status == Status.editor){
                    //Navigator.pop(context, MaterialPageRoute(builder: (context) => Editor(auth: widget.auth, onSignedOut: widget.signOut)));
                  }
                  else if (RootPageState.status == Status.admin){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Admin(auth: widget.auth, onSignedOut: signOut)));
                  }
                }
            ),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text("View Writers"),
                onTap: (){
                  Navigator.pop(context);
                }
            ),
            ListTile(
                leading: Icon(Icons.apps),
                title: Text("View All Articles"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewArticles()));
                }
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sign Out"),
              onTap: signOut,
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').where('status',isEqualTo: 'writer').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator()
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int i){
              return ListTile(
                title: Text(snapshot.data.documents[i].data['name']),
                trailing: Switch(
                  activeColor: Colors.deepPurpleAccent,
                  value: snapshot.data.documents[i].data['approved'],
                  onChanged: (bool value)async{
                    Firestore.instance.collection('users').where('uid', isEqualTo: snapshot.data.documents[i].data['uid']).getDocuments().then((docs){
                      DocumentReference ref = docs.documents[0].reference;
                      ref.updateData({
                        'approved' : value,
                      });
                    });

                  }
                ),
              );
            },
          );
        },
      ),
    );
  }
}
