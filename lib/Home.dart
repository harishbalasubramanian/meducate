import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'auth.dart';
import 'rootpage.dart';
import 'writer.dart';
import 'editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin.dart';
import 'article.dart';
class Home extends StatefulWidget {
  BaseAuth auth;
  VoidCallback onSignedOut;
  Home({this.auth});
  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {
  void signOut()async{

    try{
      await widget.auth.signOut();
      setState(() {
        RootPageState.authStatus = AuthStatus.notSignedIn;
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('articles').where('approved', isEqualTo: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Scaffold(
              appBar: AppBar(
                title: Text("Loading"),
                backgroundColor: Colors.deepPurpleAccent,
              ),
              body: Center(child: CircularProgressIndicator(),)
          );
        }

        return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text("Meducate"),
            automaticallyImplyLeading: RootPageState.uid != '' ? true :false,
            actions: <Widget>[
              RootPageState.uid == ''?IconButton(
                icon: Icon(Icons.vpn_key),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RootPage(auth: Auth())));
                },
              ):Container(),
            ],
          ),
          drawer: RootPageState.uid != '' ? Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Go to home'),
                    onTap: (){
                      Navigator.pop(context);
                    }
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Editor(auth: widget.auth, onSignedOut: signOut)));
                      }
                      else if (RootPageState.status == Status.admin){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => Admin(auth: widget.auth, onSignedOut: signOut)));
                      }
                    }
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Sign Out"),
                  onTap: signOut,
                ),
              ],
            ),
          ) : null,
          body: snapshot.data.documents.length > 0 ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int index){
                return ListTile(
                  title: snapshot.data.documents[index].data['title'],
                  subtitle: snapshot.data.documents[index].data['subtitle'],
                  onTap: (){
                    return Article(auth: widget.auth, title: snapshot.data.documents[index].data['title'], content: snapshot.data.documents[index].data['content'], name: snapshot.data.documents[index].data['name']);
                  },
                );
            }
          ) :Center(child: Text("No articles have been uploaded yet")),
        );
      }
    );
  }
}
