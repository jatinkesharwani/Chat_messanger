import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:people_chat/help_function.dart';
import 'package:people_chat/user_database.dart';
import 'chat_between_users_screen.dart';
import 'firebase_authentication.dart';
import 'auth_signin_signup.dart';
import 'search_screen.dart';
import 'user_database.dart';

class Constants{
  static String myName = "";
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  AuthenticationPage authenticationpage = new AuthenticationPage();
  UserDatabase userDatabase = new UserDatabase();

  Stream<QuerySnapshot>? userChatsStream;

  Widget userChatList(){
    return StreamBuilder<QuerySnapshot>(
      stream: userChatsStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return UserChatTile(
              userName: snapshot.data!.docs[index]["userchatid"].toString()
                  .replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
              userchatid: snapshot.data!.docs[index]["userchatid"].toString(),
              lastMessage: snapshot.data!.docs[index]["lastMessage"].toString(),
              lastMessageSendTs: snapshot.data!.docs[index]["lastMessageSendTs"].toString().replaceAll("at", "")
                  .replaceAll("UTC+5:30", ""),
            );
          },
        ) : Container();
      },
    );
  }

  void initState(){
    getUserInfo();
    super.initState();
  }
  getUserInfo() async {
    Constants.myName = (await FunctionToSaveAndGetData.getUserNameSharedPreference())!;
    userDatabase.getUserChats(Constants.myName).then((val){
      setState(() {
        userChatsStream = val;
          });
    });
  }

  showAlertDialog(BuildContext context) {

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("LogOut"),
      onPressed:  () {
        authenticationpage.signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Authenticate()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Log out ?"),
      content: Text("Are you sure you want to log out ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User List Screen",textAlign: TextAlign.center,),
        toolbarHeight: 60,
        titleTextStyle: TextStyle(color: Colors.pink),
        backgroundColor: Colors.teal,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              showAlertDialog(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),

            ),
          ),
        ],
      ),

      body: Container(
        child: userChatList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreenPage()));
        },
      ),
    );
  }
}

class UserChatTile extends StatelessWidget{

  final String userName;
  final String userchatid;
  final String lastMessage;
  final String lastMessageSendTs;
  UserChatTile({required this.userName,required this.userchatid,required this.lastMessage,required this.lastMessageSendTs});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatBetweenUsersScreen(
                userchatid,userName)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),

            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 17,
                  ),),
                SizedBox(width: 3,),
                Text(lastMessage,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




