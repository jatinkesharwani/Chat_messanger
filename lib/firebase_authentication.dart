import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:people_chat/chat_screen.dart';
import 'package:people_chat/help_function.dart';
import 'package:people_chat/user_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  final String uid;
  UserAuth({required this.uid});
}

class AuthenticationPage {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String name;
  late String email;


  UserAuth _userFromFirebaseUser(User user) {
    return UserAuth(uid: user.uid);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User? user =(await _auth.signInWithEmailAndPassword(
          email: email, password: password)).user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
     User? user =(await _auth.createUserWithEmailAndPassword(
         email: email, password: password)).user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getCurrent() async {
    return _auth.currentUser;
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
    await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await _auth.signInWithCredential(credential);
    User? userDetail = result.user;

    FunctionToSaveAndGetData.saveUserNameSharedPreference(userDetail!.email!.replaceAll("@gmail.com", ""));
    FunctionToSaveAndGetData.saveUserEmailSharedPreference(userDetail.email!.replaceAll("", ""));

     Map<String, dynamic> userinfoMap = {
        "userName": userDetail.email!.replaceAll("@gmail.com", ""),
        "userEmail": userDetail.email!.replaceAll("", ""),
      };
      UserDatabase().uploadUserInfo(userinfoMap).then((val) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
      });
  }
      Future signOut() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
          return await _auth.signOut();
      }
    }

