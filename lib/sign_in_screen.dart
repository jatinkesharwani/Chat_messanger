import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'forget_password.dart';
import 'user_database.dart';
import 'firebase_authentication.dart';
import 'chat_screen.dart';
import 'help_function.dart';

class SignInPage extends StatefulWidget{

  final Function toggle;
  SignInPage(this.toggle);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>{

  final signinformkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  AuthenticationPage authenticationpage = new AuthenticationPage();
  UserDatabase userDatabase = new UserDatabase();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signInPressButton() async {
    if(signinformkey.currentState!.validate()) {
     setState(() {
        isLoading = true;
      });
     await authenticationpage.signInWithEmailAndPassword(emailTextEditingController.text,
         passwordTextEditingController.text).then((result) async{
       if(result!=null){

         QuerySnapshot snapshotUserInfo = await userDatabase.getUserByUseremail(emailTextEditingController.text);

         FunctionToSaveAndGetData.saveUserLoggedInSharedPreference(true);

         FunctionToSaveAndGetData.saveUserNameSharedPreference(snapshotUserInfo.docs[0]["userName"].toString());
         FunctionToSaveAndGetData.saveUserEmailSharedPreference(snapshotUserInfo.docs[0]["userEmail"].toString());

         Navigator.pushReplacement(context, MaterialPageRoute(
             builder: (context) => ChatPage()
         ));
       }
       else{
         setState(() {
           isLoading=false;
           showAlertDialog(context);
         });
       }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome To SignIn Screen ",textAlign: TextAlign.center,),
        toolbarHeight: 90,
        titleTextStyle: TextStyle(color: Colors.pink),
        backgroundColor: Colors.teal,
      ),

      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
        : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: signinformkey,
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
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: _obscureText,
                          validator: (val) {
                            return val!.length > 5
                                ? null
                                : "Please Enter minimum 6 characters";
                          },
                          controller: passwordTextEditingController,
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                              },
                             child:
                          Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                             ),
                            icon: Icon(
                              Icons.lock,
                              color: Colors.blueGrey,
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.blueGrey,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          alignment: Alignment.centerRight,
                          child: Text("Forget Password ?",
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  GestureDetector(
                    onTap: () {
                      signInPressButton();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
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
                      child: Text("Sign In",
                        style: TextStyle(
                          color: Color(0XFF8321F3),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  GestureDetector(
                    onTap: (){
                      authenticationpage.signInWithGoogle(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
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
                      child: Text("Sign In with google",
                        style: TextStyle(
                          color: Color(0XFF8321F3),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("don't have account?    ",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 16,
                        )
                        ,),
                      GestureDetector(
                        onTap: (){
                           widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now",
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            )
                            ,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 115,)
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
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Warning !"),
    content: Text("Please enter correct Email/Password"),
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