import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:people_chat/auth_signin_signup.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  late String _email;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  TextEditingController emailTextEditingController = new TextEditingController();
  final requestformkey = GlobalKey<FormState>();

  forgetPasswordPsessButton() async {
    if (requestformkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      auth.sendPasswordResetEmail(email: _email);
      showAlertDialog(context);
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Forget Password Screen ",textAlign: TextAlign.center,),
          toolbarHeight: 90,
          titleTextStyle: TextStyle(color: Colors.pink),
          backgroundColor: Colors.teal,
        ),

        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: requestformkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                                ? null
                                : "Please Enter Correct Email";
                          },
                          controller: emailTextEditingController,
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.mail_rounded,
                              color: Colors.blueGrey,
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.blueGrey,
                            ),
                            hintText: "email",
                            hintStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _email = value.trim();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  GestureDetector(
                    onTap: () {
                      forgetPasswordPsessButton();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0XFF00BF7C),
                            const Color(0XFFFE9901),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text("Send Request",
                        style: TextStyle(
                          color: Color(0XFF8321F3),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 330,)
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Authenticate()
        ));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Request !"),
      content: Text("please check your email"),
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