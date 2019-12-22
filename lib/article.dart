import 'package:flutter/material.dart';
import 'rootpage.dart';
import 'auth.dart';
class Article extends StatefulWidget {
  BaseAuth auth;
  String title;
  String content;
  String name;
  Article({this.auth, this.title, this.content, this.name});
  @override
  ArticleState createState() => ArticleState();

}

class ArticleState extends State<Article> {
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
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title),

      ),

      body: SingleChildScrollView(
        child: Column(
              children: <Widget>[
                Text(widget.name, textAlign: TextAlign.center, style: TextStyle(fontFamily: "Serif", fontSize: 25.0)),
                Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(widget.content, textAlign: TextAlign.center, style: TextStyle(fontFamily: "Serif", fontSize: 25.0))
                ),
              ],
            )

      )
    );
  }
}
