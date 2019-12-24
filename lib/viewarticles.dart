import 'package:flutter/material.dart';
import 'auth.dart';
import 'rootpage.dart';
import 'admin.dart';
import 'Home.dart';
import 'writer.dart';
import 'viewwriters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'article.dart';
class ViewArticles extends StatefulWidget {
  BaseAuth auth;
  ViewArticles({this.auth});
  @override
  ViewArticlesState createState() => ViewArticlesState();
}

class ViewArticlesState extends State<ViewArticles> {
  void signOut()async{
    try{
      await widget.auth.signOut();
      setState(() {
        RootPageState.authStatus = AuthStatus.notSignedIn;
      });
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(auth: widget.auth)));
    }catch(e){
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('View All Articles'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                width: 200.0,
                height: 200.0,
                child: Image.asset("images/MLogo.png")
            ),
            Divider(),
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
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ViewWriters(auth: widget.auth)));
                }
            ),
            ListTile(
                leading: Icon(Icons.apps),
                title: Text("View All Articles"),
                onTap: (){
                  Navigator.pop(context);
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
        stream: Firestore.instance.collection('articles').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator()
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int i){
              int index = snapshot.data.documents.length - 1 - i;
              return ListTile(
                title: Text(snapshot.data.documents[index].data['title']),
                trailing: Switch(
                    activeColor: Colors.deepPurpleAccent,
                    value: snapshot.data.documents[index].data['approved'],
                    onChanged: (bool value)async{
                      DocumentReference ref = Firestore.instance.collection('articles').document(snapshot.data.documents[index].documentID);
                      ref.updateData({
                        'approved' : value
                      });
                    }
                ),
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Article(
                    auth: widget.auth,
                    title: snapshot.data.documents[index].data['title'],
                    content: snapshot.data.documents[index].data['content'],
                    name: snapshot.data.documents[index].data['author']
                  )));
                }
              );
            },
          );
        },
      ),
    );
  }
}
