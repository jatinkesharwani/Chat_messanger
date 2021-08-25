import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:people_chat/auth_signin_signup.dart';
import 'package:people_chat/chat_screen.dart';
import 'package:people_chat/firebase_authentication.dart';
import 'help_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState(){
    super.initState();
  }

  getLoggedInState() async {
    await FunctionToSaveAndGetData.getUserLoggedInSharedPreference()
        .then((val){
          setState(() {
            getLoggedInState();
            userIsLoggedIn = val!;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PEOPLE CHAT MESSANGER APP",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
      home: FutureBuilder(future:AuthenticationPage().getCurrent() ,builder: (context,AsyncSnapshot<dynamic> snapshot){if(snapshot.hasData){return ChatPage();}
      else{return Authenticate();}})
    );
  }
}