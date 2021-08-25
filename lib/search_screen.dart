import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:people_chat/chat_screen.dart';
import 'package:people_chat/user_database.dart';
import 'chat_between_users_screen.dart';

class SearchScreenPage extends StatefulWidget {
  @override
  _SearchScreenPageState createState() => _SearchScreenPageState();
}
class _SearchScreenPageState extends State<SearchScreenPage> {

  UserDatabase userDatabase = new UserDatabase();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot;
  bool isLoading=false;
  bool userNamesearch=false;

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }


  Widget searchList(){
    return userNamesearch ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context,index){
          return searchPage(
            searchSnapshot!.docs[index]["userName"],
            searchSnapshot!.docs[index]["userEmail"],
          );
        }): Container();
  }

  initiateSearch() async{
    if(searchTextEditingController.text.isNotEmpty){
      setState(() {
        isLoading=true;
      });
      await userDatabase.getUserByUsername(searchTextEditingController.text)
          .then((val){
        searchSnapshot = val;
        print("$searchSnapshot");
        setState(() {
          isLoading=false;
          userNamesearch=true;
        });
      });
    }
    else{
      showAlertDialogforemptysearch(context);
    }
  }
  chattingBetweenUsers(String userName){
    if(userName != Constants.myName){
      String userchatid = getChatRoomId(Constants.myName,userName);

      List<String> users = [Constants.myName,userName];
      Map<String,dynamic> userchatMap = {
        "users": users,
        "userchatid" : userchatid,
      };
      UserDatabase().createUserChat(userchatid,userchatMap);
      Navigator.push(context,MaterialPageRoute(
          builder: (context) => ChatBetweenUsersScreen(userchatid,userName)
      ));
    }
    else{
      showAlertDialog(context);
    }
  }

  Widget searchPage(String userName,String userEmail){
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFE7F436),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 35),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(color: Colors.black,fontSize: 16),),
              Text(userEmail,style: TextStyle(color: Colors.black, fontSize: 16),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              chattingBetweenUsers(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text("Message",style: TextStyle(color: Colors.white, fontSize: 16),),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Search Screen",textAlign: TextAlign.center,),
        toolbarHeight: 60,
        titleTextStyle: TextStyle(color: Colors.pink),
        backgroundColor: Colors.teal,
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 6),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.redAccent,
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.lightBlueAccent),
                      decoration: InputDecoration(
                        hintText: "Search Username.....",
                        hintStyle: TextStyle(
                          color: Colors.blue.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1ED8E9),
                                const Color(0xFF1ED8E9)
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}


showAlertDialog(BuildContext context) {

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Warning !"),
    content: Text("You can't send message yourself"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogforemptysearch(BuildContext context) {

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Request !"),
    content: Text("Please enter user detail"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


