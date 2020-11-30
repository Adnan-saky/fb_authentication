import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(fb_authentication());
}

class fb_authentication extends StatefulWidget {
  @override
  _fb_authentication createState() => _fb_authentication();
}

class _fb_authentication extends State<fb_authentication> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();
  FirebaseUser user;

  void _signIn() async {

    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name&access_token=${token}');
    print(graphResponse.body);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(accessToken: token);
      _auth.signInWithCredential(credential);
    }
  }

  Future <void> signOut() async
  {
    await facebookLogin.logOut();
    await  _auth.signOut();
      user = null;

    print("signed Out");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Facebook Login",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () {
            _signIn();
            print('');
            },
            child: Text("Login With Facebook"),
            color: Colors.cyan,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => signOut(),
          child: Text("Logout"),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}






