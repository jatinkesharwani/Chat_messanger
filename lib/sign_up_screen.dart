import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:people_chat/help_function.dart';
import 'package:people_chat/starting_screen.dart';
import 'firebase_authentication.dart';
import 'forget_password.dart';
import 'user_database.dart';

class SignUpPage extends StatefulWidget{

  final Function toggleView;
  SignUpPage(this.toggleView);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{

  final signupformkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  AuthenticationPage authenticationpage = new AuthenticationPage();
  UserDatabase userDatabase = new UserDatabase();
  FunctionToSaveAndGetData functionToSaveAndGetData = new FunctionToSaveAndGetData();

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  TextEditingController confirmpasswordTextEditingController = new TextEditingController();


  signUpPressButton() async {
    if (signupformkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authenticationpage.registerWithEmailAndPassword(
          emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
        if (val != null) {
          Map<String, dynamic> userinfoMap = {
            "userName": userNameTextEditingController.text,
            "userEmail": emailTextEditingController.text
          };
          userDatabase.uploadUserInfo(userinfoMap);

          FunctionToSaveAndGetData.saveUserLoggedInSharedPreference(true);

          FunctionToSaveAndGetData.saveUserEmailSharedPreference(
              emailTextEditingController.text);
          FunctionToSaveAndGetData.saveUserNameSharedPreference(
              userNameTextEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => StartingPage()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome To SignUp Screen ",textAlign: TextAlign.center,),
        toolbarHeight: 90,
        titleTextStyle: TextStyle(color: Colors.pink),
        backgroundColor: Colors.teal,
      ),

      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Form(
                 key: signupformkey,
                 child: Column(
                   children: [
                     TextFormField(
                       controller: userNameTextEditingController,
                       validator: (val){
                         return val!.isEmpty || val.length < 4 ? "Please Enter minimum 4 characters" : null;
                       },
                       style: TextStyle(
                         color: Colors.blueGrey,
                       ),
                       decoration: InputDecoration(
                         icon: Icon(
                           Icons.face,
                           color: Colors.blueGrey,
                         ),
                         labelText: "User name",
                         labelStyle: TextStyle(
                           color: Colors.blueGrey,
                         ),
                         hintText: "User name",
                         hintStyle: TextStyle(
                           color: Colors.lightBlueAccent,
                         ),
                         focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.blue),
                         ),
                       ),
                     ),
                     TextFormField(
                       controller: emailTextEditingController,
                       validator: (val) {
                         return RegExp(
                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                             .hasMatch(val!)
                             ? null
                             : "Please Enter Correct Email";
                       },
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
                       controller: passwordTextEditingController,
                       validator:  (val){
                         return val!.length < 6 ? "Please Enter minimum 6 characters" : null;
                       },
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
                     TextFormField(
                       obscureText: _obscureText,
                       controller: confirmpasswordTextEditingController,
                       validator: (val){
                         if(val!.isEmpty)
                           return 'Please Enter Minimum 6 characters';
                         if(val != passwordTextEditingController.text)
                           return 'Password Not Match';
                         return null;
                       },
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
                         labelText: "Confirm password",
                         labelStyle: TextStyle(
                           color: Colors.blueGrey,
                         ),
                         hintText: "Confirm password",
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
                Padding(padding: EdgeInsets.only(top: 30)),
                GestureDetector(
                  onTap: () {
                    signUpPressButton();
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
                    child: Text("Sign Up",
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
                    AuthenticationPage().signInWithGoogle(context);
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
                    Text("Already have account?    ",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 16,
                      )
                      ,),
                    GestureDetector(
                      onTap: (){
                        widget.toggleView();
                      },
                      child: Text("Signin now",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        )
                        ,),
                    )
                  ],
                ),
                SizedBox(height: 123,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}