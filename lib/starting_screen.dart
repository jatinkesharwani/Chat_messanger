import 'package:flutter/material.dart';
import 'package:people_chat/chat_screen.dart';

class StartingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2,),
            Image.asset("assets/images/startingimage.PNG"),
            Spacer(flex: 1,),
            Text("Welcome to our people chat messanger app",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
            ),
            Spacer(flex: 1,),
            FittedBox(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0XFFE7F436),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(
                        "Start Messaging",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
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


