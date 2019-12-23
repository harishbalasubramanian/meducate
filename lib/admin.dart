import 'package:flutter/material.dart';
import 'auth.dart';
import 'Home.dart';
import 'rootpage.dart';
import 'writer.dart';
import 'editor.dart';
import 'add.dart';
import 'edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'viewwriters.dart';
import 'viewarticles.dart';
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
        title: Text("Admin Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                debugPrint('yeehawww');
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Add(auth: widget.auth)));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Writer(auth: widget.auth, onSignedOut: widget.signOut)));
                  }
                  else if (RootPageState.status == Status.editor){
                    Navigator.pop(context, MaterialPageRoute(builder: (context) => Editor(auth: widget.auth, onSignedOut: widget.signOut)));
                  }
                  else if (RootPageState.status == Status.admin){


                  }
                }
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("View Writers"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewWriters(auth: widget.auth)));
              }
            ),
            ListTile(
              leading: Icon(Icons.apps),
              title: Text("View All Articles"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewArticles(auth: widget.auth)));
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
          stream: Firestore.instance.collection('users').where('uid', isEqualTo: RootPageState.uid).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            if(snapshot.data.documents[0].data['articles'] == null ){
              return Center(
                child: Text('You have not uploaded any articles'),
              );
            }
            else if(snapshot.data.documents[0].data['articles'].length == 0  ){
              return Center(
                child: Text('You have not uploaded any articles'),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data.documents[0].data['articles'].length,
                itemBuilder: (context, int index){
                  //debugPrint('length ${snapshot.data.documents[0].data['articles'].length}');
                  return StreamBuilder(
                      stream: Firestore.instance.collection('articles').where('author',isEqualTo: snapshot.data.documents[0].data['name']).where('title',isEqualTo: snapshot.data.documents[0]
                          .data['articles'][index]).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                        if(!snap.hasData){
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        }

                        if(snapshot.data.documents[0].data['articles'].length == 0){
                          return Center(
                            child: Text('You have not uploaded any articles'),
                          );
                        }
                        //debugPrint('index $index');
                        //There is only going to be one document per ListTile since the title and author match up for only one document
                        return ListTile(
                          title: Text(snapshot.data.documents[0]
                              .data['articles'][index]),
                          subtitle: Text('approved: '+snap.data.documents[0].data['approved']
                              .toString()),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Edit(
                              title: snap.data.documents[0].data['title'],
                              subtitle: snap.data.documents[0].data['subtitle'],
                              content: snap.data.documents[0].data['content'],
                            )));
                          },
                        );

                      }
                  );
                }
            );
          }
      ),
    );
  }
}
