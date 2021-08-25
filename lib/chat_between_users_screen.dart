import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:people_chat/chat_screen.dart';
import 'user_database.dart';

class ChatBetweenUsersScreen extends StatefulWidget {

  final String userChatId;
  final String userName;
  ChatBetweenUsersScreen(this.userChatId,this.userName);

  @override
  _ChatBetweenUsersScreenState createState() => _ChatBetweenUsersScreenState();
}

class _ChatBetweenUsersScreenState extends State<ChatBetweenUsersScreen> {

  Stream<QuerySnapshot>? chatMessagesStream;

  UserDatabase userDatabase = new UserDatabase();
  TextEditingController messageController = new TextEditingController();

  showAlertDialogforemptymessage(BuildContext context) {

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Request !"),
      content: Text("you can't send empty messages !"),
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

Widget chatMessagesList(){
  return StreamBuilder<QuerySnapshot>(
    stream: chatMessagesStream,
    builder: (context,snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return MessageScreenPage(snapshot.data!.docs[index]["message"].toString(),
            snapshot.data!.docs[index]["sendby"].toString() == Constants.myName
          );
        }
      ) : Container();
    }
  );
}
sendMessages(bool sendClicked){

  if(messageController.text.isNotEmpty){
    Map<String,dynamic> messageMap = {
    "message": messageController.text,
    "sendby" : Constants.myName,
      'time' : DateTime.now().subtract(Duration(minutes: 1)),
  };
  userDatabase.addUserMessages(widget.userChatId,messageMap)
      .then((val){
    Map<String, dynamic> lastMessageMap = {
      "lastMessage": messageController.text,
      "lastMessageSendTs": DateTime.now().subtract(Duration(minutes: 1)),
      "lastMessageSendBy": Constants.myName,
    };
    userDatabase.updateLastMessageSend(widget.userChatId, lastMessageMap);
    if(sendClicked){
      messageController.text = "";
    }
  });
  }
  else{
    showAlertDialogforemptymessage(context);
  }
}

@override
void initState(){
  userDatabase.getUserMessages(widget.userChatId).then((val){
    setState(() {
      chatMessagesStream = val;
    });
  });
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.userName,textAlign: TextAlign.center,),
        toolbarHeight: 60,
        titleTextStyle: TextStyle(color: Colors.pink),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessagesList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black38.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),

                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.lightBlueAccent),
                        decoration: InputDecoration(
                          hintText: "Type a Message.....",
                          hintStyle: TextStyle(
                            color: Colors.lightBlueAccent,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                       sendMessages(true);
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
                        child: Image.asset("assets/images/send_message.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageScreenPage extends StatelessWidget{
  final String message;
  final bool sendByMe;
  MessageScreenPage(this.message,this.sendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 6,bottom: 6,
        left: sendByMe ? 0:24,
        right: sendByMe ? 24:0,
      ),
      margin: sendByMe
          ? EdgeInsets.only(left: 30)
          : EdgeInsets.only(right: 30),
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: sendByMe ? [
              const Color(0XFFE9DF1E),
              const Color(0XFFE9DF1E)
            ] : [
              const Color(0XFF1EE98A),
              const Color(0XFF1EE98A)
              ],
          ),
        borderRadius: sendByMe ? BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18)
        ) :
       BorderRadius.only(
           topLeft: Radius.circular(18),
           topRight: Radius.circular(18),
           bottomRight: Radius.circular(18),
       )
        ),
        child: Text(message,style: TextStyle(color: Colors.black, fontSize: 18),),
      ),
    );
  }
}